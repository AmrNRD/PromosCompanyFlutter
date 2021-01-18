import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GenericState extends StatelessWidget {
  final Function onPress;
  final bool removeButton;
  final String imagePath;
  final String titleKey;
  final String bodyKey;
  final String buttonKey;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  /// Used to size title and body, body wil always be -4 from the given fontSize
  final double fontSize;
  final double size;
  final double margin;

  const GenericState({
    Key key,
    this.onPress,
    this.removeButton = false,
    this.imagePath,
    this.titleKey,
    this.bodyKey,
    this.titleStyle,
    this.bodyStyle,
    this.buttonKey,
    this.size,
    this.margin,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
                width: size ?? null,
                height: size ?? null,
              ),
            ),
            SizedBox(
              height: margin ?? 40,
            ),
            Text(
              AppLocalizations.of(context).translate(
                titleKey,
                defaultText: titleKey,
              ),
              style: titleStyle ?? Theme.of(context).textTheme.headline2.copyWith(fontSize: (fontSize ?? 24)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Container(
              margin: EdgeInsets.symmetric(horizontal: (fontSize ?? 24) - 4),
              child: Text(
                AppLocalizations.of(context).translate(bodyKey, defaultText: bodyKey)??"",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ),

            removeButton
                ? Container()
                : FlatButton(
                    child: Text(AppLocalizations.of(context).translate(buttonKey ?? "", defaultText: buttonKey ?? ""),style: Theme.of(context).textTheme.headline4.copyWith(color: AppColors.failedColor)),
                    onPressed: onPress,
                    textColor: AppColors.accentColor1,
                  )
          ],
        ),
      ),
    );
  }
}
