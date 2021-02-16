import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/ui/modules/profile/components/profile.tag.component.dart';
import 'package:PromoMeCompany/ui/modules/view_profile/components/about_me.tab.dart';
import 'package:PromoMeCompany/ui/modules/view_profile/components/posts.tab.dart';
import 'package:PromoMeCompany/ui/modules/view_profile/components/sales.tab.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';

class ShowProfilePage extends StatefulWidget {
  final User user;

  const ShowProfilePage({Key key,@required this.user}) : super(key: key);
  @override
  _ShowProfilePageState createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsDirectional.only(top: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ProfileTagComponent(user: widget.user),
              DefaultTabController(
                length: 3,
                child: Column(
              children: [
              SizedBox(
              height: 12,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 40,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TabBar(
                  indicatorColor: AppColors.accentColor1,
                  indicatorWeight: 3,
                  labelStyle: Theme.of(context).textTheme.headline1,
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context).translate("about_us"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context).translate("posts"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context).translate("sale_items"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      height: 600,
                      child: TabBarView(
                        children: [
                          AboutMeTab(aboutMe: widget.user.aboutMe),
                          PostsTab(scaffoldKey: _scaffoldKey, user: widget.user),
                          SalesTab(user: widget.user),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
