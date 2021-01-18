part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class SendVideoHadBeenWatched extends VideoEvent {
  final CycleVideo cycleVideo;
  SendVideoHadBeenWatched(this.cycleVideo);
}
