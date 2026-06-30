// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:investigator/features/analysis/audio_analysis/data/api/audio_analysis_api.dart'
    as _i468;
import 'package:investigator/features/analysis/audio_analysis/presentation/view_model/cubit/audio_analysis_cubit.dart'
    as _i1009;
import 'package:investigator/features/analysis/image_analyses/data/api/image_analysis_api.dart'
    as _i888;
import 'package:investigator/features/analysis/image_analyses/presentation/view_model/cubit/image_analysis_cubit.dart'
    as _i974;
import 'package:investigator/features/analysis/video_analysis/data/api/video_analysis_api.dart'
    as _i705;
import 'package:investigator/features/analysis/video_analysis/presentation/view_model/cubit/video_analysis_cubit.dart'
    as _i269;
import 'package:investigator/features/legal_chatbot/data/api/legal_chatbot_api.dart'
    as _i789;
import 'package:investigator/features/legal_chatbot/presentation/view_model/cubit/legal_chatbot_cubit.dart'
    as _i947;
import 'package:investigator/features/video_description/data/api/video_description_api.dart'
    as _i1004;
import 'package:investigator/features/video_description/presentation/view_model/cubit/video_describe_cubit.dart'
    as _i1019;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i468.AudioAnalysisApi>(() => _i468.AudioAnalysisApi());
    gh.lazySingleton<_i888.ImageAnalysisApi>(() => _i888.ImageAnalysisApi());
    gh.lazySingleton<_i705.VideoAnalysisApi>(() => _i705.VideoAnalysisApi());
    gh.lazySingleton<_i789.LegalChatApi>(() => _i789.LegalChatApi());
    gh.lazySingleton<_i1004.VideoDescriptionApi>(
        () => _i1004.VideoDescriptionApi());
    gh.factory<_i1009.AudioAnalysisCubit>(
        () => _i1009.AudioAnalysisCubit(gh<_i468.AudioAnalysisApi>()));
    gh.factory<_i269.VideoAnalysisCubit>(
        () => _i269.VideoAnalysisCubit(gh<_i705.VideoAnalysisApi>()));
    gh.factory<_i974.ImageAnalysisCubit>(
        () => _i974.ImageAnalysisCubit(gh<_i888.ImageAnalysisApi>()));
    gh.factory<_i947.LegalChatCubit>(
        () => _i947.LegalChatCubit(gh<_i789.LegalChatApi>()));
    gh.factory<_i1019.VideoDescriptionCubit>(
        () => _i1019.VideoDescriptionCubit(gh<_i1004.VideoDescriptionApi>()));
    return this;
  }
}
