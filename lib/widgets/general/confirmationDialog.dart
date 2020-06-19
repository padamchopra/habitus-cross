import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function positiveCallback;
  final Function otherCallback;
  final String positiveLabel;
  final String otherLabel;
  final bool otherIsNegative;
  final bool positiveIsNegative;
  const ConfirmationDialog(
    this.title,
    this.description,
    this.positiveCallback,
    this.otherCallback,
    this.positiveLabel,
    this.otherLabel,
    this.otherIsNegative,
    this.positiveIsNegative,
  );

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
          otherCallback != null
              ? CupertinoDialogAction(
                  isDefaultAction: false,
                  child: CustomText(
                    otherLabel != null ? otherLabel : "Cancel",
                    color: otherIsNegative
                        ? MyColors.perfectRed
                        : MyColors.alertBlue,
                    textAlign: TextAlign.center,
                    fontSize: 17,
                  ),
                  onPressed: () {
                    otherCallback();
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: CustomText(
              positiveLabel,
              color:
                  positiveIsNegative ? MyColors.perfectRed : MyColors.alertBlue,
              textAlign: TextAlign.center,
              fontSize: 17,
            ),
            onPressed: () {
              positiveCallback();
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
          otherCallback != null
              ? FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomText(
                      otherLabel != null ? otherLabel : "Cancel",
                      color: MyColors.alertBlue,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    otherCallback();
                    Navigator.of(context).pop();
                  },
                )
              : Container(),
          FlatButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomText(
                positiveLabel,
                color: MyColors.alertBlue,
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              positiveCallback();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}
