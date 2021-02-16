
import 'dart:convert';
import 'dart:io';

import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/data/repositories/user_repository.dart';
import 'package:PromoMeCompany/ui/common/custom_raised_button.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/ui/common/loading_button.dart';
import 'package:PromoMeCompany/ui/common/user_circular_photo.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';

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

  var imageSRC;
  String fileName;
  bool fromFile=false;


  bool _obscureTextLogin = true;

  final GlobalKey<FormState> _formKey = GlobalKey();


  FocusNode _nameFocusNode=new FocusNode();
  FocusNode _emailFocusNode=new FocusNode();
  FocusNode _phoneFocusNode=new FocusNode();
  FocusNode _addressFocusNode=new FocusNode();
  FocusNode _aboutMeFocusNode=new FocusNode();
  FocusNode _passwordFocusNode=new FocusNode();

  int reqStatus=0;

  Map<String, String> _authData = {'email': '', 'password': '', 'password_confirmation': ''};

  @override
  void initState() {
    platform = Platform.isIOS ? "IOS" : "Android";
    firebaseToken = "";
    imageSRC="http://192.168.1.5/promosme/public/images/profile.png";
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
        child: Column(
          children: [
            Center(child: Hero(tag: "Logo", child: Image.asset("assets/images/logo.png",height: screenAwareSize(100, context),width: screenAwareWidth(100, context)))),
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
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: getImage,
                            child: Badge(
                              badgeColor: Colors.red,
                              badgeContent: Icon(Icons.edit),
                              position: BadgePosition.topStart(top: 5),
                              child: UserCircularPhoto(photo: imageSRC,fromFile: fromFile,size: 120),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.marginEdgeCase24),
                      //name
                      FormInputField(title: "name", focusNode: _nameFocusNode, onSave: (value) => _authData['name'] = value,validator:(value)=>Validator(context).isNotEmpty(value) ,nextFocusNode: _emailFocusNode,outterBorder: true, useLabel: true,),
                      //email
                      FormInputField(title: "email", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value,validator:(value)=>Validator(context).isEmail(value) ,nextFocusNode: _phoneFocusNode,outterBorder: true, useLabel: true),
                      //phone number
                      FormInputField(title: "phone_number", focusNode: _phoneFocusNode, onSave: (value) => _authData['phone'] = value,validator:(value)=>Validator(context).isPhoneNumber(value),nextFocusNode: _addressFocusNode,outterBorder: true, useLabel: true),
                      //address
                      FormInputField(title: "address", focusNode: _addressFocusNode, onSave: (value) => _authData['address'] = value,validator:(value)=>Validator(context).isNotEmpty(value),nextFocusNode: _aboutMeFocusNode,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6,outterBorder: true, useLabel: true),
                      //aboutMe
                      FormInputField(title: "about_us", focusNode: _aboutMeFocusNode, onSave: (value) => _authData['about_me'] = value,nextFocusNode: _aboutMeFocusNode,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6,outterBorder: true, useLabel: true),
                      //city
                      Container(
                        margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12),
                        padding: EdgeInsets.symmetric(horizontal: AppDimens.marginSeparator8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).textTheme.headline3.color,
                            ),
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
                        outterBorder: true,
                        useLabel: true,
                        onFieldSubmitted: onLogin,
                      ),
                      SizedBox(height: AppDimens.marginEdgeCase32),
                      Center(child: LoadingButton(title: "sign_up", onPressed: onLogin, status: reqStatus)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            Center(child: FlatButton(onPressed: widget.goToLogin, child: Text(AppLocalizations.of(context).translate("already have account"), style: Theme.of(context).textTheme.subtitle1))),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    File croppedImage=await ImageCropper.cropImage(sourcePath: image.path,cropStyle: CropStyle.circle,aspectRatio:CropAspectRatio(ratioX: 1,ratioY: 1) );
    String base64Image = base64Encode(croppedImage.readAsBytesSync());
    fileName = image.path.split("/").last;
      setState(() {
        fromFile=true;
        imageSRC=croppedImage;
        _authData['avatar']=base64Image;
        _authData['photo_name']=fileName;
      });
  }

  void onLogin() {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

    if( _authData['city']==null)
    {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).translate("city_not_entered"), style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),),
        backgroundColor: AppColors.accentColor1,
      ));
      return;
    }

      BlocProvider.of<UserBloc>(context)..add(SignUpUser(email: _authData['email'], name:  _authData['name'] , mobile: _authData['phone'], city: _authData['city'], gender:  _authData['gender'], lat: null, long: null, avatar: _authData['avatar'],photoName: _authData['photo_name'], password: _authData['password'], passwordConfirmation: _authData['password'], platform: platform,address: _authData['address']));
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
