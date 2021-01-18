
import 'package:flutter/cupertino.dart';

import 'user_model.dart';

class SaleItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final User user;

  SaleItem({@required this.id, @required this.title, @required this.description,@required this.price, @required this.images, @required this.user});



  factory SaleItem.fromJson(Map<String, dynamic> data) {
    return SaleItem(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a SaleItem object
      id: data['id'],
      title: data['title'],
      description: data['description'],
      user: User.fromJson(data['user']),
      price: double.tryParse(data['price'].toString()),
      images:List<String>.from((data['images'] as List)),
    );
  }

}
