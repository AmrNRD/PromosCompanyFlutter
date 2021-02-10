import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final Widget rightWidget;
  final TextStyle customTextStyle;

  const FormTitle(this.title,{this.rightWidget, this.customTextStyle});
  @override
  Widget build(BuildContext context) {
       return Padding(
      padding: EdgeInsets.only(top: 12.0, left: 25.0, right: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: customTextStyle??Theme.of(context).textTheme.headline2,
          ),
          rightWidget != null ? rightWidget : Container(),
        ],
      ),
    );
  }
}
