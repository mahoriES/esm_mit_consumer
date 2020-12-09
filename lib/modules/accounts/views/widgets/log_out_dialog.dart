import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// only moved out this component from main view file for now.
// changes will be done as per new design when available.

class LogOutDialog extends StatelessWidget {
  final VoidCallback successAction;
  const LogOutDialog(this.successAction, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("E-samudaay"),
      content: Text(
        'screen_account.alert_data',
        style: const TextStyle(
            color: const Color(0xff6f6d6d),
            fontWeight: FontWeight.w400,
            fontFamily: "Avenir-Medium",
            fontStyle: FontStyle.normal,
            fontSize: 16.0),
      ).tr(),
      actions: <Widget>[
        FlatButton(
          child: Text(
            tr('screen_account.cancel'),
            style: const TextStyle(
                color: const Color(0xff6f6d6d),
                fontWeight: FontWeight.w400,
                fontFamily: "Avenir-Medium",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            tr('screen_account.logout'.toLowerCase()),
            style: const TextStyle(
                color: const Color(0xff6f6d6d),
                fontWeight: FontWeight.w400,
                fontFamily: "Avenir-Medium",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
          onPressed: successAction,
        )
      ],
    );
  }
}
