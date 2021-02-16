
import 'dart:convert';
import 'dart:io';


import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/bloc/user/user_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/data/repositories/user_repository.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:PromoMeCompany/main.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/ui/common/form_page_title.dart';
import 'package:PromoMeCompany/ui/common/loading_button.dart';
import 'package:PromoMeCompany/ui/common/user_circular_photo.dart';
import 'package:PromoMeCompany/ui/modules/add_video/ad_video_form.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/ui/style/app.dimens.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../env.dart';


class EditProfilePage extends StatefulWidget {


  const EditProfilePage() : super();

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();

  int reqStatus=0;

  FocusNode _nameFocusNode=new FocusNode();
  FocusNode _emailFocusNode=new FocusNode();
  FocusNode _phoneFocusNode=new FocusNode();
  FocusNode _addressFocusNode=new FocusNode();
  FocusNode _aboutMeFocusNode=new FocusNode();

  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;
  TextEditingController _aboutMeController;
  bool loadingPic = false;

  Map<String, String> _authData = {};

  @override
  void initState() {
    _authData['name']=Root.user?.name;
    _authData['mobile']=Root.user?.mobile;
    _authData['address']=Root.user?.address;
    _authData['about_me']=Root.user?.aboutMe;
    _authData['city']=Root.user?.city;

    print(Root.user.toJson());
    _nameController=TextEditingController(text: _authData['name']);
    _phoneController=TextEditingController(text: _authData['mobile']);
    _addressController=TextEditingController(text: _authData['address']);
    _aboutMeController=TextEditingController(text: _authData['about_me']);
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
          FormPageTitle(title: "update_profile", backButton: true),
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
           child: BlocListener<UserBloc, UserState>(
             listener: (context, state) async {
               if (state is UserLoading) {
                 setState(() {reqStatus=1;});
               } else if (state is UserLoaded) {
                 setState(() {
                   reqStatus=2;
                 Root.user=state.user;
                 });
                 Navigator.of(context).pushNamedAndRemoveUntil(Env.sideMenuPage, ModalRoute.withName(Env.homePage));
               }  else if (state is UserProfilePictureLoaded) {
                 setState(() {
                   loadingPic = false;
                   Root.user=state.user;
                 });
               } else if (state is UserProfilePictureLoading) {
                 setState(() {
                   loadingPic = true;
                 });
               } else if (state is UserError) {
                 setState(() {reqStatus=0;});
                 showInSnackBar(state.message, context, _scaffoldKey);
               }
             },
             child:Card(
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
                             child: !loadingPic
                                 ?GestureDetector(
                               onTap: getImage,
                               child: Badge(
                                 badgeColor: Colors.red,
                                 badgeContent: Icon(Icons.edit),
                                 position: BadgePosition.topStart(top: 5),
                                 child: UserCircularPhoto(photo: Root.user?.image,fromFile: false,size: 120),
                               ),
                             ):Container(
                               margin: EdgeInsets.all(30),
                               alignment: Alignment.center,
                               child: Shimmer.fromColors(
                                 baseColor: AppColors.primaryColor,
                                 highlightColor: AppColors.white,
                                 child: Image.asset(
                                   "assets/images/logo2.png",
                                   height: screenAwareSize(70, context),
                                   width: screenAwareWidth(70, context),
                                 ),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(height: 10),
                         //name
                         FormInputField(title: "name", focusNode: _nameFocusNode,textEditingController: _nameController, onSave: (value) => _authData['name'] = value,validator:(value)=>Validator(context).isNotEmpty(value) ,nextFocusNode: _phoneFocusNode,outterBorder: true, useLabel: true),
                         //phone number
                         FormInputField(title: "phone_number", focusNode: _phoneFocusNode,textEditingController: _phoneController,onSave: (value) => _authData['mobile'] = value,validator:(value)=>Validator(context).isPhoneNumber(value),nextFocusNode: _addressFocusNode,outterBorder: true, useLabel: true),
                         //address
                         FormInputField(title: "address", focusNode: _addressFocusNode,textEditingController: _addressController, onSave: (value) => _authData['address'] = value,validator:(value)=>Validator(context).isNotEmpty(value),nextFocusNode: _aboutMeFocusNode,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6,outterBorder: true, useLabel: true),
                         //aboutMe
                         FormInputField(title: "about_us", focusNode: _aboutMeFocusNode,textEditingController: _aboutMeController, onSave: (value) => _authData['about_me'] = value,textInputType: TextInputType.multiline,minLine: 5,maxLine: 6,outterBorder: true, useLabel: true),
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
                         SizedBox(height: AppDimens.marginEdgeCase32),
                         Center(child: LoadingButton(title: "save", onPressed: _submit, status: reqStatus)),
                         SizedBox(height: 20),
                       ],
                     ),
                   ),
                 ),
             ),
           ),
          ),
            ],
          ),
        ),
    );
  }


  void updateData(String key,dynamic data,{var subKey,bool noSetState=false}){
    if(noSetState==false)
      if(subKey==null)
        setState(() {
          _authData[key]=data;
        });
      else
        setState(() {
          // _authData[key][subKey]=data;
        });
    else
      _authData[key]=data;

  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    //--------------------Error Checking------------------------
    // if (_authData['goal_id'] == null) {
    //   showInSnackBar("Please choose goal first", context, _scaffoldKey);
    // } else if (_selectedGoal != null && DateTime.parse(_authData['estimation_start']).isAfter(DateTime.tryParse(_selectedGoal.due_date))) {
    //   showInSnackBar("Goal end before this activity start. Please change goal or enter valid time", context, _scaffoldKey);
    // } else {
      try {
        BlocProvider.of<UserBloc>(context)..add(UpdateUserProfile(new User(name:  _authData['name'],address: _authData['address'],mobile: _authData['mobile'],aboutMe: _authData['about_me'],city: _authData['city'])));
      } catch (error) {
        showInSnackBar(error.toString(), context, _scaffoldKey);
      }
    // }
  }



  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    File croppedImage=await ImageCropper.cropImage(sourcePath: image.path,cropStyle: CropStyle.circle,aspectRatio:CropAspectRatio(ratioX: 1,ratioY: 1) );
    String base64Image = base64Encode(croppedImage.readAsBytesSync());
    String fileName = image.path.split("/").last;
    BlocProvider.of<UserBloc>(context).add(UpdateUserProfilePicture(base64Image, fileName));
  }

@override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _aboutMeController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
  }
}
