import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../main.dart';

class SetUp {
  static BuildContext context;


//  Future onSelectNotification(String payload) async {
//
//    await Navigator.pushNamed(context, getRouteNameFromPayload(payload));
//  }
//
//  Future<dynamic> onSelectNotificationIOS(int id, String title, String body, String payload) async {
//    await Navigator.pushNamed(context, getRouteNameFromPayload(payload));
//  }


  //------------------------------Firebase------------------------------
  static Future<String> setUpFirebaseConfig(BuildContext buildContext) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    context = buildContext;
    //----firebase config----
    if(sharedPreferences.containsKey('firebaseToken')) {
      FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          debugPrint("firebase onMessage: $message");
        },
        onBackgroundMessage: null,
        onLaunch: (Map<String, dynamic> message) async {
          debugPrint("firebase onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          debugPrint("firebase onResume: $message");
        },
      );
      firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
      firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        debugPrint("firebase Settings registered: $settings");
      });
      String token = await firebaseMessaging.getToken();
      sharedPreferences.setString("firebaseToken", token);
      return token;
    }else{
      return sharedPreferences.getString('firebaseToken');
    }
  }

  static onBackGroundHandling(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      debugPrint('firebase android backgroundMessageHandler data $data');
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      debugPrint('firebase android backgroundMessageHandler notification $notification');
    }
    return null;
  }



}
