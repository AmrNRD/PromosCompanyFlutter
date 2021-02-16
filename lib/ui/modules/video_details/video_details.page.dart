import 'dart:async';
import 'dart:ui';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/bloc/video/video_bloc.dart';
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/data/repositories/video_repository.dart';
import 'package:PromoMeCompany/ui/modules/sidemenu/components/side.menu.button.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/dots_indicator.dart';
import 'package:PromoMeCompany/utils/sizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../../env.dart';

class VideoDetailsPage extends StatefulWidget {
  final AdVideo video;
  const VideoDetailsPage({Key key,@required this.video}) : super(key: key);

  @override
  _VideoDetailsPageState createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {

  bool allowBlocStateUpdates = false;
  void allowBlocUpdates(bool allow) => setState(() => allowBlocStateUpdates = allow);
  VideoBloc storeBloc;
  AdVideo video;
  @override
  void initState() {
    super.initState();
    video=widget.video;
    storeBloc=new VideoBloc(new VideoDataRepository());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onPop(),
      child: Scaffold(
          body: BlocProvider<VideoBloc>(
            create: (context)=>storeBloc,
            child: BlocListener<VideoBloc,VideoState>(
              listener: (context,state){
                if(state is VideoLoaded){
                  setState(() {
                    video=state.video;
                  });
                }
              },
              child: Listener(
                onPointerMove: (details) => allowBlocUpdates(true),
                onPointerUp: (details) => allowBlocUpdates(true),
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      DetailsHeader(
                        allowBlocStateUpdates: allowBlocStateUpdates,
                        innerBoxIsScrolled: innerBoxIsScrolled,
                        video: video,
                        bloc: storeBloc,
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: DetailsHeaderHolder(
                          child: Container()
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    color: Theme.of(context).cardColor,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        margin: EdgeInsetsDirectional.only(top: 0.120 * SizeConfig.screenWidth + 4.50 * SizeConfig.widthMultiplier),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              video.name,
                              style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 24),
                            ),
                            SideMenuButton(icon:"assets/icons/share_icon.svg",title: "targeted_views",subTitle: "",onTap: null,replacement: video.targetViews.toString()),
                            Divider(thickness: 1),
                            SideMenuButton(icon:"assets/icons/profile_icon.svg",title: "number_of_views",subTitle: "",onTap: null,replacement: video.numberOfViews.toString()),
                            Divider(thickness: 1),
                            video?.cities!=null&&video.cities.length>0?SideMenuButton(icon:"assets/icons/lang_icon.svg",title: video.cities.join(" , "),subTitle: "",onTap: null):Container(),
                            video?.cities!=null&&video.cities.length>0?Divider(thickness: 1):Container(),
                            video?.genders!=null&&video.genders.length>0?SideMenuButton(icon:"assets/icons/profile_icon.svg",title: video.genders.join(" , "),subTitle: "",onTap: null):Container(),
                            video?.genders!=null&&video.genders.length>0?Divider(thickness: 1):Container(),
                            SideMenuButton(icon:"assets/icons/lang_icon.svg",title: Text(AppLocalizations.of(context).translate(video.status), softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2.copyWith(color:AppTheme.activeColor(video.status)),),subTitle: "",onTap: null,),

                          ],
                        ),
                      ),
                    ),
                  ),

                  // ************************** ************************** ************************** **************************
                ),
              ),
            ),
          )

        /*PropertyDetailsAppBar(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PropertyOverViewComponent(),
          ),
        ),*/
      ),
    );
  }

  onPop() async{
     Navigator.of(context).pop(video);
  }

}


class DetailsHeaderHolder extends SliverPersistentHeaderDelegate {
  final Widget child;

  const DetailsHeaderHolder({
    this.child
  });

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 0.10 * SizeConfig.widthMultiplier;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: child);
  }

  @override
  bool shouldRebuild(DetailsHeaderHolder oldDelegate) => false;
}


class DetailsHeader extends StatefulWidget {
  final bool allowBlocStateUpdates;
  final bool innerBoxIsScrolled;
  final AdVideo video;
  final VideoBloc bloc;
  const DetailsHeader({
    Key key,
    this.allowBlocStateUpdates,
    this.innerBoxIsScrolled,
    this.bloc,
    @required this.video,
  }) : super(key: key);

  @override
  _FlexibleHeaderState createState() => _FlexibleHeaderState();
}

