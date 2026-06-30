import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:investigator/core/api_constants.dart';
import 'package:investigator/features/analysis/model/analysis_response.dart';

@lazySingleton
class ImageAnalysisApi {
  Future<AnalysisResponse> detectImage(File imageFile) async {
    final url = APIConstants.detectImage;

    try {
      print('=== [ImageAnalysisApi] بدء إرسال طلب تحليل الصورة ===');
      print('الرابط المستهدف (URL): $url');
      print('مسار الملف المحلي (File Path): ${imageFile.path}');

      // التحقق من وجود الملف قبل الرفع
      if (!await imageFile.exists()) {
        print('❌ خطأ: الملف غير موجود على الجهاز في المسار المحدد!');
      }

      final request = http.MultipartRequest('POST', Uri.parse(url));

      // إضافة الملف للطلب
      print('جاري تجهيز الملف وإضافته للـ MultipartRequest...');
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      print('جاري إرسال الطلب إلى السيرفر (Streamed Request)...');
      final streamedResponse = await request.send();

      print('=== [ImageAnalysisApi] تم استقبال الاستجابة المتدفقة ===');
      print('كود الحالة المبدئي (Status Code): ${streamedResponse.statusCode}');

      // تحويل الـ Stream إلى Response عادي لقراءة المحتوى
      print('جاري تحويل الـ Stream إلى Response لقراءة جسم الاستجابة...');
      final response = await http.Response.fromStream(streamedResponse);

      print('كود الحالة النهائي: ${response.statusCode}');
      print('الاستجابة الخام من السيرفر (Raw Body): ${response.body}');

      // التحقق من استجابة السيرفر
      if (response.statusCode == 200) {
        print('-> نجاح الطلب (كود 200). جاري معالجة الـ JSON...');

        // فك التشفير مع دعم النصوص العربية لحمايتها من التشويه
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        print('-> البيانات المستلمة بعد فك التشفير: $decodedBody');

        final analysisResponse = AnalysisResponse.fromJson(decodedBody);
        print('-> تم تحويل البيانات بنجاح إلى AnalysisResponse');
        print('=== [ImageAnalysisApi] نهاية العملية بنجاح ===');

        return analysisResponse;
      } else {
        // في حال أرجع السيرفر كود خطأ (400, 404, 500...)
        print('❌ خطأ: السيرفر أعاد كود حالة فشل: ${response.statusCode}');
        try {
          // محاولة فك تشفير محتوى الخطأ لقراءته بالعربية لو أمكن
          final errorBody = utf8.decode(response.bodyBytes);
          print('محتوى رسالة الخطأ القادمة من السيرفر: $errorBody');
        } catch (e) {
          print(
              'تعذر فك تشفير رسالة الخطأ كـ UTF-8، الاستجابة الأصلية: ${response.body}');
        }

        throw Exception(
            'Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error, stackTrace) {
      // التقاط أي أخطاء كراش أو انقطاع شبكة أو مشكلة في الـ Parsing
      print('❌❌ [ImageAnalysisApi] حدث استثناء (Exception) غير متوقع! ❌❌');
      print('نوع الخطأ (Error): $error');
      print('تفاصيل مكان الخطأ (Stack Trace):\n$stackTrace');

      // إعادة رمي الخطأ للـ Cubit
      rethrow;
    }
  }
}
