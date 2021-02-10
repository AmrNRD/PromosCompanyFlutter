import 'package:PromoMeCompany/bloc/post/post_bloc.dart';
import 'package:PromoMeCompany/data/models/post_model.dart';
import 'package:PromoMeCompany/data/models/user_model.dart';
import 'package:PromoMeCompany/data/repositories/post_repository.dart';
import 'package:PromoMeCompany/utils/app.localization.dart';
import 'package:PromoMeCompany/utils/delayed_animation.dart';
import 'package:PromoMeCompany/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import 'comment.card.component.dart';
import 'form.input.dart';
import 'loading_button.dart';

class WritePostSheet extends StatefulWidget {
  final Function postInserted;
  const WritePostSheet({Key key,@required this.postInserted}) : super(key: key);
  @override
  _WritePostSheetState createState() => _WritePostSheetState();
}

class _WritePostSheetState extends State<WritePostSheet> {
  TextEditingController _textEditingController;
  String post;
  PostBloc postBloc;
  @override
  void initState() {
    super.initState();
    _textEditingController=new TextEditingController();
    postBloc=new PostBloc(new PostDataRepository());
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context)=>postBloc,
      child: BlocListener<PostBloc,PostState>(
        listener: (context,state){
          if(state is PostLoaded)
            {
              _textEditingController.text="";
              Navigator.of(context).pop();
              widget.postInserted();
            }
        },
        child: Container(
          margin: EdgeInsetsDirectional.only(bottom: 40),
          child: Container(
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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: FormInputField(
                      title: AppLocalizations.of(context).translate("Write something here..."),
                      focusNode: new FocusNode(),
                      textEditingController: _textEditingController,
                      hint: AppLocalizations.of(context).translate("Write something here..."),
                      validator: (value)=>Validator(context).isNotEmpty(value),
                      minLine: 3,
                      maxLine: 5,
                      onSave:(value){},
                      onFieldSubmitted: (){sendComment();},
                    ),
                  ),
                  LoadingButton(title: AppLocalizations.of(context).translate("send"),onPressed: sendComment,status: 0,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  sendComment() {
    FocusScope.of(context).unfocus();
    if(_textEditingController?.text!=null && _textEditingController.text.length>1){
      postBloc.add(AddPostEvent(_textEditingController?.text));
    }
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}