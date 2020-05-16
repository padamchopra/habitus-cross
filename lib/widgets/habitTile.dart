import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class HabitTile extends StatelessWidget {
  final int index;
  final Color tileColor;
  final int daysCompleted;
  HabitTile(this.index, this.daysCompleted, {this.tileColor});
  final EdgeInsets rightTileMargin = EdgeInsets.fromLTRB(10, 9, 25, 9);
  final EdgeInsets leftTileMargin = EdgeInsets.fromLTRB(25, 9, 10, 9);
  
  @override
  Widget build(BuildContext context) {
    double x = (MediaQuery.of(context).size.width / 2) - 35;
    double rightGap = x - 21;
    if (daysCompleted == 0) {
      rightGap = x;
    } else {
      rightGap -= (daysCompleted / 21) * rightGap;
    }
    return Container(
      decoration: BoxDecoration(
        color: HabitoColors.black,
      ),
      margin: index % 2 == 0 ? leftTileMargin : rightTileMargin,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: HabitoColors.midnight,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(
              milliseconds: 700,
            ),
            curve: Curves
                .fastOutSlowIn,
            left: 0,
            top: 0,
            bottom: 0,
            right: rightGap,
            child: AnimatedContainer(
              duration: Duration(
                milliseconds: 700,
              ),
              decoration: BoxDecoration(
                color:
                    tileColor == null ? HabitoColors.perfectBlue : tileColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  bottomLeft: Radius.circular(21),
                  topRight: Radius.circular(
                      rightGap <= 21 ? (21 - rightGap) : 0),
                  bottomRight: Radius.circular(
                      rightGap <= 21 ? (21 - rightGap) : 0),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 24),
                CustomText(
                  "Cooking Class",
                  fontSize: 24,
                  letterSpacing: 0.2,
                ),
                SizedBox(height: 12),
                CustomText(
                  daysCompleted.toString() + " of 21 days done",
                  fontSize: 14,
                  letterSpacing: -0.3,
                  color: HabitoColors.captionWhite,
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
