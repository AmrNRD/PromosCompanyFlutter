part of 'video_bloc.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoWatchedSuccessfully extends VideoState {}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);
}
