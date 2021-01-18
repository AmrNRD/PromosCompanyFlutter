
import 'dart:io';

import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/ui/common/custom_raised_button.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../env.dart';
import '../../../../main.dart';
import '../../../../utils/app.localization.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class RegisterScreen extends StatefulWidget {
  final Function goToLogin;

  const RegisterScreen({Key key,@required this.goToLogin}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String platform;
  FirebaseMessaging firebaseMessaging;
  String firebaseToken;


  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();


  FocusNode _nameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _phoneFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _aboutMeFocusNode;
  FocusNode _passwordFocusNode;

  int reqStatus=0;

  Map<String, String> _authData = {'email': '', 'password': '', 'password_confirmation': ''};

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
            content: Text(state.message, style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
            backgroundColor: AppColors.accentColor1,
          ));
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
          margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 138),
                  child: Hero(tag: "Logo", child: Image.asset("assets/images/logo.png",height: screenAwareSize(100, context),width: screenAwareWidth(100, context))),
                ),

                SizedBox(height: AppDimens.marginDefault12),

                Text(AppLocalizations.of(context).translate("welcome"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),

                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.marginDefault4),
                  child: Text(AppLocalizations.of(context).translate("please_sign_in_to_continue"), style: Theme.of(context).textTheme.subtitle1),
                ),

                SizedBox(height: AppDimens.marginEdgeCase24),

                //name
                FormInputField(title: "name", focusNode: _nameFocusNode, onSave: (value) => _authData['name'] = value,validator:(value)=>Validator(context).isNotEmpty(value) ,nextFocusNode: _emailFocusNode),
                //email
                FormInputField(title: "email", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value,validator:(value)=>Validator(context).isEmail(value) ,nextFocusNode: _phoneFocusNode),
                //phone number
                FormInputField(title: "phone_number", focusNode: _phoneFocusNode, onSave: (value) => _authData['phone'] = value,validator:(value)=>Validator(context).isPhoneNumber(value) ,nextFocusNode: _addressFocusNode),
                //address
                FormInputField(title: "address", focusNode: _addressFocusNode, onSave: (value) => _authData['address'] = value,validator:(value)=>Validator(context).isNotEmpty(value) ,nextFocusNode: _aboutMeFocusNode,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6),
                //aboutMe
                FormInputField(title: "about_us", focusNode: _aboutMeFocusNode, onSave: (value) => _authData['about_me'] = value,validator:(value)=>Validator(context).isNotEmpty(value) ,nextFocusNode: _aboutMeFocusNode,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6),

                //city
                Container(
                  margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12),
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.marginSeparator8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor
                  ),
                  child: DropdownButton(
                      isExpanded: true,
                      underline: Container(),
                      value: _authData['city'],
                      dropdownColor: Theme.of(context).backgroundColor,
                      hint: Text(AppLocalizations.of(context).translate("city")) ,
                      items: [
                        DropdownMenuItem(child: Text("القاهرة"), value: 'Cairo'),
                        DropdownMenuItem(child: Text("الجيزة"), value: 'Giza'),
                        DropdownMenuItem(child: Text("الأسكندرية"), value: 'Alexandria'),
                        DropdownMenuItem(child: Text("البحر الأحمر"), value: 'Red Sea'),
                        DropdownMenuItem(child: Text("الدقهلية"), value: 'Dakahlia'),
                        DropdownMenuItem(child: Text("البحيرة"), value: 'Beheira'),
                        DropdownMenuItem(child: Text("الفيوم"), value: 'Fayoum'),
                        DropdownMenuItem(child: Text("الغربية"), value: 'Gharbiya'),
                        DropdownMenuItem(child: Text("الإسماعلية"), value: 'Ismailia'),
                        DropdownMenuItem(child: Text("المنوفية"), value: 'Monofia'),
                        DropdownMenuItem(child: Text("المنيا"), value: 'Minya'),
                        DropdownMenuItem(child: Text("القليوبية"), value: 'Qaliubiya'),
                        DropdownMenuItem(child: Text("الوادي الجديد"), value: 'New Valley'),
                        DropdownMenuItem(child: Text("السويس"), value: 'Suez'),
                        DropdownMenuItem(child: Text("اسوان"), value: 'Aswan'),
                        DropdownMenuItem(child: Text("اسيوط"), value: 'Assiut'),
                        DropdownMenuItem(child: Text("بني سويف"), value: 'Beni Suef'),
                        DropdownMenuItem(child: Text("بورسعيد"), value: 'Port Said'),
                        DropdownMenuItem(child: Text("دمياط"), value: 'Damietta'),
                        DropdownMenuItem(child: Text("الشرقية"), value: 'Sharkia'),
                        DropdownMenuItem(child: Text("جنوب سيناء"), value: 'South Sinai'),
                        DropdownMenuItem(child: Text("كفر الشيخ"), value: 'Kafr Al sheikh'),
                        DropdownMenuItem(child: Text("مطروح"), value: 'Matrouh'),
                        DropdownMenuItem(child: Text("قنا"), value: 'Qena'),
                        DropdownMenuItem(child: Text("شمال سيناء"), value: 'North Sinai'),
                        DropdownMenuItem(child: Text("سوهاج"), value: 'Sohag'),
                      ],
                      onChanged: (value) {setState(() {_authData['city'] = value;});
                      }),
                ),



                //password
                FormInputField(
                  title: "password",
                  focusNode: _passwordFocusNode,
                  onSave: (value) => _authData['password'] = value,
                  isRequired: true,
                  obscureText: _obscureTextLogin,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() {_obscureTextLogin = !_obscureTextLogin;}),
                    child: Icon(_obscureTextLogin ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, size: 15.0, color: Colors.grey)
                  ),
                ),
                SizedBox(height: AppDimens.marginEdgeCase32),
                Center(child: CustomRaisedButton(label: AppLocalizations.of(context).translate("sign_up"), onPress: onLogin, isLoading: reqStatus == 1)),
                Center(child: FlatButton(onPressed: widget.goToLogin, child: Text(AppLocalizations.of(context).translate("already have account"), style: Theme.of(context).textTheme.subtitle1))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if( _authData['gender']==null)
      {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).translate("gender_not_entered"), style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
          backgroundColor: AppColors.accentColor1,
        ));
        return;
      }
    if( _authData['city']==null)
    {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).translate("city_not_entered"), style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
        backgroundColor: AppColors.accentColor1,
      ));
      return;
    }

      BlocProvider.of<UserBloc>(context)..add(SignUpUser(email: _authData['email'], name:  _authData['name'] , mobile: _authData['phone'], city: _authData['city'], gender:  _authData['gender'], lat: null, long: null, avatar: null, password: _authData['password'], passwordConfirmation: _authData['password'], platform: platform));
    }
  }




}

class PrefixIcon extends StatelessWidget {
  const PrefixIcon({Key key, @required this.iconData}) : super(key: key);
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColorDark,
        borderRadius: BorderRadius.circular(12),
      ),
      height: screenAwareSize(48, context),
      width: screenAwareSize(38, context),
      child: Icon(iconData,color: AppColors.white),
    );
  }
}
