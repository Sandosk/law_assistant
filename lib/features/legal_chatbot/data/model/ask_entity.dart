class AskEntity {
  String? jobId;
  String? status;

  AskEntity(jsonDecode, {this.jobId, this.status});

  AskEntity.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'] ?? '';
    status = json['status'] ?? '';
  }
}
