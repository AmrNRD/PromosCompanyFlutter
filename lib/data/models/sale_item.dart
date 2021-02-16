
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'user_model.dart';

class SaleItem {
  final int id;
  final String title;
  final String description;
  final String status;
  final double price;
  final List<String> images;
  final List<String> cities;
  final List<String> genders;
  final User user;
  final int targetViews;
  final int numberOfViews;
  final int ageFrom;
  final int ageTo;

  SaleItem({@required this.id, @required this.title, @required this.description,@required this.price, @required this.images, @required this.user,this.status="inactive",this.cities,this.genders,this.targetViews, this.numberOfViews, this.ageFrom, this.ageTo,});



  factory SaleItem.fromJson(Map<String, dynamic> data) {
    return SaleItem(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a SaleItem object
      id: data['id'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      user: User.fromJson(data['user']),
      price: double.tryParse(data['price'].toString()),
      images:data['images']!=null?List<String>.from((data['images'] as List)):[],
      cities:data['cities']!=null?List<String>.from((data['cities'] as List)):[],
      genders:data['genders']!=null?List<String>.from((data['genders'] as List)):[],
      targetViews: int.tryParse(data['target_views'].toString()),
      numberOfViews: int.tryParse(data['number_of_views'].toString()),
      ageFrom: int.tryParse(data['age_from'].toString()),
      ageTo: int.tryParse(data['age_to'].toString()),
    );

  }

  Map<String, dynamic> toUpdateJson() => {
    'title': title,
    'target_views':targetViews,
    'description':description,
    'price':price,
    'cities':jsonEncode(cities),
    'genders':jsonEncode(genders),
    // 'age_from':ageFrom,
    // 'age_to':ageTo
  };
}
