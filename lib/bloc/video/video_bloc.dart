import 'dart:async';

import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc(this.videoRepository) : super(VideoInitial());
  final VideoRepository videoRepository;

  @override
  Stream<VideoState> mapEventToState(VideoEvent event) async* {
    try {
      yield VideoLoading();
      if (event is SendVideoHadBeenWatched) {
        await videoRepository.setVideoAsWatched(event.cycleVideo);
        yield VideoWatchedSuccessfully();
      }
    } catch (error) {
      yield VideoError(error.toString());
    }
  }
}
