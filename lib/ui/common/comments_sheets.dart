import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import 'comment.card.component.dart';
import 'form.input.dart';

class CommentsSheet extends StatefulWidget {
  final Post selectedPost;
  final User profileUser;

  const CommentsSheet({Key key,@required this.selectedPost, this.profileUser}) : super(key: key);
  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController=new TextEditingController();
    print(Root.user.id);
    print(widget.selectedPost.comments[1].user.id);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<PostBloc>(context).add(
                            LikeOrDislikePostEvent(widget.selectedPost));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.selectedPost.likedByMe ? Icon(FontAwesomeIcons.solidHeart, color: Theme.of(context).accentColor) : Icon(FontAwesomeIcons.heart, color: Colors.grey),
                            SizedBox(width: 10.0),
                            Text(
                              AppLocalizations.of(context).translate('like'),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: widget.selectedPost.likedByMe ? Theme.of(context).accentColor : Theme.of(context).textTheme.headline3.color),),
                          ],
                        ),
                      ),
                    ),
                    widget.selectedPost.likesCount > 0 ? Text(
                      AppLocalizations.of(context).translate('likes', replacement: widget.selectedPost.likesCount.toString()),
                      style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                    ) : Container(),
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey.withOpacity(0.6)),
              ],
            ),
          )),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child:ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: widget.selectedPost.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return DelayedAnimation(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(bottom: index + 1 == widget.selectedPost.comments.length ? 0 : 24),
                      child: CommentCardComponent(comment: widget.selectedPost.comments[index],insideTheProfile:(widget.profileUser!=null&&widget.profileUser.id==widget.selectedPost.comments[index].user.id)||Root?.user?.id==widget.selectedPost?.comments[index].user.id),
                    ),
                    delay: 150*index,
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              Divider(color: Colors.grey.withOpacity(0.6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 5,
                    child: FormInputField(
                      title: "comment",
                      focusNode: new FocusNode(),
                      textEditingController: _textEditingController,
                      hint: AppLocalizations.of(context).translate("write_comment"),
                      onSave: (value){

                      },
                    ),
                  ),
                  Expanded(flex: 1,
                      child: GestureDetector(
                        onTap: sendComment,
                        child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.send)
                        ),

                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  sendComment() {
    FocusScope.of(context).unfocus();
    if(_textEditingController?.text!=null && _textEditingController.text.length>1){
      BlocProvider.of<PostBloc>(context).add(SendCommentPostEvent(widget.selectedPost,_textEditingController.text));
      _textEditingController.text="";
    }
  }
}