import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/habitFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';

class HabitMoreOptions {
  static show(context, model, habit, category) {
    iOSOptions(context, model, habit, category);
  }

  static iOSOptions(context, model, habit, category) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext _context) {
        return CupertinoActionSheet(
          title: Text("More Options"),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(_context).pop(),
            child: Text('Cancel'),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(_context).pop();
                HabitFunctions.handleHabitOptionSelect(
                  context, 
                  model,
                  HabitSelecetedOption.DUPLICATE_AND_EDIT,
                  habit,
                  category,
                );
              },
              child: Text("Duplicate and Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(_context).pop();
                HabitFunctions.handleHabitOptionSelect(
                  context, 
                  model,
                  HabitSelecetedOption.RESET_PROGRESS,
                  habit,
                  category,
                );
              },
              child: Text("Reset Progress"),
            ),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(_context).pop();
                  HabitFunctions.handleHabitOptionSelect(
                    context, 
                    model,
                    HabitSelecetedOption.DELETE,
                    habit,
                    category,
                  );
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: MyColors.perfectRed,
                  ),
                )),
          ],
        );
      },
    );
  }
}
