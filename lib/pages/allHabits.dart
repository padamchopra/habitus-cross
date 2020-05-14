import 'dart:async';
import 'dart:math';
import 'package:habito/models/universalValues.dart' as universalValue;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habito/widgets/habitTile.dart';
import 'package:habito/widgets/text.dart';

class AllHabits extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllHabitsState();
  }
}

class _AllHabitsState extends State<AllHabits> {
  List daysCompleted = [0,0,0,0,0,0,0,0,0,0];
  initState() {
    super.initState();
    new Future.delayed(Duration(milliseconds: 100)).then((_) {
      setState(() {
        for (var i = 0; i < 10; i++) {
          daysCompleted[i] = 21;
        }
      });
    });
    new Future.delayed(Duration(milliseconds: 800)).then((_) {
      setState(() {
        for (var i = 0; i < 10; i++) {
          daysCompleted[i] = Random().nextInt(22);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: universalValue.topPaddingBeforeHeading,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: universalValue.headingHorizontalMargin),
          child: CustomText(
            "Habits",
            fontSize: universalValue.headingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Color(0x80636363),
          width: double.infinity,
          height: 1,
        ),
        Expanded(
          child: StaggeredGridView.countBuilder(
            padding: EdgeInsets.only(top: 22.5),
            crossAxisCount: 2,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return HabitTile(index, daysCompleted[index]);
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          ),
        ),
      ],
    );
  }
}
