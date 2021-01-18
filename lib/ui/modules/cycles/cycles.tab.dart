import 'package:PromoMeCompany/bloc/cycle/cycle_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:PromoMeCompany/ui/common/cycle.card.component.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/video.screen.dart';
import 'package:PromoMeCompany/ui/common/video_stories.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

import '../../../main.dart';


class CyclesTab extends StatefulWidget {
  @override
  _CyclesTabState createState() => _CyclesTabState();
}

class _CyclesTabState extends State<CyclesTab> {


  @override
  void initState() {
    super.initState();
    BlocProvider.of<CycleBloc>(context).add(GetAllCyclesEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child:Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context).translate("cycles"),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  BlocListener<CycleBloc,CycleState>(
                    listener: (context,state){
                      if(state is CycleWatchedSuccessfully){
                        setState(() {
                          Root.user=state.user;
                        });
                        BlocProvider.of<CycleBloc>(context).add(GetAllCyclesEvent());
                      }
                    },
                    child: BlocBuilder<CycleBloc,CycleState>(
                      builder: (context,state){
                        if(state is CycleLoading){
                          return Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor));
                        } else if(state is CyclesLoaded){
                          if (state.cycles.isEmpty) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: GenericState(
                                size: 40,
                                margin: 8,
                                fontSize: 16,
                                removeButton: true,
                                imagePath: "assets/icons/box_icon.svg",
                                titleKey:
                                AppLocalizations.of(context).translate("No cycles!", defaultText: "No cycles!"),
                                bodyKey: AppLocalizations.of(context).translate(
                                  "Sorry no cycle were available in your area, please check later",
                                  defaultText: "Sorry no cycle were available in your area, please check later",
                                ),
                              ),
                            );
                          }else {
                          return  ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.cycles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DelayedAnimation(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(
                                      bottom: index + 1 == state.cycles.length ? 0 : 16),
                                  child: CycleCardComponent(cycle: state.cycles[index],onClick:()=>onCycleClicked(state.cycles[index]) ,),
                                ),
                                delay: 150*index,
                              );
                            },
                          );
                          }
                        }else if(state is CycleError){
                          return Container(
                            alignment: Alignment.center,
                            child: GenericState(
                              size: 180,
                              margin: 8,
                              fontSize: 16,
                              removeButton: false,
                              imagePath: "assets/icons/sad.svg",
                              titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
                              bodyKey: state.message,
                              onPress: ()=>BlocProvider.of<CycleBloc>(context).add(GetAllCyclesEvent()),
                              buttonKey: "reload",
                            ),
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          child: GenericState(
                            size: 180,
                            margin: 8,
                            fontSize: 16,
                            removeButton: false,
                            imagePath: "assets/icons/sad.svg",
                            titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
                            onPress: ()=>BlocProvider.of<CycleBloc>(context).add(GetAllCyclesEvent()),
                            buttonKey: "reload",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  onCycleClicked(Cycle cycle) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoPageScaffold(
          child: VideoStory(
            onFlashForward:()=>onCycleFinish(cycle),
            onFlashBack: ()=>onCycleFinish(cycle),
            momentCount: cycle.cycleVideos.length,
            onVideoFinished: (index)=>onVideoFinish(cycle.cycleVideos[index]),
            videoList: cycle.cycleVideos,
            momentBuilder:(context, index) =>VideoScreen(adVideo: cycle.cycleVideos[index].adVideo,onFinish: (){},count: cycle.cycleVideos.length,index: index) ,
            momentDurationGetter: (idx) => const Duration(seconds: 10),
          ),
        );
      },
    );
  }


  onCycleFinish(Cycle cycle){
    BlocProvider.of<CycleBloc>(context).add(SendCycleHadBeenWatched(cycle));
    Navigator.of(context).pop();
  }


  onVideoFinish(CycleVideo video){
    BlocProvider.of<VideoBloc>(context).add(SendVideoHadBeenWatched(video));
  }




}
