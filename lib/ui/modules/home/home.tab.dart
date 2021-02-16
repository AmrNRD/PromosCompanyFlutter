import 'dart:async';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/ui/common/comments_sheets.dart';
import 'package:PromoMeCompany/ui/common/custom_appbar.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/post.card.component.dart';
import 'package:PromoMeCompany/ui/common/write_post_sheets.dart';
import 'package:PromoMeCompany/ui/common/write_something_widget.dart';
import 'package:PromoMeCompany/ui/modules/navigation/home.navigation.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';
import 'package:shimmer/shimmer.dart';


class HomeTabPage extends StatefulWidget {

  const HomeTabPage({Key key}) : super(key: key);
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  List<Post>posts=[];
  Post selectedPost;
  bool isLoading=true;
  bool isError=false;
  String errorMessage="";
  PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostBloc>(context).add(GetAllPastsEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:  CustomAppBar(
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
                onPressed: onWriteClickClick
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(onTap:onWriteClickClick,child: WriteSomethingWidget()),
              Container(
                margin: EdgeInsetsDirectional.only(top: 10),
                child: BlocListener<PostBloc, PostState>(
                  listener: (BuildContext context, PostState state) {
                    if (state is PostLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    } else if (state is PostsLoaded) {
                      setState(() {
                        posts = state.posts;
                        isLoading = false;
                      });
                    }else if (state is PostDeleted) {
                      showInSnackBar(AppLocalizations.of(context).translate("Successful"), context, _scaffoldKey,color: Colors.green);
                      BlocProvider.of<PostBloc>(context).add(GetAllPastsEvent());
                    } else if (state is PostLoaded) {
                      setState(() {
                        isLoading = false;
                        int index = posts.indexWhere(
                            (element) => element.id == state.post.id);
                        print(index);
                        if (index != -1) posts[index] = state.post;
                      });
                      if (_controller != null)
                        _controller.setState(() {
                          int index = posts.indexWhere(
                              (element) => element.id == state.post.id);
                          if (index != -1) selectedPost = state.post;
                        });
                    } else if (state is PostError) {
                      setState(() {
                        errorMessage = state.message;
                        isError = true;
                      });
                    }
                  },
                  child: isLoading
                      ? Container(
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
                        )
                      : isError ? Container(
                              alignment: Alignment.center,
                              child: GenericState(
                                size: 180,
                                margin: 8,
                                fontSize: 16,
                                removeButton: false,
                                imagePath: "assets/icons/box_icon.svg",
                                titleKey: AppLocalizations.of(context).translate("error_occurred", replacement: ""),
                                bodyKey: errorMessage,
                                onPress: () => BlocProvider.of<PostBloc>(context).add(GetAllPastsEvent()),
                                buttonKey: "reload",
                              ),
                            )
                          :posts.isNotEmpty? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DelayedAnimation(
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(bottom: index + 1 == posts.length ? 0 : 24),
                                    child: PostCardComponent(
                                      post: posts[index],
                                      onCommentsClick: () {
                                        setState(() {
                                          selectedPost = posts[index];
                                        });
                                        onCommentClick();
                                      },
                                    ),
                                  ),
                                  delay: 50 * index,
                                );
                              },
                            ):Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: GenericState(
                                  size: 40,
                                  margin: 8,
                                  fontSize: 16,
                                  removeButton: true,
                                  imagePath: "assets/icons/box_icon.svg",
                                  titleKey:
                                  AppLocalizations.of(context).translate("No posts!", defaultText: "No posts!"),
                                  bodyKey: AppLocalizations.of(context).translate("You don't have any post yet you can press add button to start add one"),
                                ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

Future onCommentClick() async {
  _controller = await _scaffoldKey.currentState.showBottomSheet(
    (builder) {
      return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: FractionallySizedBox(
                heightFactor: 0.9,
                child: CommentsSheet(selectedPost: selectedPost),
              ),
            );
          });
    },
    backgroundColor: Colors.transparent,
    elevation: 10,
  );
}
  Future onWriteClickClick() async {
    _controller = await HomeNavigationPage.scaffoldKey.currentState.showBottomSheet(
          (builder) {
        return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: FractionallySizedBox(
                  heightFactor: 0.45,
                  child:  WritePostSheet(postInserted: postInserted,),
                ),
              );
            });
      },
      backgroundColor: Colors.transparent,
      elevation: 10,
    );
  }




  postInserted() {
    BlocProvider.of<PostBloc>(context).add(GetAllPastsEvent());
  }
  @override
  void dispose() {

    super.dispose();
  }
}
