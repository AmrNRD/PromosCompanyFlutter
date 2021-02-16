import 'dart:async';

import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/data/sources/remote/base/api_caller.dart';
import 'package:PromoMeCompany/ui/modules/auth/auth.page.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../env.dart';
import '../../../main.dart';
import '../../../utils/core.util.dart';
import '../../style/app.colors.dart';

class LandingSplashScreen extends StatefulWidget {
  @override
  _LandingSplashScreenState createState() => _LandingSplashScreenState();
}

class _LandingSplashScreenState extends State<LandingSplashScreen> {
  String _route;

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(GetUser());
    startTime();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) async {
          if (state is UserLoaded) {
            setState(() {
              Root.user=state.user;
            });
          }
        },
        child: Align(
            alignment: Alignment.center,
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryColor,
              highlightColor: AppColors.white,
              child: Hero(
                tag: "Logo",
                child: Image.asset(
                  "assets/images/logo.png",
                  height: screenAwareSize(200, context),
                  width: screenAwareSize(200, context),
                ),
              ),
            )),
      ),
    );
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      //if user registered
      if (prefs.containsKey('userData')) {
        //if email is verified
        if (prefs.containsKey('verified')) {
          //if user completed the initial setup
          _route = Env.homePage;
        } else {
          //if email is not verified
          _route = Env.homePage;
//          _route = Env.verifyPage;
        }
      } else {
        //if user not registered
        _route = Env.authPage;
      }

    Duration _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }


  void navigationPage() {
    if(_route==Env.authPage)
      Navigator.pushReplacement(context, PageRouteBuilder(transitionDuration: Duration(seconds: 1),pageBuilder:(_,__,___)=>AuthPage(),settings: RouteSettings(name: Env.authPage)));
      else
        Navigator.of(context).pushReplacementNamed(_route);
  }
}
