import 'dart:async';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/constants.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';


class StoreTabPage extends StatefulWidget {
  @override
  _StoreTabPageState createState() => _StoreTabPageState();
}

class _StoreTabPageState extends State<StoreTabPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 50),
            child:BlocBuilder<PostBloc,PostState>(
              builder: (context,state){
                if(state is PostLoading){
                  return Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor));
                } else if(state is PostLoaded){
//                  return Container(
//                    alignment: Alignment.center,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(AppLocalizations.of(context).translate("scan_me"),style: Theme.of(context).textTheme.headline1),
//                        Text(AppLocalizations.of(context).translate("slogan"),style: Theme.of(context).textTheme.headline2),
//                        SizedBox(height: 75),
//                        QrImage(
//                          data:state.qr,
//                          version: QrVersions.auto,
//                          size: screenAwareSize(320, context),
//                        ),
//                        SizedBox(height: 100),
//                      ],
//                    ),
//                  );
                }else if(state is PostError){
                  return Container(
                      margin: EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.error, color: AppColors.failedColor, size: screenAwareSize(250, context)),
                          SizedBox(height: 20),
                          Text(AppLocalizations.of(context).translate("error_occurred",replacement:": "+state.message)),
                          SizedBox(height: 50),
                        ],
                      )
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  child: GenericState(
                    size: 180,
                    margin: 8,
                    fontSize: 16,
                    removeButton: false,
                    imagePath: "assets/icons/box_icon.svg",
                    titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
                    onPress: ()=>BlocProvider.of<PostBloc>(context).add(GetAllPastsEvent()),
                    buttonKey: "reload",
                  ),
                );
              },
            ),
          ),
        ));
  }





}
