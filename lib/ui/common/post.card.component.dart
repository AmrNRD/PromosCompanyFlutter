import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/constants.dart';
import 'package:PromoMeCompany/utils/core.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../env.dart';
import '../../main.dart';
import 'form.input.dart';

class PostCardComponent extends StatelessWidget {
  final Post post;
  final Function onCommentsClick;
  final bool insideTheProfile;

  const PostCardComponent({Key key,@required this.post,@required this.onCommentsClick, this.insideTheProfile=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      margin: EdgeInsetsDirectional.only(end: 16),
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1, 1),
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: ImageProcessor.image(
                          url: post.user.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    post.user.name,
                                    style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 24),
                                  child: Text(
                                      post.lastUpdate!=null?DateFormat('h:mm a dd-MM-yyyy',Root.locale.toString()).format(post.lastUpdate):"",
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: PopupMenuButton(
                  elevation: 3.2,
                  onCanceled: () {
                  },
                  tooltip: 'This is tooltip',
                  onSelected: (value){
                    if(value=="delete")
                      BlocProvider.of<PostBloc>(context).add(DeletePostEvent(post));
                  },
                  child: Icon(FontAwesomeIcons.angleDown),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                      value: "delete",
                      child: Text(AppLocalizations.of(context).translate("delete",defaultText: "delete"),style: Theme.of(context).textTheme.bodyText1,),
                    )];
                  },
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.only(start: 50,end: 20),
            child: Text(
              post.content,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 20),
          post.likesCount>0?Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Text(
              AppLocalizations.of(context).translate('likes',replacement: post.likesCount.toString()),
              style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
            ),
          ):Container(),
          Divider(color: Colors.grey.withOpacity(0.6)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap:(){
                    BlocProvider.of<PostBloc>(context).add(LikeOrDislikePostEvent(post));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        post.likedByMe?Icon(FontAwesomeIcons.solidHeart,color: Theme.of(context).accentColor):Icon(FontAwesomeIcons.heart,color: Colors.grey),
                        SizedBox(width: 10.0),
                        Text(AppLocalizations.of(context).translate('like'), style: Theme.of(context).textTheme.headline2.copyWith(color: post.likedByMe?Theme.of(context).accentColor:Theme.of(context).textTheme.headline3.color),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:onCommentsClick,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.comments,color: Colors.grey),
                        SizedBox(width: 10.0),
                        Text(
                          AppLocalizations.of(context).translate('comment'),
                          style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.grey),

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}
