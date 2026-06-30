import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:investigator/features/analysis/image_analyses/data/api/image_analysis_api.dart';
import 'package:investigator/features/analysis/image_analyses/presentation/view_model/cubit/image_analysis_states.dart';

@injectable
class ImageAnalysisCubit extends Cubit<ImageAnalysisState> {
  final ImageAnalysisApi _api;

  ImageAnalysisCubit(ImageAnalysisApi api)
      : _api = api,
        super(ImageAnalysisInitial());
  Future<void> detectImage(File imageFile) async {
    emit(ImageAnalysisLoading());

    try {
      final response = await _api.detectImage(imageFile);

      emit(ImageAnalysisSuccess(response));
    } catch (e) {
      emit(ImageAnalysisError(e.toString()));
    }
  }
}