class _FlexibleHeaderState extends State<DetailsHeader> {
  FlexibleHeaderBloc bloc;
  final _pageViewController = new PageController();
  bool play=false;

  VideoPlayerController _controller;
  bool didInit=false;
  @override
  void initState() {
    bloc = FlexibleHeaderBloc();
    _controller = VideoPlayerController.network(widget.video.link)
      ..initialize().then((_) {
        setState(() {
          didInit=true;
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: bloc.initial(),
      stream: bloc.stream,
      builder:(BuildContext context, AsyncSnapshot<DetailsHeaderState> stream) {
        DetailsHeaderState state = stream.data;

        return SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            pinned: true,
            primary: true,
            forceElevated: widget.innerBoxIsScrolled,
            expandedHeight: SizeConfig.screenHeight * 0.50,
            backgroundColor: Theme.of(context).cardColor,
            centerTitle: true,
            title: Opacity(
              opacity: state.opacityAppBar,
              child: Text(
                AppLocalizations.of(context).translate("sale_item_details"),
                maxLines: 1,
                style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 20,fontWeight: FontWeight.w700),
              ),
            ),
            actions: [
              widget.video.status!="done"?Container(
                padding: EdgeInsets.all(20),
                child: PopupMenuButton(
                  elevation: 3.2,
                  onCanceled: () {
                  },
                  tooltip: 'details',
                  onSelected: (value){
                    if(value=="disable")
                      widget.bloc.add(widget.video.status=="active"?DisableAdVideoEvent(widget.video):EnableAdVideoEvent(widget.video));
                  },
                  child: Icon(FontAwesomeIcons.ellipsisV),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "disable",
                        child: Text(widget.video.status=="active"?AppLocalizations.of(context).translate("disable",defaultText: "disable"):AppLocalizations.of(context).translate("enable"),style: Theme.of(context).textTheme.bodyText1,),
                      )];
                  },
                ),
              ):Container()
            ],
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context,widget.video);
                },
                child: Icon(Icons.arrow_back)),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (widget.allowBlocStateUpdates) {
                  bloc.update(state, constraints.maxHeight);
                }
                return Opacity(
                  opacity: state.opacityFlexible < 0.05
                      ? 0.0
                      : state.opacityFlexible,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background:  Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsetsDirectional.only(bottom: 25),
                          child: InkWell(onTap:(){
                            _controller.value.isPlaying? _controller.pause(): _controller.play();
                            },child: VideoPlayer(_controller)),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsetsDirectional.only(
                            start: 2.5 * SizeConfig.widthMultiplier,
                            end: 2.5 * SizeConfig.widthMultiplier,
                          ),
                          child: Opacity(
                            opacity: state.opacityFlexible < 0.05 ? 0.0 : state.opacityFlexible,
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 20,
                                          offset: Offset(0, 4),
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                    height: 90,
                                    width: 90,
                                    child:  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.video.user.image??Env.dummyProfilePic,
                                        fit: BoxFit.fill,
                                        height: 90,
                                        width: 90,
                                        errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class FlexibleHeaderBloc {
  StreamController<DetailsHeaderState> controller =
  StreamController<DetailsHeaderState>();

  Stream<DetailsHeaderState> get stream => controller.stream;

  Sink get sink => controller.sink;

  void _update(DetailsHeaderState state) => sink.add(state);

  FlexibleHeaderBloc();

  DetailsHeaderState initial() => DetailsHeaderState();

  void _updateOpacity(DetailsHeaderState state) {
    if (state.initialHeight == null || state.currentHeight == null) {
      state.opacityFlexible = 1;
      state.opacityAppBar = 0;
    } else {
      final double offset = (1 / 3) * state.initialHeight;
      double opacity =
          (state.currentHeight - offset) / (state.initialHeight - offset);

      opacity <= 1 ? opacity = opacity : opacity = 1;
      opacity >= 0 ? opacity = opacity : opacity = 0;

      state.opacityFlexible = opacity;
      state.opacityAppBar = (1 - opacity).abs();
    }
  }

  void update(DetailsHeaderState state, double currentHeight) {
    state.initialHeight ??= currentHeight;
    state.currentHeight = currentHeight;

    _updateOpacity(state);
    _update(state);
  }

  void dispose() {
    controller.close();
  }
}


class DetailsHeaderState {
  double initialHeight;
  double currentHeight;

  double opacityFlexible = 1;
  double opacityAppBar = 0;

  DetailsHeaderState();
}