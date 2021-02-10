import 'package:flutter/material.dart';

import '../../utils/app.localization.dart';
import '../style/app.dimens.dart';

class FormInputField extends StatefulWidget {
  final String title;
  final String hint;
  final TextInputType textInputType;
  final Function onSave;
  final Function validator;
  final Function onFieldSubmitted;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isRequired;
  final TextInputAction textInputAction;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool obscureText;
  final int minLine;
  final int maxLine;
  final bool outterBorder;
  final bool useLabel;

  const FormInputField(
      {Key key,
      @required this.title,
      this.hint,
      this.textInputType,
      @required this.onSave,
      this.validator,
      this.textEditingController,
      @required this.focusNode,
      this.nextFocusNode,
      this.textInputAction,
      this.isRequired = false,
      this.obscureText=false,
      this.outterBorder=false,
      this.useLabel=false,
      this.prefixIcon,
      this.suffixIcon,
        this.minLine=1,
        this.maxLine=1, this.onFieldSubmitted})
      : super(key: key);

  @override
  _FormInputFieldState createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.symmetric(vertical: AppDimens.marginDefault12),
      child: TextFormField(
        key: Key(widget.title),
        focusNode: widget.focusNode,
        controller: widget.textEditingController,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType != null ? widget.textInputType : TextInputType.text,
        validator: widget.validator ?? (value) {
              if (widget.isRequired) {
                if (value.isEmpty) {
                  return AppLocalizations.of(context).translate('invalid_value');
                }
                return null;
              } else
                return null;
            },
        onSaved: widget.onSave,
        style: Theme.of(context).textTheme.headline3,
        minLines: widget.minLine,
        maxLines: widget.maxLine,
        textInputAction: widget.nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onEditingComplete: () {
          widget.focusNode.unfocus();
        },
        onFieldSubmitted: (term) {
          widget.focusNode.unfocus();
          if(widget.onFieldSubmitted!=null)
            widget.onFieldSubmitted();
          else if (widget.nextFocusNode != null)
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
        },
        decoration: InputDecoration(
          icon: widget.prefixIcon,
          border: widget.outterBorder?OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),borderSide:BorderSide(color: Theme.of(context).textTheme.headline3.color) ):OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder:  widget.outterBorder?OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),borderSide:BorderSide(color: Theme.of(context).accentColor)):OutlineInputBorder(borderSide: BorderSide.none),
          fillColor:Theme.of(context).cardColor,
          filled: true,
          hintText: AppLocalizations.of(context).translate(widget.hint??widget.title,defaultText: widget.hint??widget.title),
          labelText: widget.useLabel?AppLocalizations.of(context).translate(widget.title,defaultText: widget.title):null,
          suffixIcon:widget.suffixIcon,
        ),
      ),
    );
  }
}
