class LegalChatbotEntity {
  String? jobId;
  String? status;

  LegalChatbotEntity({this.jobId, this.status});

  LegalChatbotEntity.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    status = json['status'];
  }
}
