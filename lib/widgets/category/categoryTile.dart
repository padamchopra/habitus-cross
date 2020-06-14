import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class CategoryTile extends StatelessWidget {
  final bool showNumberOfHabits;
  final int numberOfHabits;
  final IconData icon;
  final int color;
  final String name;
  final bool overridePadding;
  CategoryTile(this.showNumberOfHabits, this.numberOfHabits, this.icon,
      this.color, this.name, this.overridePadding);

  @override
  Widget build(BuildContext context) {
    Widget onTheRight = Container();
    double _rightPadding = 0;
    if (showNumberOfHabits) {
      onTheRight = Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 36,
            height: 36,
            child: Align(
              alignment: Alignment.center,
              child: CustomText(
                numberOfHabits.toString(),
                fontSize: 18,
              ),
            ),
            decoration: BoxDecoration(
              color: MyColors.labelBackground,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: overridePadding
          ? const EdgeInsets.all(0)
          : EdgeInsets.fromLTRB(25, 18, 25, 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: MyColors.midnight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: MyColors.standardColorsList[color],
              size: 30,
            ),
            SizedBox(
              width: 9,
            ),
            Padding(
              padding: EdgeInsets.only(right: _rightPadding),
              child: CustomText(
                name,
                fontSize: 21,
                letterSpacing: 0.2,
                alternateFont: true,
              ),
            ),
            onTheRight
          ],
        ),
      ),
    );
  }
}
