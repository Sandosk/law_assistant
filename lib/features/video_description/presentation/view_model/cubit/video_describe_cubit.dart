import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:investigator/features/legal_chatbot/data/model/legal_chat_entity.dart';
import 'dart:async';
import 'package:investigator/features/video_description/data/api/video_description_api.dart';
import 'package:investigator/features/video_description/presentation/view_model/cubit/video_describe_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class VideoDescriptionCubit extends Cubit<VideoDescriptionState> {
  final VideoDescriptionApi _api;
  Timer? _pollingTimer; // تايمر التحكم في الفحص الدوري كل دقيقة

  VideoDescriptionCubit(VideoDescriptionApi api)
      : _api = api,
        super(VideoDescriptionInitial());

  /// الدالة الأساسية لرفع الفيديو وبدء الفحص الدوري الدوري
  Future<void> analyzeVideo(File videoFile) async {
    // 1. التحقق من امتداد الملف
    if (!videoFile.path.toLowerCase().endsWith('.mp4')) {
      emit(VideoDescriptionError("عذراً، يجب اختيار ملف فيديو بصيغة .mp4 فقط"));
      return;
    }

    // إيقاف أي تايمر قديم شغال احتياطاً
    _pollingTimer?.cancel();

    emit(VideoDescriptionLoading());

    try {
      print('=== [VideoCubit] بدء رفع الفيديو الأول ===');

      // 2. رفع الفيديو واستلام الرد المبدئي من نوع LegalChatbotEntity
      final firstResponse = await _api.videoDescription(videoFile);

      // جلب الـ job_id مباشرة من الـ entity الجديدة (تأكدي من اسم الحقل المتوفر لديكِ في الـ Entity، مثلاً jobId)
      final jobId = firstResponse.jobId;

      if (jobId!.isEmpty) {
        emit(VideoDescriptionError(
            "لم يتم استلام معرف العملية (Job ID) من السيرفر"));
        return;
      }

      // 3. حفظ الـ job_id في الـ SharedPreferences بشكل ديناميكي
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('video_job_id', jobId);

      print(
          '=== [VideoCubit] تم حفظ الـ Job ID ($jobId) بنجاح وبدء الفحص الدوري كل دقيقة ===');

      // 4. بدء عملية الـ Polling الدوري
      _startVideoPolling(jobId);
    } catch (e) {
      print('❌ [VideoCubit] خطأ أثناء رفع الفيديو: $e');
      emit(VideoDescriptionError(e.toString()));
    }
  }

  /// دالة الفحص الدوري المستمر عن نتيجة الفيديو
  /// دالة الفحص الدوري المستمر عن نتيجة الفيديو مع ميزة إعادة المحاولة التلقائية
  void _startVideoPolling(String jobId) {
    Future<void> checkVideoStatus() async {
      try {
        print('=== [VideoCubit] جاري فحص حالة الفيديو الآن... ===');
        final currentEntity = await _api.getJobResult(jobId);

        if (currentEntity.status == 'completed') {
          print(
              '=== [VideoCubit] اكتملت معالجة الفيديو بنجاح! إيقاف التايمر ===');
          _pollingTimer?.cancel();
          emit(VideoDescriptionSuccess(currentEntity));
        } else {
          print(
              '=== [VideoCubit] حالة الفيديو لا تزال "${currentEntity.status}"، سيتم الفحص مجدداً بعد دقيقة ===');
        }
      } catch (e) {
        print('❌ [VideoCubit] حدث استثناء أثناء الفحص: $e');

        // تحويل الخطأ إلى نص لفحصه
        final errorString = e.toString().toLowerCase();

        // التحقق مما إذا كان الخطأ بسبب Ngrok أو انقطاع مفاجئ في الاتصال
        if (errorString.contains('connection closed') ||
            errorString.contains('clientexception') ||
            errorString.contains('handshake_error')) {
          print(
              '⚠️ [VideoCubit] خطأ غريب في الاتصال (غالباً Ngrok)! لن نوقف التايمر، سنحاول مجدداً بعد دقيقة تلقائياً...');
          // هنا لا نرسل emit(VideoDescriptionError) ولا نوقف التايمر (_pollingTimer?.cancel)
          // نترك الـ UI مستقراً على حالة الـ Loading والتايمر سيعيد المحاولة في الدورة القادمة
        } else {
          // إذا كان الخطأ حقيقياً ومختلفاً (مثلاً السيرفر عاد بكود 500 أو 404)، نوقف التايمر ونظهر الخطأ
          print(
              '❌ [VideoCubit] خطأ حقيقي دائم، يتم إيقاف التايمر وإرسال الحالة للـ UI');
          _pollingTimer?.cancel();
          emit(VideoDescriptionError(e.toString()));
        }
      }
    }

    // استدعاء الفحص لأول مرة فوراً
    checkVideoStatus();

    // تكرار العملية كل دقيقة
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      checkVideoStatus();
    });
  }

  // إغلاق التايمر عند تدمير الـ Cubit لحماية الـ Memory من التسريب
  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
