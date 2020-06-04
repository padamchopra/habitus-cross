import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';

class HabitMoreOptions {
  static show(context, model, function) {
    iOSOptions(context, model, function);
  }

  static iOSOptions(context, model, function) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("More Options"),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(HabitSelecetedOption.DUPLICATE_AND_EDIT, model);
              },
              child: Text("Duplicate and Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(HabitSelecetedOption.RESET_PROGRESS, model);
              },
              child: Text("Reset Progress"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(HabitSelecetedOption.DELETE, model);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: MyColors.perfectRed,
                ),
              )
            ),
          ],
        );
      },
    );
  }
}
