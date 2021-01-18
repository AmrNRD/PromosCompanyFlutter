import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/env.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Env.saleItemPage,arguments: saleItem);
        },
        child: Stack(
          children: [
            //image stack
            Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(width: 4),
                            Text(
                              saleItem.user.name,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(width: 4),

                          ],
                        ),
                        SizedBox(height: 7),
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
                        saleItem.user?.address!=null?Row(
                          children: [
                            SizedBox(height: 12, width: 12, child: SvgPicture.asset('assets/icons/location_icon.svg')),
                            SizedBox(width: 7),
                            Text(
                              saleItem.user?.address??"",
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.grey),
                            ),
                          ],
                        ):Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 140,
              end:20,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
                child: Container(
                  height: 56,
                  width: 56,
                  padding: EdgeInsets.all(14),
                  child:  CachedNetworkImage(
                    imageUrl: saleItem.user.image??Env.dummyProfilePic,
                    fit: BoxFit.fill,
                    height: 56,
                    width: 56,
                    errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
