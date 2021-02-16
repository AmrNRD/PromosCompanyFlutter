import 'dart:async';
import 'dart:ui';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/bloc/store/store_bloc.dart';
import 'package:PromoMeCompany/data/models/sale_item.dart';
import 'package:PromoMeCompany/data/repositories/store_repository.dart';
import 'package:PromoMeCompany/ui/modules/sidemenu/components/side.menu.button.dart';
import 'package:PromoMeCompany/ui/style/theme.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/dots_indicator.dart';
import 'package:PromoMeCompany/utils/sizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../env.dart';

class SaleItemDetailsPage extends StatefulWidget {
  final SaleItem saleItem;
  const SaleItemDetailsPage({Key key,@required this.saleItem}) : super(key: key);

  @override
  _SaleItemDetailsPageState createState() => _SaleItemDetailsPageState();
}

class _SaleItemDetailsPageState extends State<SaleItemDetailsPage> {

  bool allowBlocStateUpdates = false;
  void allowBlocUpdates(bool allow) => setState(() => allowBlocStateUpdates = allow);
  StoreBloc storeBloc;
  SaleItem saleItem;
  @override
  void initState() {
    super.initState();
    saleItem=widget.saleItem;
    storeBloc=new StoreBloc(new StoreDataRepository());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onPop(),
      child: Scaffold(
          body: BlocProvider<StoreBloc>(
            create: (context)=>storeBloc,
            child: BlocListener<StoreBloc,StoreState>(
              listener: (context,state){
                if(state is SaleItemLoaded){
                  setState(() {
                    saleItem=state.saleItem;
                  });
                }
              },
              child: Listener(
                onPointerMove: (details) => allowBlocUpdates(true),
                onPointerUp: (details) => allowBlocUpdates(true),
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      DetailsHeader(
                        allowBlocStateUpdates: allowBlocStateUpdates,
                        innerBoxIsScrolled: innerBoxIsScrolled,
                        saleItem: saleItem,
                        bloc: storeBloc,
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: DetailsHeaderHolder(
                          child: Container()
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    color: Theme.of(context).cardColor,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        margin: EdgeInsetsDirectional.only(top: 0.120 * SizeConfig.screenWidth + 4.50 * SizeConfig.widthMultiplier),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40),
                            Text(
                              saleItem.title,
                              style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 24),
                            ),
                            SideMenuButton(icon:"assets/icons/price_tag.svg",title: "currency",subTitle: "",onTap: null,replacement: saleItem.price.toString()),
                            Divider(thickness: 1),
                            saleItem?.cities!=null&&saleItem.cities.length>0?SideMenuButton(icon:"assets/icons/lang_icon.svg",title: saleItem.cities.join(" , "),subTitle: "",onTap: null):Container(),
                            saleItem?.cities!=null&&saleItem.cities.length>0?Divider(thickness: 1):Container(),
                            saleItem?.genders!=null&&saleItem.genders.length>0?SideMenuButton(icon:"assets/icons/profile_icon.svg",title: saleItem.genders.join(" , "),subTitle: "",onTap: null):Container(),
                            saleItem?.genders!=null&&saleItem.genders.length>0?Divider(thickness: 1):Container(),
                            SideMenuButton(icon:"assets/icons/lang_icon.svg",title: Text(AppLocalizations.of(context).translate(saleItem.status, replacement: saleItem.price.toString()), softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2.copyWith(color:AppTheme.activeColor(saleItem.status)),),subTitle: "",onTap: null,replacement: saleItem.price.toString()),
                            Divider(thickness: 1),
                            saleItem?.description!=null?SideMenuButton(icon:"assets/icons/category_icon.svg",title: saleItem.description,subTitle: "",onTap: null):Container(),

                          ],
                        ),
                      ),
                    ),
                  ),

                  // ************************** ************************** ************************** **************************
                ),
              ),
            ),
          )

        /*PropertyDetailsAppBar(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PropertyOverViewComponent(),
          ),
        ),*/
      ),
    );
  }

  onPop() async{
     Navigator.of(context).pop(saleItem);
  }

}


class DetailsHeaderHolder extends SliverPersistentHeaderDelegate {
  final Widget child;

  const DetailsHeaderHolder({
    this.child
  });

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 0.10 * SizeConfig.widthMultiplier;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: child);
  }

  @override
  bool shouldRebuild(DetailsHeaderHolder oldDelegate) => false;
}


class DetailsHeader extends StatefulWidget {
  final bool allowBlocStateUpdates;
  final bool innerBoxIsScrolled;
  final SaleItem saleItem;
  final StoreBloc bloc;
  const DetailsHeader({
    Key key,
    this.allowBlocStateUpdates,
    this.innerBoxIsScrolled,
    this.bloc,
    @required this.saleItem,
  }) : super(key: key);

