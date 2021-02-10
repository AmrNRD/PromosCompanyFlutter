import 'dart:io';

import 'package:PromoMeCompany/data/models/demographic.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/ui/common/form_date_picker.dart';
import 'package:PromoMeCompany/ui/common/form_title.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/loading_button.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:video_player/video_player.dart';


class AdVideoForm extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<FormState> formKey;
  final Function onSave;
  final Function submit;
  final Function setVideo;
  final Map defaultData;
  final int status;
  final String buttonText;
  final File video;

  const AdVideoForm({Key key,@required  this.scaffoldKey,@required  this.formKey,@required  this.onSave,@required  this.submit,@required  this.defaultData,@required this.status,@required this.setVideo, this.buttonText="Add", this.video}) : super(key: key);
  @override
  _AdVideoFormState createState() => _AdVideoFormState();
}

class _AdVideoFormState extends State<AdVideoForm> {
  // ignore: non_constant_identifier_names
  String TAG="AdVideo";


  TextEditingController nameController = new TextEditingController();
  TextEditingController videoLinkController = new TextEditingController();
  TextEditingController targetViewsController = new TextEditingController();
  TextEditingController ageFromController = new TextEditingController();
  TextEditingController ageToController = new TextEditingController();

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeLink = FocusNode();
  final FocusNode focusNodeTargetView = FocusNode();
  final FocusNode focusNodeAgeFrom = FocusNode();
  final FocusNode focusNodeAgeTo = FocusNode();



  bool setedVideo=false;

  int remindMeIndex=0;
  int priorityIndex=0;
  DateTime _activityStartTimeDate = DateTime.now();
  DateTime _activityEndTimeDate = DateTime.now();
  VideoPlayerController _controller;
  Duration videoDuration;

