import 'package:PromoMeCompany/data/models/cycle.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CycleCardComponent extends StatelessWidget {
  final Cycle cycle;
  final Function onClick;

  const CycleCardComponent({Key key,@required this.cycle,@required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.black.withOpacity(0.2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  margin: EdgeInsetsDirectional.only(end: 16),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    ),
                  ),
                  child:Icon(FontAwesomeIcons.film),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Text(
                        cycle.name,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Text(AppLocalizations.of(context).translate("points",replacement: (cycle.points??0).toString()), style: Theme.of(context).textTheme.headline3),
                    )
                  ],
                ),
              ],

            ),

          ],
        ),
      ),
    );
  }
}
