import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/store.card.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';


class SalesTab extends StatefulWidget {
  final User user;

  const SalesTab({Key key,@required this.user}) : super(key: key);
  @override
  _SalesTabState createState() => _SalesTabState();
}

class _SalesTabState extends State<SalesTab> {

  StoreBloc _storeBloc;
  @override
  void initState() {
    super.initState();
    _storeBloc=new StoreBloc(new StoreDataRepository());
    _storeBloc.add(GetUserSaleItemsEvent(widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10),
      child: BlocProvider<StoreBloc>(
        create: (context)=>_storeBloc,
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is SaleItemLoading) {
              return Container(margin: EdgeInsets.all(30), alignment: Alignment.center, child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor));
            } else if (state is SaleItemsLoaded) {
              if (state.saleItems.isEmpty) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: GenericState(
                    size: 40,
                    margin: 8,
                    fontSize: 16,
                    removeButton: true,
                    imagePath: "assets/icons/box_icon.svg",
                    titleKey: AppLocalizations.of(context).translate("No sale items!", defaultText: "No sale items!"),
                    bodyKey: AppLocalizations.of(context).translate("Sorry no sale item were available in your area, please check later", defaultText: "Sorry no sale item were available in your area, please check later"),
                  ),
                );
              } else
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: state.saleItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return DelayedAnimation(
                        child: SaleItemCard(saleItem: state.saleItems[index]),
                        delay: 200 * (index + 1),
                      );
                    },
                  ),
                );
            } else if (state is SaleItemError) {
              return Container(
                alignment: Alignment.center,
                child: GenericState(
                  size: 180,
                  margin: 8,
                  fontSize: 16,
                  removeButton: false,
                  imagePath: "assets/icons/box_icon.svg",
                  titleKey: AppLocalizations.of(context).translate("error_occurred", replacement: ""),
                  bodyKey: state.message,
                  onPress: () =>_storeBloc.add(GetUserSaleItemsEvent(widget.user)),
                  buttonKey: "reload",
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

}
