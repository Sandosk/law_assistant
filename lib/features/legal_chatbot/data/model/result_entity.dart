class ResultEntity {
  final String status;
  final Result result;

  // Constructor بياخذ الـ Map مباشرة وبيأمن القيم
  ResultEntity(Map<String, dynamic> json)
      : status = json['status'] ?? '',
        result = Result(json['result'] ?? {});
}

class Result {
  final String answer;
  final List<RetrievedArticles> retrievedArticles;
  final List<SimilarCases> similarCases;

  Result(Map<String, dynamic> json)
      : answer = json['answer'] ?? '',
        // لو القائمة جات null بيعمل قائمة فاضية [] عشان الكود ميبوظش
        retrievedArticles = (json['retrieved_articles'] as List?)
                ?.map((v) => RetrievedArticles(v ?? {}))
                .toList() ??
            [],
        similarCases = (json['similar_cases'] as List?)
                ?.map((v) => SimilarCases(v ?? {}))
                .toList() ??
            [];
}

class RetrievedArticles {
  final String lawName;
  final int articleNumber; // خليتهالك int علشان تأمين الصفر اللي طلبته
  final String text;

  RetrievedArticles(Map<String, dynamic> json)
      : lawName = json['law_name'] ?? '',
        // هنا لو رقم المادة جه null أو مش موجود، هيتحول لـ 0 تلقائياً
        articleNumber =
            int.tryParse(json['article_number']?.toString() ?? '') ?? 0,
        text = json['text'] ?? '';
}

class SimilarCases {
  final String caseLabel;
  final String sourceFile;
  final String summary;

  SimilarCases(Map<String, dynamic> json)
      : caseLabel = json['case_label'] ?? '',
        sourceFile = json['source_file'] ?? '',
        summary = json['summary'] ?? '';
}
