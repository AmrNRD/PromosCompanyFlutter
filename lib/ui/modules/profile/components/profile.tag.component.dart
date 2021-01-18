import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/core.util.dart';
import '../../../style/app.dimens.dart';

class ProfileTagComponent extends StatelessWidget {
  final User user;
  final bool showPoints;

  const ProfileTagComponent({Key key, @required this.user, this.showPoints=true,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: ImageProcessor().customImage(
                  context,
                  user?.image??"",
                  isBorder: false
                ),
              ),
              Container(
                height: 80,
                width: 80,
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
          SizedBox(
            width: AppDimens.marginDefault16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                user?.name??"",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                user?.email??"",
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 10),
              showPoints?Text(AppLocalizations.of(context).translate("points",replacement: (user?.points??0).toString()), style: Theme.of(context).textTheme.headline2):Container(),
            ],
          ),
        ],
      ),
    );
  }
}
