import 'package:investigator/features/video_description/data/model/video_description_entity.dart';

abstract class VideoDescriptionState {}

class VideoDescriptionInitial extends VideoDescriptionState {}

class VideoDescriptionLoading extends VideoDescriptionState {}

class VideoDescriptionSuccess extends VideoDescriptionState {
  final VideoDescriptionEntity response; // 👈 تأكدي أنها VideoDescriptionEntity

  VideoDescriptionSuccess(this.response);
}

class VideoDescriptionError extends VideoDescriptionState {
  final String message;

  VideoDescriptionError(this.message);
}
