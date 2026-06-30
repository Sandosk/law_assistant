import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:investigator/core/api_constants.dart';
import 'package:investigator/features/legal_chatbot/data/model/legal_chat_entity.dart';
import 'package:investigator/features/video_description/data/model/video_description_entity.dart';

@lazySingleton
class VideoDescriptionApi {
  Future<LegalChatbotEntity> videoDescription(File videoFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(APIConstants.videoDescription),
    );

    // إضافة ملف الفيديو للطلب تحت حقل الـ 'file' كما يتوقع السيرفر
    request.files.add(
      await http.MultipartFile.fromPath('file', videoFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      // فك التشفير بدعم الـ UTF-8 للتأكد من سلامة النصوص العربية القادمة من السيرفر
      final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));

      // تحويل البيانات لـ LegalChatbotEntity باستخدام الـ Constructor المباشر
      return LegalChatbotEntity.fromJson(decodedBody);
    }

    throw Exception(
        'Failed to analyze video: ${response.statusCode} - ${response.body}');
  }

  /// الدالة المسؤولة عن الفحص الدوري (Polling) لجلب نتيجة الفيديو بناءً على الـ jobId
  Future<VideoDescriptionEntity> getJobResult(String jobId) async {
    // دمج الـ job_id داخل الـ URL كـ Path Parameter
    final url = '${APIConstants.getResult}/$jobId';

    try {
      print('=== [VideoDescriptionApi] بدء إرسال طلب جلب نتيجة الفيديو ===');
      print('الرابط المستهدف (URL): $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('=== [VideoDescriptionApi] تم استقبال استجابة جلب النتيجة ===');
      print('كود الحالة (Status Code): ${response.statusCode}');
      print('الاستجابة الخام (Raw Response Body): ${response.body}');

      if (response.statusCode == 200) {
        print(
            '-> نجاح جلب النتيجة (كود 200). جاري معالجة وفك تشفير البيانات...');

        // فك التشفير بدعم اللغة العربية UTF-8
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        print('-> البيانات بعد فك التشفير: $decodedBody');

        // تحويل البيانات إلى الـ VideoDescriptionEntity المؤمنة بدون ميثودز إضافية
        final entity = VideoDescriptionEntity(decodedBody);
        print('-> تم تحويل البيانات بنجاح إلى VideoDescriptionEntity');
        print('=== [VideoDescriptionApi] نهاية عملية جلب النتيجة بنجاح ===');

        return entity;
      } else {
        print(
            '❌ خطأ: السيرفر أعاد كود حالة غير ناجح أثناء جلب النتيجة: ${response.statusCode}');
        throw Exception(
            'Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error, stackTrace) {
      print('❌❌ [VideoDescriptionApi] حدث استثناء أثناء جلب نتيجة الـ job! ❌❌');
      print('نوع الخطأ: $error');
      print('مكان الخطأ:\n$stackTrace');
      rethrow;
    }
  }
}
