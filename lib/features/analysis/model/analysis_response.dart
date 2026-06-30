enum FileType { image, video, audio }

class AnalysisResponse {
  final String result;
  final double confidence; // 🟢 تم التغيير إلى double ليتوافق مع رد السيرفر
  final String disclaimer;

  AnalysisResponse({
    required this.result,
    required this.confidence,
    required this.disclaimer,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      result: json['result'] ?? '',

      // 🟢 تعديل القراءة للتأكد من تحويل الرقم إلى double بأمان حتى لو جاء int أو null
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,

      disclaimer: json['disclaimer'] ?? '',
    );
  }
}
