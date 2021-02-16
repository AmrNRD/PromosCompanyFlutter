import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/ui/common/write_post_sheets.dart';
import 'package:PromoMeCompany/ui/modules/cycles/videos.tab.dart';
import 'package:PromoMeCompany/ui/modules/home/home.tab.dart';
import 'package:PromoMeCompany/ui/modules/profile/profile.page.dart';
import 'package:PromoMeCompany/ui/modules/store/store.tab.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../env.dart';
import '../home/home.tab.dart';

class HomeNavigationPage extends StatefulWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation curve;

  @override
  void initState() {
    _controller =   AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    curve = CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> body = [
    HomeTabPage(),
    StoreTab(),
    VideosTab(),
  ];
  int _currentSelectedTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedTab = index;
    });
  }

  PersistentBottomSheetController _controller2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomeNavigationPage.scaffoldKey,
      body: BlocListener<UserBloc,UserState>(
        listener: (context,state){
          if(state is UserLoggedOut){
            Navigator.pushReplacementNamed(context, Env.authPage);
          }
        },
        child: SafeArea(
          child: body[_currentSelectedTab],
          right:false,
          left: false,
          bottom: false,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:  BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label:AppLocalizations.of(context).translate("home", defaultText: "Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.shoppingBag),
            label: AppLocalizations.of(context).translate("sales", defaultText: "Sales"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.film),
            label: AppLocalizations.of(context).translate("videos", defaultText: "Videos"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentSelectedTab,
        selectedItemColor: AppColors.accentColor1,
        backgroundColor: Theme.of(context).cardColor,
        onTap: _onItemTapped,
      ),
    );
  }

}
