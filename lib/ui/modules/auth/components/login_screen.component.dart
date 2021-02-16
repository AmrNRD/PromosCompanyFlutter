
import 'dart:io';

import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/main.dart';
import 'package:PromoMeCompany/ui/common/custom_raised_button.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/ui/common/loading_button.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../env.dart';
import '../../../../utils/app.localization.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class LoginScreen extends StatefulWidget {
  final Function goToForgotPassword;
  final Function goToRegistration;

  const LoginScreen({Key key,@required this.goToForgotPassword,@required this.goToRegistration}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String platform;
  FirebaseMessaging firebaseMessaging;
  String firebaseToken;


  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();


  FocusNode _emailFocusNode=new FocusNode();
  FocusNode _passwordFocusNode=new FocusNode();

  int reqStatus=0;

  Map<String, String> _authData = {'email': '', 'password': ''};

  @override
  void initState() {
    platform = Platform.isIOS ? "IOS" : "Android";
    firebaseToken = "";
    firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      firebaseToken = token;
      SharedPreferences.getInstance().then((sharedPreferences) => sharedPreferences.setString("firebaseToken", firebaseToken));
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is UserLoading) {
          setState(() {reqStatus = 1;});
        } else if (state is UserLoaded) {
          setState(() {
            reqStatus= 2;
            Root.user=state.user;
          });

          Navigator.of(context).pushReplacementNamed(Env.homePage);
        } else if (state is UserError) {
          setState(() {reqStatus = 0;});
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).translate(state.message,defaultText: state.message), style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
            backgroundColor: AppColors.accentColor1,
          ));
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
                child: Hero(tag: "Logo", child: Image.asset("assets/images/logo.png",height: screenAwareSize(100, context),width: screenAwareWidth(100, context)))
            ),
            SizedBox(height: 130),
            Container(
                margin: EdgeInsetsDirectional.only(start: 15),
                child: Text(AppLocalizations.of(context).translate("welcome"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold))),
            SizedBox(height: AppDimens.marginEdgeCase24),
            Card(
              color: Theme.of(context).cardColor,
              elevation: 1,
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal:10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 20),
                      //email
                      FormInputField(title: "email", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value,validator:(value)=>Validator(context).isEmail(value) ,nextFocusNode: _passwordFocusNode,outterBorder: true, useLabel: true),
                      //password
                      FormInputField(
                        title: "password",
                        focusNode: _passwordFocusNode,
                        onSave: (value) => _authData['password'] = value,
                        isRequired: true,
                        onFieldSubmitted: onLogin,
                        obscureText: _obscureTextLogin,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                          child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 15.0, color: Colors.grey)
                        ),
                        outterBorder: true,
                        useLabel: true
                      ),
                      SizedBox(height: AppDimens.marginEdgeCase32),
                      Center(child: LoadingButton(title: "sign_in", onPressed: onLogin, status: reqStatus)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Center(child: FlatButton(onPressed: widget.goToForgotPassword, child: Text(AppLocalizations.of(context).translate("forget"), style: Theme.of(context).textTheme.subtitle1))),
            SizedBox(height: AppDimens.marginEdgeCase32),
            Center(child: FlatButton(onPressed: widget.goToRegistration, child: Text(AppLocalizations.of(context).translate("don't have account"), style: Theme.of(context).textTheme.subtitle1))),
          ],
        ),
      ),
    );
  }

  void onLogin() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      BlocProvider.of<UserBloc>(context)..add(LoginUser(_authData['email'], _authData['password'], firebaseToken, platform));
    }
  }



}

