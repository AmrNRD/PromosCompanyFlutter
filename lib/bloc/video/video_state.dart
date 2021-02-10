part of 'video_bloc.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final AdVideo video;
  VideoLoaded(this.video);
}

class VideosLoaded extends VideoState {
  final List<AdVideo> videos;
  VideosLoaded(this.videos);
}


class VideoWatchedSuccessfully extends VideoState {}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);
}
