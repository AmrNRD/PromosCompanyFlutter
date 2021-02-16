import 'package:PromoMeCompany/main.dart';
import 'package:PromoMeCompany/ui/common/user_circular_photo.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';

class WriteSomethingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UserCircularPhoto(photo: Root.user.image,size: 56),
                SizedBox(width: 7.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 70.0,
                  width: MediaQuery.of(context).size.width/1.45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey[400]
                    ),
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Center(child: Text(AppLocalizations.of(context).translate('Write something here...'))),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}

