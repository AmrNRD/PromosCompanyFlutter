
import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/env.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';



class VideoCard extends StatefulWidget {
  final AdVideo adVideo;

  const VideoCard({Key key, @required this.adVideo}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController _controller;
  bool didInit=false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.adVideo.video)
      ..initialize().then((_) {
        setState(() {
          didInit=true;
        });
      });

  }
  @override
  Widget build(BuildContext context) {
   return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Stack(
        children: [
          //image stack
          Container(
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 160,
                  child: _controller.value.initialized? VideoPlayer(_controller)
                    :Container(
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
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        widget.adVideo.name,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context).translate("number_of_views", replacement: widget.adVideo.targetViews.toString()),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context).translate(widget.adVideo.status),
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2.copyWith(color:AppTheme.activeColor(widget.adVideo.status)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );

  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
