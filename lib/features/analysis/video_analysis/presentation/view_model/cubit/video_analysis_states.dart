import 'package:investigator/features/analysis/model/analysis_response.dart';

abstract class VideoAnalysisState {}

class VideoAnalysisInitial extends VideoAnalysisState {}

class VideoAnalysisLoading extends VideoAnalysisState {}

class VideoAnalysisSuccess extends VideoAnalysisState {
  final AnalysisResponse response;

  VideoAnalysisSuccess(this.response);
}

class VideoAnalysisError extends VideoAnalysisState {
  final String message;

  VideoAnalysisError(this.message);
}