  @override
  _FlexibleHeaderState createState() => _FlexibleHeaderState();
}

class _FlexibleHeaderState extends State<DetailsHeader> {
  FlexibleHeaderBloc bloc;
  final _pageViewController = new PageController();

  @override
  void initState() {
    bloc = FlexibleHeaderBloc();

    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: bloc.initial(),
      stream: bloc.stream,
      builder:(BuildContext context, AsyncSnapshot<DetailsHeaderState> stream) {
        DetailsHeaderState state = stream.data;

        return SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            pinned: true,
            primary: true,
            forceElevated: widget.innerBoxIsScrolled,
            expandedHeight: SizeConfig.screenHeight * 0.50,
            backgroundColor: Theme.of(context).cardColor,
            centerTitle: true,
            title: Opacity(
              opacity: state.opacityAppBar,
              child: Text(
                AppLocalizations.of(context).translate("sale_item_details"),
                maxLines: 1,
                style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 20,fontWeight: FontWeight.w700),
              ),
            ),
            actions: [
              widget.saleItem.status!="done"?Container(
                padding: EdgeInsets.all(20),
                child: PopupMenuButton(
                  elevation: 3.2,
                  onCanceled: () {
                  },
                  tooltip: 'details',
                  onSelected: (value){
                    if(value=="disable")
                      widget.bloc.add(widget.saleItem.status=="active"?DisableSaleItemsEvent(widget.saleItem):EnableSaleItemsEvent(widget.saleItem));
                  },
                  child: Icon(FontAwesomeIcons.ellipsisV),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: "disable",
                        child: Text(widget.saleItem.status=="active"?AppLocalizations.of(context).translate("disable",defaultText: "disable"):AppLocalizations.of(context).translate("enable"),style: Theme.of(context).textTheme.bodyText1,),
                      )];
                  },
                ),
              ):Container()
            ],
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context,widget.saleItem);
                },
                child: Icon(Icons.arrow_back)),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (widget.allowBlocStateUpdates) {
                  bloc.update(state, constraints.maxHeight);
                }
                return Opacity(
                  opacity: state.opacityFlexible < 0.05
                      ? 0.0
                      : state.opacityFlexible,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background:  Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsetsDirectional.only(bottom: 25),
                          child: Stack(
                            children: [
                              PageView.builder(
                                pageSnapping: true,
                                controller: _pageViewController,
                                itemCount: widget.saleItem.images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CachedNetworkImage(
                                    imageUrl:widget.saleItem.images[index],
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ScrollingPageIndicator(
                                  dotColor: Colors.white.withOpacity(0.6),
                                  dotSize: 7,
                                  dotSelectedSize: 12,
                                  dotSpacing: 12,
                                  controller: _pageViewController,
                                  itemCount: widget.saleItem.images.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsetsDirectional.only(
                            start: 2.5 * SizeConfig.widthMultiplier,
                            end: 2.5 * SizeConfig.widthMultiplier,
                          ),
                          child: Opacity(
                            opacity: state.opacityFlexible < 0.05 ? 0.0 : state.opacityFlexible,
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 20,
                                          offset: Offset(0, 4),
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                    height: 90,
                                    width: 90,
                                    child:  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.saleItem.user.image??Env.dummyProfilePic,
                                        fit: BoxFit.fill,
                                        height: 90,
                                        width: 90,
                                        errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: Env.dummyProfilePic),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class FlexibleHeaderBloc {
  StreamController<DetailsHeaderState> controller =
  StreamController<DetailsHeaderState>();

  Stream<DetailsHeaderState> get stream => controller.stream;

  Sink get sink => controller.sink;

  void _update(DetailsHeaderState state) => sink.add(state);

  FlexibleHeaderBloc();

  DetailsHeaderState initial() => DetailsHeaderState();

  void _updateOpacity(DetailsHeaderState state) {
    if (state.initialHeight == null || state.currentHeight == null) {
      state.opacityFlexible = 1;
      state.opacityAppBar = 0;
    } else {
      final double offset = (1 / 3) * state.initialHeight;
      double opacity =
          (state.currentHeight - offset) / (state.initialHeight - offset);

      opacity <= 1 ? opacity = opacity : opacity = 1;
      opacity >= 0 ? opacity = opacity : opacity = 0;

      state.opacityFlexible = opacity;
      state.opacityAppBar = (1 - opacity).abs();
    }
  }

  void update(DetailsHeaderState state, double currentHeight) {
    state.initialHeight ??= currentHeight;
    state.currentHeight = currentHeight;

    _updateOpacity(state);
    _update(state);
  }

  void dispose() {
    controller.close();
  }
}


class DetailsHeaderState {
  double initialHeight;
  double currentHeight;

  double opacityFlexible = 1;
  double opacityAppBar = 0;

  DetailsHeaderState();
}