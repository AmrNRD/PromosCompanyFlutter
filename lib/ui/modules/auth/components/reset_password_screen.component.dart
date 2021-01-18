import 'package:PromoMeCompany/ui/common/custom_raised_button.dart';
import 'package:PromoMeCompany/ui/common/form.input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app.localization.dart';
import '../../../../utils/core.util.dart';
import '../../../style/app.dimens.dart';

class RestPasswordScreen extends StatefulWidget {
  final Function goToLogin;

  const RestPasswordScreen({Key key,@required this.goToLogin}) : super(key: key);
  @override
  _RestPasswordScreenState createState() => _RestPasswordScreenState();
}

class _RestPasswordScreenState extends State<RestPasswordScreen> {
  bool isLoading = false;


  final GlobalKey<FormState> _formKey = GlobalKey();

  FocusNode _emailFocusNode;

  Map<String, String> _authData = {'email': ''};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.marginEdgeCase24),
        margin: EdgeInsets.only(top: AppDimens.paddingEdgeCase40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 138),
                child: Hero(tag: "Logo", child: Image.asset("assets/images/logo.png",height: screenAwareSize(100, context),width: screenAwareWidth(100, context))),
              ),

              SizedBox(height: AppDimens.marginDefault12),
              Text(AppLocalizations.of(context).translate("Forgot Password"), style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),


              SizedBox(height: AppDimens.marginEdgeCase24),

              //email
              FormInputField(title: "email", focusNode: _emailFocusNode, onSave: (value) => _authData['email'] = value, isRequired: true),


              CustomRaisedButton(label: AppLocalizations.of(context).translate("send"), onPress: onReset, isLoading: isLoading),
              SizedBox(height: 140),

              FlatButton(onPressed: widget.goToLogin, child: Text(AppLocalizations.of(context).translate("back_to_login"), style: Theme.of(context).textTheme.subtitle1)),

            ],
          ),
        ),
      ),
    );
  }

  void onReset() {

  }


}
