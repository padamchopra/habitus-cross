import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class AlertNotifyDialog extends StatelessWidget {
  final String title;
  final String description;
  const AlertNotifyDialog(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: CustomText(
          title,
          color: MyColors.black,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: CustomText(
            description,
            color: MyColors.black,
            textAlign: TextAlign.center,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: CustomText(
              'OK',
              color: MyColors.alertBlue,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: CustomText(
          title,
          color: MyColors.black,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        content: CustomText(
          description,
          color: MyColors.black,
          textAlign: TextAlign.center,
          fontSize: 20,
        ),
        actions: <Widget>[
          FlatButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                'OK',
                color: MyColors.alertBlue,
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}
