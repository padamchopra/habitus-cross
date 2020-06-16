import 'package:flutter/material.dart';
import 'package:habito/functions/homeFunctions.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/general/lightIconButton.dart';

class AddNewModal extends StatelessWidget {
  AddNewModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 0),
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(42),
          topRight: Radius.circular(42),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LightIconButton(
                Icons.lightbulb_outline,
                "Habit",
                () => HomeFunctions.addNewHabit(context),
              ),
              LightIconButton(
                Icons.label_outline,
                "Category",
                () => HomeFunctions.addNewCategory(context),
              ),
              LightIconButton(
                Icons.import_export,
                "Export",
                () => HomeFunctions.addNewExport(context),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: MyColors.perfectBlue,
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: MyColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
