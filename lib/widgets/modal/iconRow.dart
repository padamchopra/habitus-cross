import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class IconRow extends StatelessWidget {
  final Function onTapFunction;
  final IconData icon;
  IconRow(this.onTapFunction, {this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        CustomText(
          "Icon",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          width: 10,
        ),
        CustomText(
          "->",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: MyColors.backdropBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon != null ? icon : Icons.arrow_drop_down,
            ),
          ),
        ),
      ],
    );
  }
}
