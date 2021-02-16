
import 'dart:convert';
import 'dart:io';

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
  Future<SaleItem> disable(SaleItem saleItem);
  Future<SaleItem> enable(SaleItem saleItem);
  Future<SaleItem> store(SaleItem saleItem,List<File>files);
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

  @override
  Future<SaleItem> disable(SaleItem saleItem) async {
    final responseData = await APICaller.postData("/sale_items/deactivate/"+saleItem.id.toString(),authorizedHeader: true);
    SaleItem updateSaleItem=SaleItem.fromJson(responseData['data']);
    return updateSaleItem;
  }

  @override
  Future<SaleItem> enable(SaleItem saleItem) async {
    final responseData = await APICaller.postData("/sale_items/activate/"+saleItem.id.toString(),authorizedHeader: true);
    SaleItem updateSaleItem=SaleItem.fromJson(responseData['data']);
    return updateSaleItem;
  }

  @override
  Future<SaleItem> store(SaleItem saleItem, List<File> files) async {
    var data = saleItem.toUpdateJson();
    data['isencoded'] = true;
    data['user_id'] = Root.user.id.toString();
    final responseData = await APICaller.multiPartData('POST', "/sale_items", files, authorizedHeader: true, body: data,type: "images");

    SaleItem updatedPost = SaleItem.fromJson(responseData['data']);
    return updatedPost;
  }

}
