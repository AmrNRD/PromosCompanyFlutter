import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';


class LoadingButton extends StatefulWidget {
  final Function onPressed;
  final String title;
  final int status;


  const LoadingButton({Key key,@required this.title, @required this.onPressed,this.status=1}) : super(key: key);

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>  with TickerProviderStateMixin {
//  AnimationController _animationController;
//  Animation _colorTween;

  @override
  void initState() {
    //todo:reimplement color changing
//    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//    _colorTween = ColorTween(begin: AppTheme.accent, end: Colors.green).animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: RaisedButton(
          child: Container(
            width: widget.status!=0?screenAwareSize(42, context):screenAwareWidth(262, context),
            height:screenAwareSize(42, context),
            child: setUpButtonChild(),
          ),
          onPressed: widget.status!=0 ? null :() {
            widget.onPressed();
            },
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.status!=0 ? 25 : 15)),
          hoverElevation: 5,
          color: widget.status==2 ?Colors.green:AppColors.accentColor1,
          splashColor: widget.status==2 ?Colors.green:Colors.grey,
          animationDuration: Duration(milliseconds: 1000),
        ),

    );
  }
  Widget setUpButtonChild() {
    if (widget.status==0) {
      return Center(
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
        ),
      );
    } else if (widget.status==1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
//      _animationController.forward();
      return Icon(Icons.check, color: Colors.white);
    }
  }

}