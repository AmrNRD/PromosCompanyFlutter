
import 'dart:convert';
import 'dart:io';


import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:PromoMeCompany/ui/common/form_page_title.dart';
import 'package:PromoMeCompany/ui/modules/add_sale_item/sale_item_form.dart';
import 'package:PromoMeCompany/ui/modules/add_video/ad_video_form.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class AddSaleItemPage extends StatefulWidget {


  const AddSaleItemPage() : super();

  @override
  _AddSaleItemPageState createState() => _AddSaleItemPageState();
}

class _AddSaleItemPageState extends State<AddSaleItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  StoreBloc _saleBloc;
  List<File> photos=[];

  Map<String, dynamic> saleData = {};
  int reqStatus=0;

  @override
  void initState() {
    // saleData['estimation_start'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // saleData['estimation_end'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(new Duration(minutes: 30)));
    // saleData['end_at'] = null;
    // _selectedGoal=widget.selectedGoal;
    // if (widget.selectedGoal != null)
    //     _selectedElement = elementList[widget.selectedGoal.element_id - 1];
    //  else
    //     _selectedElement = elementList[0];

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
          FormPageTitle(title: "New Sale item", backButton: true),
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
           child: BlocProvider<StoreBloc>(
              create: (context) => _saleBloc = StoreBloc(new StoreDataRepository()),
              child: BlocListener<StoreBloc, StoreState>(
                listener: (context, state) async {
                  if (state is SaleItemLoading) {
                    setState(() {reqStatus=1;});
                  } else if (state is SaleItemLoaded) {
                    setState(() {reqStatus=2;});
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushNamedAndRemoveUntil(GoalDetailsPage.routeName, ModalRoute.withName(HomePage.routeName), arguments: _selectedGoal);
                  } else if (state is SaleItemError) {
                    setState(() {reqStatus=0;});
                    showInSnackBar(state.message, context, _scaffoldKey);
                  }
                },
                child: SaleItemForm(scaffoldKey: _scaffoldKey, formKey: _formKey, onSave: updateData, submit: _submit, defaultData: saleData,status: reqStatus,addPhoto:addPhoto,photos:photos,deletePhoto: deletePhoto,),
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
          saleData[key]=data;
        });
      else
        setState(() {
          saleData[key][subKey]=data;
        });
    else
      saleData[key]=data;

  }
  void addPhoto(File newPhoto){
    print('photo set');
    setState(() {
      photos.add(newPhoto);
    });
  }
  void deletePhoto(File photo){
    setState(() {
      photos.remove(photo);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    //--------------------Error Checking------------------------
    // if (saleData['goal_id'] == null) {
    //   showInSnackBar("Please choose goal first", context, _scaffoldKey);
    // } else if (_selectedGoal != null && DateTime.parse(saleData['estimation_start']).isAfter(DateTime.tryParse(_selectedGoal.due_date))) {
    //   showInSnackBar("Goal end before this activity start. Please change goal or enter valid time", context, _scaffoldKey);
    // } else {
      try {
        if(photos==null||photos.length==0)
          showInSnackBar(AppLocalizations.of(context).translate("upload video"), context, _scaffoldKey);
        else
        _saleBloc..add(StoreItem(
          new SaleItem( title: saleData['title'],description: saleData['description'],price: saleData['price'], targetViews: saleData['target_views'],ageFrom:  saleData['age_from'],ageTo: saleData['age_to'],genders: saleData['genders'],cities: saleData['cities']),
            photos
          ));
      } catch (error) {
        showInSnackBar(error.toString(), context, _scaffoldKey);
      }
    // }
  }


  @override
  void dispose() {
    _saleBloc.close();
    super.dispose();
  }
}
