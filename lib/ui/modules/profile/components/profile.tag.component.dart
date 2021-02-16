import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/core.util.dart';
import '../../../style/app.dimens.dart';


class ProfileTagComponent extends StatelessWidget {
  final User user;

  const ProfileTagComponent({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 60,
            width: 60,
            child: ImageProcessor().customImage(
              context,
              user?.image,
            ),
          ),
          SizedBox(
            width: AppDimens.marginDefault16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user?.name ?? "",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                user?.email ?? "",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
