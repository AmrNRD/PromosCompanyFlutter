import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/ui/modules/add_sale_item/add_sale_item_page.dart';
import 'package:PromoMeCompany/ui/modules/add_video/add_video_page.dart';
import 'package:PromoMeCompany/ui/modules/auth/auth.page.dart';
import 'package:PromoMeCompany/ui/modules/edit_profile/edit_profile_page.dart';
import 'package:PromoMeCompany/ui/modules/navigation/home.navigation.dart';
import 'package:PromoMeCompany/ui/modules/sidemenu/side.menu.page.dart';
import 'package:PromoMeCompany/ui/modules/splash/splash.page.dart';
import 'package:PromoMeCompany/ui/modules/store_details/store_details.page.dart';
import 'package:PromoMeCompany/ui/modules/verification/verification.screen.dart';
import 'package:PromoMeCompany/ui/modules/video_details/video_details.page.dart';
import 'package:PromoMeCompany/ui/modules/view_profile/profile.page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../env.dart';

class RouteGenerator {

  RouteGenerator();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Env.mainPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.mainPage),
          builder: (_) => LandingSplashScreen(),
        );
      case Env.authPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.authPage),
          builder: (_) => AuthPage(),
        );
      case Env.homePage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.homePage),
          builder: (_) => HomeNavigationPage(),
        );
      case Env.sideMenuPage:
        return PageTransition(
          settings: RouteSettings(name: Env.sideMenuPage),
          child:SideMenuPage(),
          type: PageTransitionType.rightToLeft
        );
      case Env.profilePage:
        if(args is User)
          return MaterialPageRoute(
            settings: RouteSettings(name: Env.profilePage),
            builder: (_) => ShowProfilePage(user: args),
          );
        return _errorRoute();
       case Env.saleItemPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.saleItemPage),
          builder: (_) => SaleItemDetailsPage(saleItem: args),
        );
      case Env.videoPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.videoPage),
          builder: (_) => VideoDetailsPage(video: args),
        );
      case Env.addVideoPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.addVideoPage),
          builder: (_) => AddVideoPage(),
        );
      case Env.editPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.editPage),
          builder: (_) => EditProfilePage(),
        );
        case Env.addSaleItemPage:
        return MaterialPageRoute(
          settings: RouteSettings(name: Env.addSaleItemPage),
          builder: (_) => AddSaleItemPage(),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
