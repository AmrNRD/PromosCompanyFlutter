import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/ui/modules/cycles/cycles.tab.dart';
import 'package:PromoMeCompany/ui/modules/home/home.tab.dart';
import 'package:PromoMeCompany/ui/modules/profile/profile.page.dart';
import 'package:PromoMeCompany/ui/modules/store/store.tab.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../env.dart';
import '../home/home.tab.dart';

class HomeNavigationPage extends StatefulWidget {
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
    CyclesTab(),
    ProfileTab(),
  ];
  int _currentSelectedTab = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentSelectedTab = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentSelectedTab],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "scanButton",
        child: Icon(FontAwesomeIcons.plus),
        backgroundColor: AppColors.accentColor1,
        onPressed: onAddClick,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
        child:  BlocListener<UserBloc,UserState>(
          listener: (context,state){
            if(state is UserLoggedOut){
              Navigator.pushReplacementNamed(context, Env.authPage);
            }
          },
          child: AnimatedBottomNavigationBar(
            icons:[FontAwesomeIcons.home,FontAwesomeIcons.shoppingBag,FontAwesomeIcons.film, FontAwesomeIcons.user],
            activeColor: Colors.blue,
            backgroundColor: Theme.of(context).cardColor,
            inactiveColor: Theme.of(context).disabledColor,
            gapLocation: GapLocation.center,
            notchAndCornersAnimation:curve,
            activeIndex: _currentSelectedTab,
            onTap: _onItemTapped,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            leftCornerRadius: 10,
          ),
        ),
      ),
    );
  }

  void onAddClick() {
  }
}
