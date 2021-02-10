import 'package:PromoMeCompany/env.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';

class FormPageTitle extends StatelessWidget {
  final String title;
  final bool backButton;
  final Color customBackButtonColor;
  final bool actionButton;
  final bool secondActionButton;
  final Widget actionArea;
  final Function actionFunction;
  final Function secondActionButtonFunction;
  final Function backButtonFunction;
  final TextStyle customTitleStyle;

  const FormPageTitle({Key key, this.title, this.backButton = false, this.customBackButtonColor, this.actionButton = false, this.actionFunction, this.actionArea, this.customTitleStyle, this.backButtonFunction, this.secondActionButtonFunction, this.secondActionButton = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: backButton
                ? GestureDetector(
                    onTap: () {
                      if (backButtonFunction == null) {
                        Navigator.canPop(context)?Navigator.pop(context):Navigator.of(context).pushReplacementNamed(Env.homePage);
                      } else {
                        backButtonFunction();
                      }
                    },
                    child: Container(
                      height: 40,
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Root.locale == Locale('ar')
                              ? FontAwesomeIcons.arrowRight:FontAwesomeIcons.arrowLeft,
                          color: customBackButtonColor ?? Theme.of(context).textTheme.headline3.color,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          Expanded(
            flex: 9,
            child: Container(
              child: Text(
                AppLocalizations.of(context).translate(title,defaultText:title),
                style: customTitleStyle != null
                    ? customTitleStyle
                    : Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          actionArea != null
              ? actionArea
              : Flexible(
                flex: actionButton && secondActionButton ? 2 : 1,
                child: Row(
                  children: [
                    secondActionButton
                        ? GestureDetector(
                            onTap: secondActionButtonFunction,
                            child: Container(
                              color: Colors.transparent,
                              height: 40,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(Icons.history, color: customBackButtonColor ?? Theme.of(context).textTheme.headline3.color),
                              ),
                            ),
                          )
                        : Container(),
                    actionButton
                        ? GestureDetector(
                            onTap: actionFunction,
                            child: Container(
                              color: Colors.transparent,
                              height: 40,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Icon(Icons.add, color: customBackButtonColor ?? Theme.of(context).textTheme.headline3.color),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
