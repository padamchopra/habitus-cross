import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/categoryFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';

class CategoryMoreOptions {
  static show(context, model, category) {
    iOSOptions(context, model, category);
  }

  static iOSOptions(context, model, category) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext optionsContext) {
        return CupertinoActionSheet(
          title: Text("Category Options"),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(optionsContext).pop(),
            child: Text('Cancel'),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () => CategoryFunctions.handleCategoryOptionSelect(
                optionsContext: optionsContext,
                screenContext: context,
                option: CategorySelectedOption.EDIT,
                category: category,
              ),
              child: Text("Edit Details"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => CategoryFunctions.handleCategoryOptionSelect(
                optionsContext: optionsContext,
                screenContext: context,
                option: CategorySelectedOption.DUPLICATE_AND_EDIT,
                category: category,
              ),
              child: Text("Duplicate and Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => CategoryFunctions.handleCategoryOptionSelect(
                optionsContext: optionsContext,
                screenContext: context,
                option: CategorySelectedOption.DELETE,
                model: model,
                category: category,
              ),
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
