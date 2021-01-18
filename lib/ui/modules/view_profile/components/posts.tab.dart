import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/post_repository.dart';
import 'package:PromoMeCompany/ui/common/comments_sheets.dart';
import 'package:PromoMeCompany/ui/common/genearic.state.component.dart';
import 'package:PromoMeCompany/ui/common/post.card.component.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

class PostsTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;

  const PostsTab({Key key,@required this.scaffoldKey,@required this.user}) : super(key: key);
  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  List<Post>posts=[];
  Post selectedPost;
  bool isLoading=false;
  bool isError=false;
  String errorMessage="";
  PersistentBottomSheetController _controller;
  PostBloc _postBloc;
  @override
  void initState() {
    super.initState();
    _postBloc=new PostBloc(new PostDataRepository());
    _postBloc..add(GetUserPastsEvent(widget.user));
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10),
      child: BlocProvider<PostBloc>(
        create: (context)=>_postBloc,
        child: BlocListener<PostBloc,PostState>(
          listener: (BuildContext context,PostState state){
            if(state is PostLoading){
              setState(() {
                isLoading=true;
              });
            }
            else if(state is PostsLoaded){
              setState(() {
                posts=state.posts;
                isLoading=false;
              });
            }else if(state is PostLoaded){
              setState(() {
                isLoading=false;
                int index=posts.indexWhere((element) => element.id==state.post.id);
                if(index!=-1)
                  posts[index]=state.post;

              });
              if(_controller!=null)
                _controller.setState((){
                  int index=posts.indexWhere((element) => element.id==state.post.id);
                  if(index!=-1)
                    selectedPost=state.post;
                });
            }else if(state is PostError){
              setState(() {
                errorMessage=state.message;
                isError=true;
              });
            }
          },
          child: isLoading?Container(margin: EdgeInsets.all(30),alignment: Alignment.center,child: SemiCircleSpinIndicator(color: Theme.of(context).accentColor)):
          isError?Container(
            alignment: Alignment.center,
            child: GenericState(
              size: 180,
              margin: 8,
              fontSize: 16,
              removeButton: false,
              imagePath: "assets/icons/sad.svg",
              titleKey: AppLocalizations.of(context).translate("error_occurred",replacement: ""),
              bodyKey: errorMessage,
              onPress: ()=>_postBloc.add(GetUserPastsEvent(widget.user)),
              buttonKey: "reload",
            ),
          ):posts.isEmpty?Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: GenericState(
              size: 40,
              margin: 8,
              fontSize: 16,
              removeButton: true,
              imagePath: "assets/icons/box_icon.svg",
              titleKey: AppLocalizations.of(context).translate("No posts"),
              bodyKey: AppLocalizations.of(context).translate("Sorry no available post"),
            ),
          ):ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return DelayedAnimation(
                child: Container(
                  margin: EdgeInsetsDirectional.only(bottom: index + 1 == posts.length ? 0 : 24),
                  child: PostCardComponent(post: posts[index],
                    onCommentsClick: (){
                    setState(() {
                      selectedPost=posts[index];
                    });
                    onCommentClick();
                  },),
                ),
                delay: 150*index,
              );
            },
          ),
        ),
      ),
    );
  }
  Future onCommentClick() async {
    _controller = await widget.scaffoldKey.currentState.showBottomSheet(
          (builder) {
        return StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: FractionallySizedBox(
                  heightFactor: 0.9,
                  child: CommentsSheet(selectedPost: selectedPost,profileUser: widget.user,),
                ),
              );
            });
      },
      backgroundColor: Colors.transparent,
      elevation: 10,
    );
  }

}
