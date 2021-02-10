
import 'dart:convert';
import 'dart:io';


import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:PromoMeCompany/ui/common/form_page_title.dart';
import 'package:PromoMeCompany/ui/modules/add_video/ad_video_form.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class AddVideoPage extends StatefulWidget {


  const AddVideoPage() : super();

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  VideoBloc _videoBloc;
  File video;


  Map<String, dynamic> videoData = {
  };
  int reqStatus=0;

  @override
  void initState() {
    // videoData['estimation_start'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // videoData['estimation_end'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().add(new Duration(minutes: 30)));
    // videoData['end_at'] = null;
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
          FormPageTitle(title: "New ad video", backButton: true),
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
           child: BlocProvider<VideoBloc>(
              create: (context) => _videoBloc = VideoBloc(new VideoDataRepository()),
              child: BlocListener<VideoBloc, VideoState>(
                listener: (context, state) async {
                  if (state is VideoLoading) {
                    setState(() {reqStatus=1;});
                  } else if (state is VideoLoaded) {
                    setState(() {reqStatus=2;});
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushNamedAndRemoveUntil(GoalDetailsPage.routeName, ModalRoute.withName(HomePage.routeName), arguments: _selectedGoal);
                  } else if (state is VideoError) {
                    print("error2: "+state.message);
                    setState(() {reqStatus=0;});
                    showInSnackBar(state.message, context, _scaffoldKey);
                  }
                },
                child: AdVideoForm(scaffoldKey: _scaffoldKey, formKey: _formKey, onSave: updateData, submit: _submit, defaultData: videoData,status: reqStatus,setVideo:setVideo),
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
          videoData[key]=data;
        });
      else
        setState(() {
          videoData[key][subKey]=data;
        });
    else
      videoData[key]=data;

  }
  void setVideo(File newVideo){
    print('video set');
    setState(() {
      video=newVideo;
    });
  }

  Future<void> _submit() async {
    print('submit');
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    //--------------------Error Checking------------------------
    // if (videoData['goal_id'] == null) {
    //   showInSnackBar("Please choose goal first", context, _scaffoldKey);
    // } else if (_selectedGoal != null && DateTime.parse(videoData['estimation_start']).isAfter(DateTime.tryParse(_selectedGoal.due_date))) {
    //   showInSnackBar("Goal end before this activity start. Please change goal or enter valid time", context, _scaffoldKey);
    // } else {
      try {
        if(video==null)
          showInSnackBar(AppLocalizations.of(context).translate("upload video"), context, _scaffoldKey);
        _videoBloc..add(StoreVideo(
          new AdVideo( name: videoData['name'], targetViews: videoData['target_views'], link:  videoData['link'],ageFrom:  videoData['age_from'],ageTo: videoData['age_to'],genders: jsonEncode(videoData['genders']),cities: jsonEncode(videoData['cities'])),
            video
          ));
      } catch (error) {
        print("error1: "+error.toString());
        showInSnackBar(error.toString(), context, _scaffoldKey);
      }
    // }
  }


  @override
  void dispose() {
    _videoBloc.close();
    super.dispose();
  }
}
