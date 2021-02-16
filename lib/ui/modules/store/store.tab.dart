import 'dart:async';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/ui/common/custom_appbar.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/store.card.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/constants.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../env.dart';


class StoreTab extends StatefulWidget {
  @override
  _StoreTabState createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StoreBloc>(context).add(GetAllSaleItemsEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:CustomAppBar(
          actionButtons: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Color(0xFFF0483D),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.plus),
                    SizedBox(width: 2),
                    Text(
                      AppLocalizations.of(context).translate("add"),
                      style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                onPressed:addClick,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  child:BlocBuilder<StoreBloc,StoreState>(
                    builder: (context,state){
                      if(state is SaleItemLoading){
                        return Container(
                          margin: EdgeInsets.all(30),
                          alignment: Alignment.center,
                          child: Shimmer.fromColors(
                            baseColor: AppColors.primaryColor,
                            highlightColor: AppColors.white,
                            child: Image.asset(
                              "assets/images/logo2.png",
                              height: screenAwareSize(70, context),
                              width: screenAwareWidth(70, context),
                            ),
                          ),
                        );
                      } else if(state is SaleItemsLoaded){
                        if (state.saleItems.isEmpty) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: GenericState(
                              size: 40,
                              margin: 8,
                              fontSize: 16,
                              removeButton: true,
                              imagePath: "assets/icons/box_icon.svg",
                              titleKey:
                              AppLocalizations.of(context).translate("No sale items!", defaultText: "No sale items!"),
                              bodyKey: AppLocalizations.of(context).translate(
                                "Sorry no sale item were available in your area, please check later",
                                defaultText: "Sorry no sale item were available in your area, please check later",
                              ),
                            ),
                          );
                          return Container();
                        }else
                      return  Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: state.saleItems.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio:0.58,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return DelayedAnimation(
                                child: GestureDetector(
                                    onTap: () async {
                                      var res =await Navigator.of(context).pushNamed(Env.saleItemPage,arguments: state.saleItems[index]);
                                      if(res is SaleItem)
                                        setState(() {
                                          state.saleItems[index]=res;
                                        });
                                    },
                                    child: SaleItemCard(saleItem: state.saleItems[index])),
                                delay: 50 * index,
                              );
                            },
                          ),
                      );
                      }else if(state is SaleItemError){
                        return Container(
                          alignment: Alignment.center,
                          child: GenericState(
                            size: 180,
                            margin: 8,
                            fontSize: 16,
                            removeButton: false,
                            imagePath: "assets/icons/box_icon.svg",
                            titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
                            bodyKey: state.message,
                            onPress: ()=>BlocProvider.of<StoreBloc>(context).add(GetAllSaleItemsEvent()),
                            buttonKey: "reload",
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }






  Future<void> addClick() async {
    await Navigator.pushNamed(context, Env.addSaleItemPage);
    BlocProvider.of<StoreBloc>(context).add(GetAllSaleItemsEvent());
  }
}
