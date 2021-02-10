import 'dart:async';
import 'dart:io';

import 'package:PromoMeCompany/data/models/ad_video.dart';
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
      yield VideoLoading();if (event is StoreVideo) {
        AdVideo adVideo=await videoRepository.storeAdVideo(event.adVideo,event.video);
        yield VideoLoaded(adVideo);
      }else if (event is GetAllMyVideos) {
        List<AdVideo> adVideos=await videoRepository.getAllAdVideo();
        yield VideosLoaded(adVideos);
      }
    } catch (error) {
      yield VideoError(error.toString());
    }
  }
}
