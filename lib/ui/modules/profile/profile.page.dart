import 'package:PromoMeCompany/ui/modules/profile/components/profile.settings.button.component.dart';
import 'package:PromoMeCompany/ui/modules/profile/components/profile.tag.component.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';


class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfileTagComponent(user: Root.user),
              Divider(thickness: 1),
              SettingsButtonComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
