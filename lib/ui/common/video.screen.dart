import 'package:PromoMeCompany/data/models/ad_video.dart';
import 'package:PromoMeCompany/ui/common/video_stories.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  final AdVideo adVideo;
  final Function onFinish;
  final int index;
  final int count;

  const VideoScreen({Key key,
    @required this.adVideo,
    @required this.onFinish,
    this.index,
    this.count})
      : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.adVideo.video)
      ..initialize().then((_) {
        _controller.play();
        _animationController = AnimationController(
          vsync: this,
          duration: _controller.value.duration,
        );
        _animationController.forward();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        widget.onFinish();
        print("finish");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: VideoPlayer(_controller),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 8.0 - 2 / 2,
          right: 8.0 - 2 / 2,
          child: Row(
            children: <Widget>[
              ...List.generate(
                widget.count,
                    (idx) {
                  print(widget.count);
                  print(idx);
                  return Expanded(
                    child: idx == widget.index
                        ? AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return VideoStory.instagramProgressSegmentBuilder(
                          context,
                          _animationController?.value??0,
                          2,
                        );
                      },
                    )
                        : VideoStory.instagramProgressSegmentBuilder(
                      context,
                      idx < widget.index ? 1.0 : 0.0,
                      2,
                    ),
                  );
                },
              )
            ],
          ),
        ),
        PositionedDirectional(
        top: MediaQuery.of(context).padding.top+10,
          start: 10,
          child: Row(
            children: [
                  GestureDetector(
                    onTap: (){
                      _controller.pause();
                      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ImageProcessor().customImage(
                            context,
                            widget.adVideo.user.image,
                            isBorder: false
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.8), width: 2),
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Text(
                    widget.adVideo.user.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
      ),
        Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: GestureDetector(
            onTap: () async {
                  await launch(widget.adVideo.link);
            },
            child: Icon(Icons.keyboard_arrow_up,size: 120,color: Colors.white))
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
    _animationController.dispose();
  }
}
