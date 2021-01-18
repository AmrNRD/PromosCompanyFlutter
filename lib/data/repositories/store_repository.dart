
import 'dart:convert';

import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';

import '../../main.dart';
import '../models/user_model.dart';
import '../sources/remote/base/api_caller.dart';
import '../sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class StoreRepository {

  Future<List<SaleItem>> getAllSaleItems();
  Future<List<SaleItem>> getUserSaleItems(User user);

}


class StoreDataRepository implements StoreRepository {
  @override
  Future<List<SaleItem>> getAllSaleItems() async {
    final responseData = await APICaller.getData("/sale_items",authorizedHeader: true);
    List<SaleItem>saleItems=[];
    for(var saleItemData in responseData['data'])
    {
      saleItems.add(SaleItem.fromJson(saleItemData));
    }
    return saleItems;
  }

  @override
  Future<List<SaleItem>> getUserSaleItems(User user) async {
    final responseData = await APICaller.getData("/company-sales/"+user.id.toString(),authorizedHeader: true);
    List<SaleItem>saleItems=[];
    for(var saleItemData in responseData['data'])
    {
      saleItems.add(SaleItem.fromJson(saleItemData));
    }
    return saleItems;
  }

}
