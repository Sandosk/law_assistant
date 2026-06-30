import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:investigator/features/legal_chatbot/data/api/legal_chatbot_api.dart';
import 'package:investigator/features/legal_chatbot/presentation/view_model/cubit/leagel_chatbot_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LegalChatCubit extends Cubit<LegalChatState> {
  final LegalChatApi _api;
  Timer? _pollingTimer;

  LegalChatCubit(LegalChatApi api)
      : _api = api,
        super(LegalChatInitial());

  Future<void> sendLegalQuestion(String question) async {
    if (question.trim().isEmpty) return;

    // إيقاف أي تايمر قديم شغال احتياطاً
    _pollingTimer?.cancel();

    emit(LegalChatLoading());

    try {
      // 1. مناداة الـ API الأولى للحصول على الـ job_id
      final firstResponse = await _api.askChatbot(question);
      final jobId = firstResponse.jobId ?? '';

      if (jobId.isEmpty) {
        emit(LegalChatError("لم يتم استلام معرف العملية (Job ID) من السيرفر"));
        return;
      }

      // 2. حفظ الـ job_id في الـ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('job_id', jobId);

      print('=== [Cubit] تم حفظ الـ Job ID وبدء الفحص الدوري كل دقيقة ===');

      // 3. بدء عملية الـ Polling الدوري فوراً وكل دقيقة (60 ثانية)
      _startPolling(jobId);
    } catch (e) {
      emit(LegalChatError(e.toString()));
    }
  }

  // دالة الفحص الدوري عن النتيجة
  void _startPolling(String jobId) {
    // ميثود داخلية لتنفيذ الفحص مرة واحدة
    Future<void> checkResult() async {
      try {
        print('=== [Cubit] جاري فحص حالة الـ Job الآن... ===');
        final resultEntity = await _api.getJobResult(jobId);

        if (resultEntity.status == 'completed') {
          print('=== [Cubit] اكتملت المعالجة بنجاح! إيقاف التايمر ===');
          _pollingTimer?.cancel(); // إيقاف التكرار فوراً
          emit(LegalChatSuccess(resultEntity)); // إرسال النتيجة النهائية للـ UI
        } else {
          print(
              '=== [Cubit] الحالة لا تزال "processing"، سيتم الفحص مجدداً بعد دقيقة ===');
          // بنسيب الـ UI على حالة الـ Loading أو ممكن تعمل State مخصصة لو حابب
        }
      } catch (e) {
        print('❌ [Cubit] حدث خطأ أثناء الفحص الدوري: $e');
        _pollingTimer
            ?.cancel(); // إيقاف التايمر في حالة الخطأ عشان ميفضلش يبعت لوب أبدي
        emit(LegalChatError(e.toString()));
      }
    }

    // استدعاء الفحص لأول مرة فوراً دون انتظار الدقيقة الأولى
    checkResult();

    // إعداد التايمر ليتكرر كل 60 ثانية
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      checkResult();
    });
  }

  // تذكر دائماً إغلاق الـ Timer عند تدمير الـ Cubit لحماية الـ Memory Leak
  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
