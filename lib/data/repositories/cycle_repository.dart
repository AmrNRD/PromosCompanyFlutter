
import 'dart:convert';

import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';

import '../../main.dart';
import '../models/user_model.dart';
import '../sources/remote/base/api_caller.dart';
import '../sources/remote/base/app.exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class CycleRepository {

  Future<List<Cycle>> getAllCycles();
  Future<User> setCycleAsWatched(Cycle cycle);

}


class CycleDataRepository implements CycleRepository {
  @override
  Future<List<Cycle>> getAllCycles() async {
    final responseData = await APICaller.getData("/cycles",authorizedHeader: true);
    List<Cycle>cycles=[];
    for(var postData in responseData['data'])
    {
      cycles.add(Cycle.fromJson(postData));
    }
    return cycles;
  }


  @override
  Future<User> setCycleAsWatched(Cycle cycle) async {
    final responseData = await APICaller.postData("/cycle-watched",authorizedHeader: true,body: {"cycle_id":cycle.id});
    User user = User.fromJson(responseData['data']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(user));
    return user;
  }

}
