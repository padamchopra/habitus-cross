import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class CategoryRow extends StatelessWidget {
  final Function onTapFunction;
  final Color color;
  final IconData icon;
  final String name;
  CategoryRow(this.onTapFunction, {this.color, this.icon, this.name});

  @override
  Widget build(BuildContext context) {
    String categoryName;
    if (name == null) {
      categoryName = null;
    } else if (name == "") {
      categoryName = "unnamed";
    } else if (name.length > 15) {
      categoryName = name.substring(0, 13) + '...';
    } else {
      categoryName = name;
    }
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        CustomText(
          "Category",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
          alternateFont: true,
        ),
        SizedBox(width: 10),
        CustomText(
          "->",
          color: MyColors.black,
          fontSize: 18,
          textAlign: TextAlign.start,
          alternateFont: true,
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: onTapFunction,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color != null ? color : MyColors.backdropBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                icon != null
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: 3.0,
                          right: categoryName == null ? 3 : 0,
                        ),
                        child: Icon(
                          icon,
                          color: MyColors.white,
                        ),
                      )
                    : Icon(
                        Icons.arrow_drop_down,
                      ),
                categoryName != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        child: CustomText(
                          categoryName,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          alternateFont: true,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
