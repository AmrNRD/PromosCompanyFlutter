
import 'dart:convert';

import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';

import '../../main.dart';
import '../models/user_model.dart';
import '../sources/remote/base/api_caller.dart';
import '../sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class VideoRepository {

  Future setVideoAsWatched(CycleVideo cycleVideo);

}

class VideoDataRepository implements VideoRepository {
  @override
  Future setVideoAsWatched(CycleVideo cycleVideo) async {
    final responseData = await APICaller.postData("/video-watched",authorizedHeader: true,body: {"cycle_video_id":cycleVideo.id,"ad_video_id":cycleVideo.adVideo.id});
    return true;
  }

}
