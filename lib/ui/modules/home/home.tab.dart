import 'dart:async';

import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/ui/common/comment.card.component.dart';
import 'package:PromoMeCompany/ui/common/comments_sheets.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/post.card.component.dart';
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
import 'package:qr_flutter/qr_flutter.dart';


class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {

  List<Post>posts=[];
  Post selectedPost;
  bool isLoading=false;
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
      backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                child: Text(AppLocalizations.of(context).translate("home"),style: Theme.of(context).textTheme.headline1,),
              ),
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
                    } else if (state is PostLoaded) {
                      setState(() {
                        print(state.post.id);
                        print(state.post.content);
                        print(state.post.likedByMe);
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
                          child: SemiCircleSpinIndicator(
                              color: Theme.of(context).accentColor))
                      : isError
                          ? Container(
                              alignment: Alignment.center,
                              child: GenericState(
                                size: 180,
                                margin: 8,
                                fontSize: 16,
                                removeButton: false,
                                imagePath: "assets/icons/sad.svg",
                                titleKey: AppLocalizations.of(context)
                                    .translate("error_occurred",
                                        replacement: ""),
                                bodyKey: errorMessage,
                                onPress: () =>
                                    BlocProvider.of<PostBloc>(context)
                                        .add(GetAllPastsEvent()),
                                buttonKey: "reload",
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DelayedAnimation(
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                        bottom:
                                            index + 1 == posts.length ? 0 : 24),
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
                                  delay: 150 * index,
                                );
                              },
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



}
