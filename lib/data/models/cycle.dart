import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:flutter/cupertino.dart';

import 'user_model.dart';

class Cycle {
  final int id;
  final String name;
  final List<CycleVideo> cycleVideos;
  final int targetViews;
  final int numberOfViews;
  final int points;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String type;

  Cycle( {@required this.id, @required this.cycleVideos, @required this.name, @required this.targetViews, @required this.numberOfViews,@required this.points, @required this.startDate, @required this.endDate, @required this.status, @required this.type});

  factory Cycle.fromJson(Map<String, dynamic> data) {
    return Cycle(
        //This will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a Cycle object
        id: data['id'],
        name: data['name'],
        type: data['type'],
        startDate: DateTime.tryParse(data['start_date'].toString()),
        endDate: DateTime.tryParse(data['end_date'].toString()),
        targetViews: int.tryParse(data['target_views'].toString()),
        numberOfViews: int.tryParse(data['number_of_views'].toString()),
        points: int.tryParse(data['points'].toString()),
        status: data['status'],
        cycleVideos: List<CycleVideo>.from((data['videos'] as List).map((e) => CycleVideo.fromJson(e)).toList()));
  }
}
