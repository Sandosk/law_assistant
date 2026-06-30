import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:investigator/core/api_constants.dart';
import 'package:investigator/features/legal_chatbot/data/model/legal_chat_entity.dart';
import 'package:investigator/features/legal_chatbot/data/model/result_entity.dart';

@lazySingleton
class LegalChatApi {
  // تم تغيير اسم الميثود ليكون معبراً عن وظيفة الـ chatbot الجديد
  Future<LegalChatbotEntity> askChatbot(String question) async {
    final url = APIConstants.chatbot;

    try {
      print('=== [LegalChatApi] بدء إرسال الطلب ===');
      print('الرابط المستهدف (URL): $url');
      print('السؤال المرسل (Question): "$question"');

      // تجهيز جسم الطلب (Body) وتحويله إلى JSON
      final requestBody = jsonEncode({'question': question});
      print('جسم الطلب بعد التشفير (Request Body): $requestBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: requestBody,
      );

      print('=== [LegalChatApi] تم استقبال استجابة من السيرفر ===');
      print('كود الحالة (Status Code): ${response.statusCode}');

      // طباعة الـ body الخام القادم من السيرفر قبل معالجته
      print('الاستجابة الخام (Raw Response Body): ${response.body}');

      // التحقق من استجابة السيرفر
      if (response.statusCode == 200) {
        print('-> نجاح الطلب (كود 200). جاري فك التشفير بدعم اللغة العربية...');

        // فك تشفير النصوص العربية بشكل سليم لحمايتها من التشويه (UTF-8)
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        print('-> البيانات بعد فك التشفير والتحويل لـ JSON: $decodedBody');

        final entity = LegalChatbotEntity.fromJson(decodedBody);
        print('-> تم تحويل البيانات بنجاح إلى LegalChatbotEntity');
        print('=== [LegalChatApi] نهاية العملية بنجاح ===');

        return entity;
      } else {
        // في حال رجع السيرفر كود خطأ مثل 400 أو 500
        print('❌ خطأ: السيرفر أعاد كود حالة غير ناجح: ${response.statusCode}');
        print('محتوى خطأ السيرفر: ${response.body}');
        throw Exception(
            'Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error, stackTrace) {
      // طباعة أي خطأ برمي (مثل عدم وجود إنترنت، خطأ في الـ Parsing، أو خطأ في الرابط)
      print('❌❌ [LegalChatApi] حدث استثناء (Exception) غير متوقع! ❌❌');
      print('نوع الخطأ: $error');
      print('تفاصيل مكان الخطأ في الكود (Stack Trace):\n$stackTrace');

      // إعادة رمي الخطأ حتى تستقبله الـ UI أو الـ Bloc/Provider وتتعامل معه
      rethrow;
    }
  }

  Future<ResultEntity> getJobResult(String jobId) async {
    // دمج الـ job_id جوة الـ URL كـ Path Parameter زي الصورة بالظبط
    final url = '${APIConstants.getResult}/$jobId';

    try {
      print('=== [LegalChatApi] بدء إرسال طلب جلب النتيجة ===');
      print('الرابط المستهدف (URL): $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('=== [LegalChatApi] تم استقبال استجابة جلب النتيجة ===');
      print('كود الحالة (Status Code): ${response.statusCode}');
      print('الاستجابة الخام (Raw Response Body): ${response.body}');

      if (response.statusCode == 200) {
        print('-> نجاح جلب النتيجة (كود 200). جاري معالجة البيانات...');

        // فك التشفير بدعم اللغة العربية UTF-8
        final decodedBody = jsonDecode(utf8.decode(response.bodyBytes));
        print('-> البيانات بعد فك التشفير: $decodedBody');

        // تحويل البيانات للـ ResultEntity المؤمنة بدون مناداة ميثودز إضافية
        final entity = ResultEntity(decodedBody);
        print('-> تم تحويل البيانات بنجاح إلى ResultEntity');
        print('=== [LegalChatApi] نهاية العملية بنجاح ===');

        return entity;
      } else {
        print('❌ خطأ: السيرفر أعاد كود حالة غير ناجح: ${response.statusCode}');
        throw Exception(
            'Server Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error, stackTrace) {
      print('❌❌ [LegalChatApi] حدث استثناء أثناء جلب النتيجة! ❌❌');
      print('نوع الخطأ: $error');
      print('مكان الخطأ:\n$stackTrace');
      rethrow;
    }
  }
}
