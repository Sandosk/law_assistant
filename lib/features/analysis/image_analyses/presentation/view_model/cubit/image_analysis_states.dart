import 'package:investigator/features/analysis/model/analysis_response.dart';

abstract class ImageAnalysisState {}

class ImageAnalysisInitial extends ImageAnalysisState {}

class ImageAnalysisLoading extends ImageAnalysisState {}

class ImageAnalysisSuccess extends ImageAnalysisState {
  final AnalysisResponse response;

  ImageAnalysisSuccess(this.response);
}

class ImageAnalysisError extends ImageAnalysisState {
  final String message;

  ImageAnalysisError(this.message);
}
