import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habito/widgets/habit/options/habitOptions.dart';
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
  Map<int, bool> tileClicked = new Map();

  void toggleTileClick(int index) {
    setState(() {
      tileClicked[index] = !tileClicked[index];
    });
  }

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ScopedModelDescendant<HabitoModel>(
              builder: (context, child, model) {
                int numberOfHabits = model.numberOfHabits();
                if (numberOfHabits == -1) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (numberOfHabits == 0) {
                  return Center(
                    child: CustomText(
                      "Start tracking a habit you want \nto develop by tapping +",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                List<MyHabit> _myHabits = model.myHabitsList;
                return StaggeredGridView.countBuilder(
                  addRepaintBoundaries: true,
                  padding: EdgeInsets.only(top: 22.5),
                  crossAxisCount: 2,
                  itemCount: numberOfHabits,
                  itemBuilder: (BuildContext context, int index) {
                    MyCategory _myCategory =
                        model.findCategoryById(_myHabits[index].category);
                    return Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTapDown: (tapDetails) {
                            setState(() {
                              bool result = tileClicked.containsKey(index)
                                  ? !tileClicked[index]
                                  : true;
                              tileClicked.clear();
                              tileClicked[index] = result;
                            });
                          },
                          child: HabitTile(
                            index,
                            _myHabits[index],
                            _myCategory,
                          ),
                        ),
                        (tileClicked.containsKey(index) && tileClicked[index])
                            ? Align(
                                child: HabitOptions(
                                  index,
                                  _myHabits[index],
                                  _myCategory,
                                  toggleTileClick,
                                ),
                                alignment: Alignment.topCenter)
                            : Container(),
                      ],
                    );
                  },
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
