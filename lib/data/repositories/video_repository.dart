import 'dart:convert';
import 'dart:io';

import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';

import '../../main.dart';
import '../models/user_model.dart';
import '../sources/remote/base/api_caller.dart';
import '../sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class VideoRepository {
  Future<List<AdVideo>> getAllAdVideo();

  Future storeAdVideo(AdVideo adVideo, File video);
}

class VideoDataRepository implements VideoRepository {
  @override
  Future<List<AdVideo>> getAllAdVideo() async {
    final responseData =
        await APICaller.getData("/my-ad-videos", authorizedHeader: true);
    List<AdVideo> videos = [];
    for (var postData in responseData['data']) {
      videos.add(AdVideo.fromJson(postData));
    }
    return videos;
  }

  @override
  Future storeAdVideo(AdVideo adVideo, File video) async {
    var data = adVideo.toUpdateJson();
    data['isencoded'] = true;
    data['user_id'] = Root.user.id.toString();
    final responseData = await APICaller.multiPartData(
        'POST', "/ad_videos", [video],
        authorizedHeader: true, body: data);

    AdVideo updatedPost = AdVideo.fromJson(responseData['data']);
    return updatedPost;
  }
}
