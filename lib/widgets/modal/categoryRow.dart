import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class CategoryRow extends StatelessWidget {
  final Function onTapFunction;
  final Color color;
  final IconData icon;
  CategoryRow(this.onTapFunction, {this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        CustomText(
          "Category",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
        ),
        SizedBox(width: 10),
        CustomText(
          "->",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color != null
                  ? color
                  : MyColors.backdropBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon != null 
                ? Icon(
                    icon,
                    color: MyColors.white,
                  )
                : Icon(
                    Icons.arrow_drop_down,
                  ),
          ),
        ),
      ],
    );
  }
}
