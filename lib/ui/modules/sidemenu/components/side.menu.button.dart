import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SideMenuButton extends StatelessWidget {
  final Function onTap;
  final String icon;
  final title;
  final String replacement;
  final subTitle;
  final bool isSvg;
  const SideMenuButton({
    Key key,@required this.onTap,@required this.title,@required this.subTitle, this.icon,this.isSvg=true,this.replacement
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icon!=null?Container(height:35,width:35,padding:EdgeInsets.all(8),decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.accentColor1.withOpacity(0.15)),child: isSvg?SvgPicture.asset(icon,color: AppColors.accentColor1,height: 15,width: 15,fit: BoxFit.contain,allowDrawingOutsideViewBox:false):Image.asset(icon,height: 15,width: 15,fit: BoxFit.contain)):Container(),
                  SizedBox(width: 16),
                  Flexible(
                    child: title is String ?Text(
                      AppLocalizations.of(context).translate(title, defaultText: title,replacement: replacement),
                      style: Theme.of(context).textTheme.headline2,
                    ):title,
                  ),
                ],
              ),
            ),
            subTitle!=null?subTitle is String?Container(
              margin: EdgeInsets.only(top: 12),
              child: Text(AppLocalizations.of(context).translate(subTitle, defaultText: subTitle),
                style: Theme.of(context).textTheme.headline5,
              ),
            ):subTitle:Container(),
          ],),
      ),
    );
  }
}