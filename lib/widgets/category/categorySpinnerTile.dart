import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class CategorySpinnerTile extends StatelessWidget {
  final IconData icon;
  final String name;
  CategorySpinnerTile(this.icon, this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: MyColors.black,
          ),
          SizedBox(
            width: 6,
          ),
          CustomText(
            name,
            color: MyColors.black,
            fontSize: 18,
          )
        ],
      ),
    );
  }
}
