import 'package:investigator/features/analysis/model/analysis_response.dart';

abstract class AudioAnalysisState {}

class AudioAnalysisInitial extends AudioAnalysisState {}

class AudioAnalysisLoading extends AudioAnalysisState {}

class AudioAnalysisSuccess extends AudioAnalysisState {
  final AnalysisResponse
      response; // يمكنك تغيير الموديل لاحقاً إذا كان هناك موديل مخصص للصوت

  AudioAnalysisSuccess(this.response);
}

class AudioAnalysisError extends AudioAnalysisState {
  final String message;

  AudioAnalysisError(this.message);
}
