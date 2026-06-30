import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:investigator/features/analysis/audio_analysis/data/api/audio_analysis_api.dart';
import 'package:investigator/features/analysis/audio_analysis/presentation/view_model/cubit/audio_analysis_states.dart';

@injectable
class AudioAnalysisCubit extends Cubit<AudioAnalysisState> {
  final AudioAnalysisApi _api;

  AudioAnalysisCubit(AudioAnalysisApi api)
      : _api = api,
        super(AudioAnalysisInitial());
  Future<void> analyzeAudio(File audioFile) async {
    // التحقق من امتداد الملف (بتحويل المسار لحروف صغيرة والتأكد من انتهائه بـ .wav)
    if (!audioFile.path.toLowerCase().endsWith('.wav')) {
      emit(AudioAnalysisError("عذراً، يجب اختيار ملف صوتی بصيغة .wav فقط"));
      return;
    }

    emit(AudioAnalysisLoading());

    try {
      final response = await _api.detectAudio(audioFile);
      emit(AudioAnalysisSuccess(response));
    } catch (e) {
      emit(AudioAnalysisError(e.toString()));
    }
  }
}
