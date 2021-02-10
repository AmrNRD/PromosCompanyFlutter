import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/comment_model.dart';
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
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../env.dart';
import '../../main.dart';
import 'form.input.dart';

class CommentCardComponent extends StatelessWidget {
  final Comment comment;
  final bool insideTheProfile;

  const CommentCardComponent({Key key,@required this.comment, this.insideTheProfile=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          width: 56,
          margin: EdgeInsetsDirectional.only(start:16,end: 8),
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
            border: Border.all(width: comment?.user?.id==Root?.user?.id?2:1, color: comment?.user?.id==Root?.user?.id?Theme.of(context).accentColor:Colors.white),
          ),
          child: InkWell(
            onTap: insideTheProfile?null:()=>Navigator.of(context).pushNamed(Env.profilePage,arguments: comment.user),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: ImageProcessor.image(
                url: comment?.user?.image??"",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
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
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: Text(
                  comment?.user?.name??"",
                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                comment?.body??"",
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),

      ],
    );
  }

}
