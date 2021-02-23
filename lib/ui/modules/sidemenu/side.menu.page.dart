
import 'package:PromoMeCompany/bloc/settings/settings_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/ui/modules/profile/components/profile.tag.component.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../env.dart';
import '../../../main.dart';
import 'components/side.menu.button.dart';


class SideMenuPage extends StatefulWidget {
  @override
  _SideMenuPageState createState() => _SideMenuPageState();
}

class _SideMenuPageState extends State<SideMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child:  SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 32,bottom: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: "Logo",
                            child: Image.asset(
                              "assets/images/colored_logo.png",
                              height: screenAwareSize(50, context),
                              width: screenAwareWidth(70, context),
                            ),
                          ),
                          GestureDetector(onTap:()=>Navigator.of(context).pop(),child: SvgPicture.asset("assets/icons/times.svg",color:Theme.of(context).textTheme.bodyText1.color,height: screenAwareSize(20, context))),
                        ],
                      ),
                    ),
                    ProfileTagComponent(user: Root.user),
                    Divider(thickness: 1),
                    SideMenuButton(icon:"assets/icons/about_us_icon.svg",title: "update_profile",subTitle: "",onTap: onEditProfileClick),
                    Divider(thickness: 1),
                    SideMenuButton(icon:"assets/icons/lang_icon.svg",title: "change_language",subTitle: "the_other_language",onTap: onLangChangeClick),
                    Divider(thickness: 1),
                    SideMenuButton(icon:"assets/images/logo2.png",title: "about_us",subTitle: "",onTap: onAboutUsClick,isSvg: false,),
                    Divider(thickness: 1),
                    SideMenuButton(icon:"assets/icons/settings_icon.svg",title: "dark_mode",subTitle:Switch(activeColor:AppColors.accentColor1,onChanged: (value){BlocProvider.of<SettingsBloc>(context).add(ChangeTheme(Theme.of(context).brightness==Brightness.dark?ThemeMode.light:ThemeMode.dark));},value: Theme.of(context).brightness==Brightness.dark),onTap: onSettingsClick),
                    SizedBox(height: 86),
                    SideMenuButton(icon:"assets/icons/log_out_icon.svg",title: "logout",subTitle: "",onTap: onExitClick),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  onAboutUsClick() {
    // Navigator.of(context).pushNamed(Env.aboutPage);
  }

  onLangChangeClick() {
      if (AppLocalizations.of(context).currentLanguage == Locale('ar').toString()) {
        BlocProvider.of<SettingsBloc>(context).add(ChangeLocal(Locale('en')));
      } else {
        BlocProvider.of<SettingsBloc>(context).add(ChangeLocal(Locale('ar')));
      }
  }

  onEditProfileClick() {
    Navigator.of(context).pushNamed(Env.editPage);
  }

  onTermsClick() {
  }

  onSettingsClick() {
  }

  onExitClick() {
    BlocProvider.of<UserBloc>(context).add(LogoutUser());
  }
}