    @override
  void initState() {

      // _selectedElement=widget.element;
      // _activityStartTimeDate=DateTime.tryParse(widget.defaultData['estimation_start']);
      // _activityEndTimeDate=DateTime.tryParse(widget.defaultData['estimation_end']);
      // _repeatUntilDate=widget.defaultData['end_at']!=null?DateTime.tryParse(widget.defaultData['end_at']):null;

      // isRepeated = widget.defaultData['schedule_type_id'] != 1;
      // _goalBloc = GoalBloc(new GoalsOfflineDataRepository())..add(GetGoalsByElement(_selectedElement.id));
      // _activityTemplateBloc = ActivityTemplateBloc(new ActivityTemplateDataRepository())..add(GetActivityTemplatesByElement(_selectedElement.id));
      // if(widget.defaultData['name'].length>0)
      //   nameController.text=widget.defaultData['name'];
      // if(widget.defaultData['desc']!=null)
      //   videoLinkController.text=widget.defaultData['desc'];
      // if(widget.defaultData['remind_at']!=null)
      //  {
      //    isReminded=true;
      //    // remindMeIndex=RemindMeAt.RemindMeAtList.indexWhere((re)=>re.minutes==widget.defaultData['remind_at']);
      //  }


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DelayedAnimation(
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 1,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Form(
          key: widget.formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                FormInputField(
                  title: "name",
                  textEditingController: nameController,
                  focusNode: focusNodeName,
                  hint: "Name Of the Video",
                  nextFocusNode: focusNodeLink,
                  textInputAction: TextInputAction.next,
                  validator: (value)=> Validator(context).isNotEmpty(value),
                  onSave: (value) {widget.onSave('name',value);},
                  outterBorder: true,
                  useLabel: true,
                ),
                FormInputField(
                  title: "LinkVideo",
                  textEditingController: videoLinkController,
                  focusNode: focusNodeLink,
                  nextFocusNode: focusNodeTargetView,
                  onSave: (value) {
                    widget.onSave('link',value);
                  },
                  outterBorder: true,
                  useLabel: true,
                ),
                FormInputField(
                  title: "TargetView",
                  textEditingController: targetViewsController,
                  focusNode: focusNodeTargetView,
                  textInputType: TextInputType.number,
                  validator: (value){
                    if (value == null || value.length == 0) {
                      return "${AppLocalizations.of(context).translate("TargetView")} ${AppLocalizations.of(context).translate("missing_data")}";
                    }else  if (int.tryParse(value)==null) {
                      return AppLocalizations.of(context).translate("value must be an integer");
                    }else  if (int.tryParse(value)<50) {
                      return AppLocalizations.of(context).translate("value must be more then 50");
                    }
                  },
                  onSave: (value) {widget.onSave('target_views',int.tryParse(value));},
                  outterBorder: true,
                  useLabel: true,
                ),
                setedVideo?Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Badge(
                      badgeColor: Colors.red,
                      badgeContent: InkWell(onTap: removeVideo,child: Icon(FontAwesomeIcons.times)),
                      position: BadgePosition.topStart(top: 0),
                      child: Container(
                        width: 600,
                        height: 337.5,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    SizedBox(height: 10),
                    videoDuration!=null?Text(AppLocalizations.of(context).translate("video length",replacement: printDuration(videoDuration))):Container(),
                  ],
                ):InkWell(
                  onTap: getVideo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Center(child: Icon(FontAwesomeIcons.upload,size: 60)),
                      SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("enter video"),style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context).translate("if empty no problem"),style: Theme.of(context).textTheme.bodyText1),
                SizedBox(height: 16),
                MultiSelectBottomSheetField(
                  items:cities.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.CHIP,
                  backgroundColor: Theme.of(context).backgroundColor,
                  unselectedColor: Theme.of(context).cardColor,
                  selectedColor: Theme.of(context).accentColor,
                  itemsTextStyle:  Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  selectedItemsTextStyle:  Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  chipDisplay: MultiSelectChipDisplay(chipColor: Theme.of(context).accentColor,textStyle:Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                  searchHint: AppLocalizations.of(context).translate("city"),
                  title: Text(AppLocalizations.of(context).translate("city"),style: Theme.of(context).textTheme.headline3),
                  buttonText: Text(AppLocalizations.of(context).translate("city"),style: Theme.of(context).textTheme.headline3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).textTheme.headline3.color,
                    ),
                  ),
                  onConfirm: (values) {
                    widget.onSave('cities',values);
                  },
                ),
                SizedBox(height: 16),
                MultiSelectBottomSheetField(
                  items:gender.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.CHIP,
                  backgroundColor: Theme.of(context).backgroundColor,
                  unselectedColor: Theme.of(context).cardColor,
                  selectedColor: Theme.of(context).accentColor,
                  itemsTextStyle:  Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  selectedItemsTextStyle:  Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  chipDisplay: MultiSelectChipDisplay(chipColor: Theme.of(context).accentColor,textStyle:Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white)),
                  searchHint: AppLocalizations.of(context).translate("gender"),
                  title: Text(AppLocalizations.of(context).translate("gender"),style: Theme.of(context).textTheme.headline3),
                  buttonText: Text(AppLocalizations.of(context).translate("gender"),style: Theme.of(context).textTheme.headline3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).textTheme.headline3.color,
                    ),
                  ),
                  onConfirm: (values) {
                    widget.onSave('genders',values);
                  },
                ),

                SizedBox(height: 20),
                LoadingButton(
                  title: widget.buttonText,
                  onPressed: widget.submit,
                  status: widget.status,
                ),
                SizedBox(height: 20)

              ],
            ),
          ),
        ),


      ),
      delay: 700,
    );
  }



  void onStartDateChanged(DateTime newDate) {
    setState(() {_activityStartTimeDate = newDate;});
    widget.onSave('estimation_start',DateFormat('yyyy-MM-dd HH:mm:ss').format(_activityStartTimeDate));
    if (_activityStartTimeDate.isAfter(_activityEndTimeDate)||_activityStartTimeDate.isAtSameMomentAs(_activityEndTimeDate)) {
      setState(() {_activityEndTimeDate = _activityStartTimeDate.add(Duration(minutes: 30));});
      widget.onSave('estimation_end',DateFormat('yyyy-MM-dd HH:mm:ss').format(_activityEndTimeDate));
    }
  }

  void onEndDateChanged(DateTime newDate) {
    setState(() {_activityEndTimeDate = newDate;});
    widget.onSave('estimation_end',DateFormat('yyyy-MM-dd HH:mm:ss').format(_activityEndTimeDate));

    if(_activityStartTimeDate.isAfter(newDate)||_activityStartTimeDate.isAtSameMomentAs(_activityEndTimeDate))
    {
      setState(() {
        _activityStartTimeDate = _activityEndTimeDate.subtract(Duration(minutes: 30));
      });
      widget.onSave('estimation_start',DateFormat('yyyy-MM-dd HH:mm:ss').format(_activityStartTimeDate));
    }
  }






  @override
  void dispose() {
    nameController.dispose();
    videoLinkController.dispose();
    focusNodeName.dispose();
    targetViewsController.dispose();
    focusNodeLink.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> getVideo() async {

    PickedFile video = await ImagePicker().getVideo(source: ImageSource.gallery);
    File file=File(video.path);

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        print(_controller.value);
       setState(() {
         videoDuration=_controller.value.duration;
       });
      });
    setState(() {
      setedVideo=true;
    });
    widget.setVideo(file);
  }

  void removeVideo() {

    setState(() {
      setedVideo=false;
      videoDuration=null;
    });
    widget.setVideo(null);
    print(setedVideo);
  }

  bool isNumeric(value) {
    return double.parse(value, (e) => null) != null || int.parse(value, onError: (e) => null) != null;
  }
}

