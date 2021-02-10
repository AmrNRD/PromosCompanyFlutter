part of 'video_bloc.dart';

@immutable
abstract class VideoEvent {}

class GetAllMyVideos extends VideoEvent {
  GetAllMyVideos();
}

class SendVideoHadBeenWatched extends VideoEvent {
  final CycleVideo cycleVideo;

  SendVideoHadBeenWatched(this.cycleVideo);
}

class StoreVideo extends VideoEvent {
  final AdVideo adVideo;
  final File video;

  StoreVideo(this.adVideo, this.video);
}
