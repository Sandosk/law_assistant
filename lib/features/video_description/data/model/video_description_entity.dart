class VideoDescriptionEntity {
  final String status;
  final Result result;

  VideoDescriptionEntity(Map<String, dynamic> json)
      : status = json['status'] ?? '',
        // إذا كان الـ result بـ null أو جاءت الـ status منفردة، نمرر map فارغ لتأمين الـ properties داخله
        result = Result(
            json['result'] is Map<String, dynamic> ? json['result'] : {});
}

class Result {
  final String caseId;
  final String videoDescription;
  final String crimeReport;
  final String legalSummary;
  final String answer;
  final List<RetrievedArticles> retrievedArticles;
  final String disclaimer;

  Result(Map<String, dynamic> json)
      : caseId = json['case_id'] ?? '',
        videoDescription = json['video_description'] ?? '',
        crimeReport = json['crime_report'] ?? '',
        legalSummary = json['legal_summary'] ?? '',
        answer = json['answer'] ?? '',
        disclaimer = json['disclaimer'] ?? '',
        retrievedArticles = (json['retrieved_articles'] as List?)
                ?.map((v) =>
                    RetrievedArticles(v is Map<String, dynamic> ? v : {}))
                .toList() ??
            [];
}

class RetrievedArticles {
  final String lawName;
  final int articleNumber;
  final String text;

  RetrievedArticles(Map<String, dynamic> json)
      : lawName = json['law_name'] ?? '',
        text = json['text'] ?? '',
        articleNumber =
            int.tryParse(json['article_number']?.toString() ?? '') ?? 0;
}
