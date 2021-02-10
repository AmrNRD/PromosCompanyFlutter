import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/video.card.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';



class VideosTab extends StatefulWidget {
  @override
  _VideosTabState createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {


  @override
  void initState() {
    super.initState();
    BlocProvider.of<VideoBloc>(context).add(GetAllMyVideos());
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
                    AppLocalizations.of(context).translate("my videos"),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  BlocListener<VideoBloc,VideoState>(
                    listener: (context,state){
                      if(state is VideoLoaded)
                        BlocProvider.of<VideoBloc>(context).add(GetAllMyVideos());
                    },
                    child: BlocBuilder<VideoBloc,VideoState>(
                      builder: (context,state){
                        if(state is VideoLoading){
                          return Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor));
                        } else if(state is VideosLoaded){
                          if (state.videos.isEmpty) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: GenericState(
                                size: 40,
                                margin: 8,
                                fontSize: 16,
                                removeButton: true,
                                imagePath: "assets/icons/box_icon.svg",
                                titleKey:
                                AppLocalizations.of(context).translate("No Ads!", defaultText: "No Ads!"),
                                bodyKey: AppLocalizations.of(context).translate(
                                  "You don't have any ad yet you can press add button to start add one"
                                ),
                              ),
                            );
                          }else {
                          return  ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.videos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DelayedAnimation(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(bottom: index + 1 == state.videos.length ? 0 : 16),
                                  child: VideoCard(adVideo: state.videos[index]),
                                ),
                                delay: 150*index,
                              );
                            },
                          );
                          }
                        }else if(state is VideoError){
                          return Container(
                            alignment: Alignment.center,
                            child: GenericState(
                              size: 180,
                              margin: 8,
                              fontSize: 16,
                              removeButton: false,
                              imagePath: "assets/icons/box_icon.svg",
                              titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
                              bodyKey: state.message,
                              onPress: ()=>BlocProvider.of<VideoBloc>(context).add(GetAllMyVideos()),
                              buttonKey: "reload",
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }






}
