import 'dart:async';

import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    //todo:remove this in deployment
    onSkip();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc,UserState>(
      listener: (context,state){
        if(state is VerifiedSuccessfully){
          Navigator.of(context).pushNamed(Constants.homePage);
        }
      },
      child: Scaffold(
        body: Center(child: Text(AppLocalizations.of(context).translate("askTheAdminToVerification"),style: Theme.of(context).textTheme.headline2)),
      ),
    );
  }

  void onSkip() {
    Duration _duration = new Duration(seconds: 2);
    Timer(_duration, (){
      BlocProvider.of<UserBloc>(context).add(VerifiedLogin());
    });
  }
}
