import 'dart:io';
import 'package:flutter/cupertino.dart';

class HabitMoreOptions {
  static show(context, model) {
    if (Platform.isIOS) {
      iOSOptions(context, model);
    }
  }

  static iOSOptions(context, model) {
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Duplicate and Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Reset Progress"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
