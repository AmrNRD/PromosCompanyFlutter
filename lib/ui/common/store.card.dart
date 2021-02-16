import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/env.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class SaleItemCard extends StatelessWidget {
  final SaleItem saleItem;

  const SaleItemCard({Key key, @required this.saleItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Container(
      margin: EdgeInsetsDirectional.only(top: 10, bottom: 24),
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 160,
              child:CachedNetworkImage(
                imageUrl: saleItem.images.length>0?saleItem.images[0]:Env.dummyProfilePic,
                fit: BoxFit.cover,
                height: 66,
                errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    saleItem.title,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).translate("currency", replacement: saleItem.price.toString()),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 7),
                  Text(
                    AppLocalizations.of(context).translate(saleItem.status, replacement: saleItem.price.toString()),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2.copyWith(color:AppTheme.activeColor(saleItem.status)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
