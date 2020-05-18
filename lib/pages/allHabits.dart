import 'dart:async';
import 'dart:math';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habito/widgets/habitTile.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class AllHabits extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllHabitsState();
  }
}

class _AllHabitsState extends State<AllHabits> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: UniversalValues.topPaddingBeforeHeading,
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: UniversalValues.headingHorizontalMargin),
          child: CustomText(
            "Habits",
            color: HabitoColors.white,
            fontSize: UniversalValues.headingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: HabitoColors.ruler,
          width: double.infinity,
          height: 1,
        ),
        Expanded(
          child: ScopedModelDescendant<HabitoModel>(
            builder: (context, child, model) {
              int numberOfHabits = model.numberOfHabits();
                if (numberOfHabits == 0) {
                  return Center(
                    child: CustomText(
                      "Start tracking a habit you want \nto develop by tapping +",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              List<MyHabit> _myHabitsList = model.myHabits;
              Map<int, MyHabit> _myHabits = _myHabitsList.asMap();
              return StaggeredGridView.countBuilder(
                padding: EdgeInsets.only(top: 22.5),
                crossAxisCount: 2,
                itemCount: numberOfHabits,
                itemBuilder: (BuildContext context, int index) {
                  return HabitTile(index, _myHabits[index], model.findCategoryById(_myHabits[index].category));
                },
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              );
            },
          ),
        ),
      ],
    );
  }
}
