
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:flutter/cupertino.dart';

import 'user_model.dart';

class CycleVideo {
  final int id;
  final AdVideo adVideo;
  final int targetViews;
  final int numberOfViews;
  final String status;

  CycleVideo({@required this.id, @required this.adVideo, @required this.targetViews, @required this.numberOfViews, @required this.status});



  factory CycleVideo.fromJson(Map<String, dynamic> data) {
    return CycleVideo(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a CycleVideo object
      id: data['id'],
      adVideo: AdVideo.fromJson(data['video']),
      targetViews: int.tryParse(data['target_views'].toString()),
      numberOfViews: int.tryParse(data['number_of_views'].toString()),
      status: data['status']
    );
  }

}
