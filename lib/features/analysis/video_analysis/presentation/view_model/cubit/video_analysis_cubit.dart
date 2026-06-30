import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:investigator/features/analysis/video_analysis/data/api/video_analysis_api.dart';
import 'package:investigator/features/analysis/video_analysis/presentation/view_model/cubit/video_analysis_states.dart';

@injectable
class VideoAnalysisCubit extends Cubit<VideoAnalysisState> {
  final VideoAnalysisApi _api;

  VideoAnalysisCubit(VideoAnalysisApi api)
      : _api = api,
        super(VideoAnalysisInitial());

  Future<void> analyzeVideo(File videoFile) async {
    emit(VideoAnalysisLoading());

    try {
      // استدعاء الـ API الخاص بالفيديو وتمرير ملف الفيديو له
      final response = await _api.detectVideo(videoFile);

      emit(VideoAnalysisSuccess(response));
    } catch (e) {
      emit(VideoAnalysisError(e.toString()));
    }
  }
}
