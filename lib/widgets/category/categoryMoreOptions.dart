import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';

class CategoryMoreOptions {
  static show(context, model, function) {
    iOSOptions(context, model, function);
  }

  static iOSOptions(context, model, function) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text("Category Options"),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          actions: <Widget>[
            /*CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(CategorySelectedOption.VIEW_HABITS, model);
              },
              child: Text("View Habits"),
            ),*/
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(CategorySelectedOption.EDIT, model);
              },
              child: Text("Edit Details"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(CategorySelectedOption.DUPLICATE_AND_EDIT, model);
              },
              child: Text("Duplicate and Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                function(CategorySelectedOption.DELETE, model);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                  color: MyColors.perfectRed,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
