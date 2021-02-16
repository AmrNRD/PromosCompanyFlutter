import 'package:PromoMeCompany/bloc/settings/settings_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/ui/style/app.dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/app.localization.dart';

class SettingsButtonComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

//        SettingButton(title: "account_information",subTitle: "tap_to_change_your_information",onTap: (){},),
//        Divider(thickness: 1),
        SettingButton(title: "change_language",subTitle: "the_other_language",onTap: (){
          if (AppLocalizations.of(context).currentLanguage == Locale('ar').toString()) {
            BlocProvider.of<SettingsBloc>(context).add(ChangeLocal(Locale('en')));
          } else {
            BlocProvider.of<SettingsBloc>(context).add(ChangeLocal(Locale('ar')));
        }},),
        Divider(thickness: 1),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12,horizontal: AppDimens.marginEdgeCase24),
          child: Text(
            AppLocalizations.of(context).translate("system_settings", defaultText: "Settings"),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault6,horizontal: AppDimens.marginEdgeCase24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate("dark_mode", defaultText: "Settings"),
                style: Theme.of(context).textTheme.headline4,
              ),
              Switch(onChanged: (value){BlocProvider.of<SettingsBloc>(context).add(ChangeTheme(Theme.of(context).brightness==Brightness.dark?ThemeMode.light:ThemeMode.dark));},value: Theme.of(context).brightness==Brightness.dark),
            ],
          ),
        ),
        Divider(thickness: 1),
        InkWell(
          onTap: (){BlocProvider.of<UserBloc>(context).add(LogoutUser());},
          child: Container(
            margin: EdgeInsets.symmetric(vertical: AppDimens.marginEdgeCase32,horizontal: AppDimens.marginEdgeCase24),
            child: Text(
              AppLocalizations.of(context).translate(
                "logout",
                defaultText: "Logout",
              ),
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ),


      ],
    );
  }


}

class SettingButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final String subTitle;
  const SettingButton({
    Key key,@required this.onTap,@required this.title,@required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppDimens.marginEdgeCase32,horizontal: AppDimens.marginEdgeCase24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Container(
            child: Text(
              AppLocalizations.of(context).translate(
                title,
                defaultText: title,
              ),
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: AppDimens.marginDefault12),
            child: Text(
              AppLocalizations.of(context).translate(
                subTitle,
                defaultText: subTitle,
              ),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],),
      ),
    );
  }
}
