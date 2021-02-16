import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../env.dart';


class CustomAppBar extends PreferredSize {
  final title;
  final double height;
  final double elevation;
  final bool canPop;
  final Widget leadingButton;
  final List<Widget> actionButtons;

  CustomAppBar({
    this.title,
    this.height = kToolbarHeight,
    this.canPop = false,
    this.elevation,
    this.leadingButton,
    this.actionButtons
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation:  0.0,
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: title is String?Text(title, style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w500)): title??
        Hero(
          tag: "Logo",
          child: Image.asset(
            "assets/images/colored_logo.png",
            height: screenAwareSize(50, context),
            width: screenAwareWidth(70, context),
          ),
        ),
      leading: canPop ? null : GestureDetector(
        onTap: () {
            Navigator.pushNamed(context, Env.sideMenuPage);
        },
        child: Container(
          color: Colors.transparent,
          margin:EdgeInsetsDirectional.only(start: 10),
          child: Icon(FontAwesomeIcons.bars),
        ),
      ),
      actions: actionButtons??[],
    );
  }
}
