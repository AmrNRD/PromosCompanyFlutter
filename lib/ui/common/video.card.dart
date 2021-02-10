import 'dart:io';
import 'dart:typed_data';

import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/env.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';
import 'package:path_provider/path_provider.dart';
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
    print(widget.adVideo.video);
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
      margin: EdgeInsetsDirectional.only(top: 10, bottom: 24),
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Env.videoPage,arguments: widget.adVideo);
        },
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
                    child:didInit?VideoPlayer(_controller):Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor)),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(width: 4),
                            Text(
                              widget.adVideo.user.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(width: 4),

                          ],
                        ),
                        SizedBox(height: 7),
                        Text(
                          widget.adVideo.name,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context).translate("currency", replacement: widget.adVideo.targetViews.toString()),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 7),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // PositionedDirectional(
            //   top: 140,
            //   end:20,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).cardColor,
            //       boxShadow: [
            //         BoxShadow(
            //           blurRadius: 20,
            //           offset: Offset(0, 4),
            //           color: Colors.black.withOpacity(0.2),
            //         ),
            //       ],
            //     ),
            //     child: Container(
            //       height: 56,
            //       width: 56,
            //       padding: EdgeInsets.all(14),
            //       child:  CachedNetworkImage(
            //         imageUrl: adVideo.user.image??Env.dummyProfilePic,
            //         fit: BoxFit.fill,
            //         height: 56,
            //         width: 56,
            //         errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
            //       )
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );

  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
