
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'user_model.dart';

class AdVideo {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int targetViews;
  final int numberOfViews;
  final String video;
  final String link;
  final User user;
  final int ageFrom;
  final int ageTo;
  final List<String> cities;
  final List<String> genders;
  final String status;


  AdVideo({@required this.id, @required this.name, @required this.startDate, @required this.endDate, @required this.targetViews, @required this.numberOfViews, @required this.video, @required this.user,@required this.link,this.ageFrom, this.ageTo,this.cities, this.genders,this.status});


  factory AdVideo.fromJson(Map<String, dynamic> data) {
    return AdVideo(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a AdVideo object
      id: data['id'],
      name: data['name'],
      video: data['video'],
      status: data['status'],
      user: User.fromJson(data['user']),
      startDate: DateTime.tryParse(data['start_date'].toString()),
      endDate: DateTime.tryParse(data['end_date'].toString()),
      targetViews: int.tryParse(data['target_views'].toString()),
      numberOfViews: int.tryParse(data['number_of_views'].toString()),
      ageFrom: int.tryParse(data['age_from'].toString()),
      ageTo: int.tryParse(data['age_to'].toString()),
      link:data['link'],
      cities:data['cities']!=null?List<String>.from((data['cities'] as List)):[],
      genders:data['genders']!=null?List<String>.from((data['genders'] as List)):[],
    );
  }

  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'target_views':targetViews,
    'link':link,
    // 'age_from':ageFrom,
    'cities':jsonEncode(cities),
    'genders':jsonEncode(genders),
    // 'age_to':ageTo
  };
}
