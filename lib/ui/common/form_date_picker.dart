import 'package:PromoMeCompany/ui/style/app.colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormDatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final Function onDateTimeChanged;
  final bool use24hFormat;
  final CupertinoDatePickerMode mode;

  const FormDatePicker({Key key, this.initialDateTime, this.minimumDate,@required this.onDateTimeChanged, this.use24hFormat=false, this.mode=CupertinoDatePickerMode.dateAndTime, this.maximumDate}) : super(key: key);
  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            //----------------------------Top dismiss button----------------------------
            Container(
              child: FlatButton(
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.headline2.copyWith(color: AppColors.accentColor1),
                ),
                onPressed: () =>Navigator.pop(context),
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
            ),
            //----------------------------Date Picker----------------------------
            Container(
              child: CupertinoDatePicker(
                initialDateTime: widget.initialDateTime,
                minimumDate: widget.minimumDate,
                onDateTimeChanged: widget.onDateTimeChanged,
                use24hFormat: widget.use24hFormat,
                backgroundColor: Theme.of(context).cardColor,
                maximumDate: widget.maximumDate,
                mode: widget.mode,
              ),
              height: (MediaQuery.of(context).copyWith().size.height / 3) - 60,
            ),
          ],
        ));
  }
}
