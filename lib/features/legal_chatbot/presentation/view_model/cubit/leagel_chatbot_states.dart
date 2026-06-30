import 'package:investigator/features/legal_chatbot/data/model/result_entity.dart';

abstract class LegalChatState {}

class LegalChatInitial extends LegalChatState {}

// حالة التحميل الأساسية عند إرسال السؤال أول مرة
class LegalChatLoading extends LegalChatState {}

// حالة نجاح العملية بالكامل وعودة الإجابة النهائية والقوانين
class LegalChatSuccess extends LegalChatState {
  final ResultEntity result;

  LegalChatSuccess(this.result);
}

// في حال حدوث أي خطأ في أي مرحلة
class LegalChatError extends LegalChatState {
  final String message;

  LegalChatError(this.message);
}
