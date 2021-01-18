
import 'package:PromoMeCompany/data/models/cycle_video.dart';
import 'package:PromoMeCompany/ui/common/video.screen.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///
/// Callback function that accepts the index of moment and
/// returns its' Duration
///
typedef Duration MomentDurationGetter(int index);

///
/// Builder function that accepts current build context, moment index,
/// moment progress and gap between each segment and returns widget for segment
///
typedef Widget ProgressSegmentBuilder(
    BuildContext context, double progress, double gap);

///
/// Widget that allows you to use stories mechanism in your apps
///
/// **Usage:**
///
/// ```dart
/// VideoStory(
///   onFlashForward: Navigator.of(context).pop,
///   onFlashBack: Navigator.of(context).pop,
///   momentCount: 4,
///   momentDurationGetter: (idx) => Duration(seconds: 4),
///   momentBuilder: (context, idx) {
///     return Container(
///       color: CupertinoColors.destructiveRed,
///       child: Center(
///         child: Text(
///           'Moment ${idx + 1}',
///           style: TextStyle(color: CupertinoColors.white),
///         ),
///       ),
///     );
///   },
/// )
/// ```
///
class VideoStory extends StatefulWidget {
  const VideoStory({
    Key key,
    this.momentDurationGetter,
    this.momentCount,
    this.momentBuilder,
    this.onFlashForward,
    this.onFlashBack,
    this.onVideoFinished,
    this.videoList,
    this.progressSegmentBuilder = VideoStory.instagramProgressSegmentBuilder,
    this.progressSegmentGap = 2.0,
    this.progressOpacityDuration = const Duration(milliseconds: 300),
    this.momentSwitcherFraction = 0.33,
    this.startAt = 0,
    this.topOffset,
    this.fullscreen = true,
  })  : assert(momentCount != null),
        assert(momentCount > 0),
        assert(momentDurationGetter != null),
        assert(momentSwitcherFraction != null),
        assert(momentSwitcherFraction >= 0),
        assert(momentSwitcherFraction < double.infinity),
        assert(progressSegmentGap != null),
        assert(progressSegmentGap >= 0),
        assert(progressOpacityDuration != null),
        assert(momentSwitcherFraction < double.infinity),
        assert(startAt != null),
        assert(startAt >= 0),
        assert(startAt < momentCount),
        assert(fullscreen != null),
        super(key: key);




  final List<CycleVideo> videoList;


  final IndexedWidgetBuilder momentBuilder;

  ///
  /// Function that must return Duration for each moment
  ///
  final MomentDurationGetter momentDurationGetter;

  ///
  /// Sets the number of moments in story
  ///
  final int momentCount;

  ///
  /// Gets executed when user taps the right portion of the screen
  /// on the last moment in story or when story finishes playing
  ///
  final VoidCallback onFlashForward;

  ///
  /// Gets executed when finishing the video and started the next
  ///
  final Function onVideoFinished;

  ///
  /// Gets executed when user taps the left portion
  /// of the screen on the first moment in story
  ///
  final VoidCallback onFlashBack;

  ///
  /// Sets the ratio of left and right tappable portions
  /// of the screen: left for switching back, right for switching forward
  ///
  final double momentSwitcherFraction;

  ///
  /// Builder for each progress segment
  /// Defaults to Instagram-like minimalistic segment builder
  ///
  final ProgressSegmentBuilder progressSegmentBuilder;

  ///
  /// Sets the gap between each progress segment
  ///
  final double progressSegmentGap;

  ///
  /// Sets the duration for the progress bar show/hide animation
  ///
  final Duration progressOpacityDuration;

  ///
  /// Sets the index of the first moment that will be displayed
  ///
  final int startAt;

  ///
  /// Controls progress segments's container oofset from top of the screen
  ///
  final double topOffset;

  ///
  /// Controls fullscreen behavior
  ///
  final bool fullscreen;

  static Widget instagramProgressSegmentBuilder(BuildContext context,  double progress, double gap) =>
      Container(
        height: 3.0,
        margin: EdgeInsets.symmetric(horizontal: gap / 2),
        decoration: BoxDecoration(
          color: Color(0x80ffffff),
          borderRadius: BorderRadius.circular(1.0),
        ),
        child: FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: progress,
          child: Container(
            color: AppColors.primaryColor,
          ),
        ),
      );

  @override
  _VideoStoryState createState() => _VideoStoryState();
}

class _VideoStoryState extends State<VideoStory> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _currentIdx;
  bool _isInFullscreenMode = false;
  IndexedWidgetBuilder momentBuilder;
  void switchToNextOrFinish() {
    print("here");
    print('_currentIdx');
    print(_currentIdx);

    print("widget.momentCount");
    print(widget.momentCount);

    if (_currentIdx+1  == widget.momentCount && widget.onFlashForward != null) {
      print("story finished");
      widget.onVideoFinished(_currentIdx);
      widget.onFlashForward();
    } else  {
      print("in");
      widget.onVideoFinished(_currentIdx);
      setState(() => _currentIdx += 1);
    }
  }

  void _switchToPrevOrFinish() {
    _controller.stop();
    if (_currentIdx - 1 < 0 && widget.onFlashBack != null) {
      widget.onFlashBack();
    } else {
      _controller.reset();
      if (_currentIdx - 1 >= 0) {
        setState(() => _currentIdx -= 1);
      }
      _controller.duration = widget.momentDurationGetter(_currentIdx);
      _controller.forward();
    }
  }

  void _onTapDown(TapDownDetails details) => _controller.stop();

  void _onTapUp(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < width * widget.momentSwitcherFraction) {
      _switchToPrevOrFinish();
    } else {
      switchToNextOrFinish();
    }
  }

  void _onLongPress() {
    _controller.stop();
    setState(() => _isInFullscreenMode = true);
  }

  void _onLongPressEnd() {
    setState(() => _isInFullscreenMode = false);
    _controller.forward();
  }

  Future<void> _hideStatusBar() => SystemChrome.setEnabledSystemUIOverlays([]);
  Future<void> _showStatusBar() =>
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  @override
  void initState() {
    if (widget.fullscreen) {
      _hideStatusBar();
    }
    momentBuilder=(context, index) =>videoBuilder(index);


    _currentIdx = widget.startAt;



    super.initState();
  }

  @override
  void didUpdateWidget(VideoStory oldWidget) {
    if (widget.fullscreen != oldWidget.fullscreen) {
      if (widget.fullscreen) {
        _hideStatusBar();
      } else {
        _showStatusBar();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.fullscreen) {
      _showStatusBar();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        momentBuilder(
          context,
          _currentIdx,
        ),
//        videoBuilder(_currentIdx),
//        Positioned(
//          top: 0,
//          left: 0,
//          right: 0,
//          bottom: 0,
//          child: GestureDetector(
//            onTapDown: _onTapDown,
//            onLongPress: _onLongPress,
//            onLongPressUp: _onLongPressEnd,
//          ),
//        ),
      ],
    );
  }

  videoBuilder(int index) {
    print('videoBuilder');
    return VideoScreen(key:Key(index.toString()),adVideo: widget.videoList[index].adVideo,onFinish: ()=>switchToNextOrFinish(),count: widget.videoList.length,index: index);
  }




}
