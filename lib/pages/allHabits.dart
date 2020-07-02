import 'package:habito/functions/habitFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:habito/widgets/habit/options/habitOptions.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class AllHabits extends StatefulWidget {
  final bool showOnlyCompleted;
  AllHabits(this.showOnlyCompleted);
  @override
  State<StatefulWidget> createState() {
    return _AllHabitsState();
  }
}

class _AllHabitsState extends State<AllHabits> {
  Map<int, bool> tileClicked = new Map();
  TapDownDetails tapDownDetails;

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
        widget.showOnlyCompleted
            ? const PageHeading(MyStrings.completedHabitsPageHeading)
            : const PageHeading(MyStrings.habitsPageHeading),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ScopedModelDescendant<HabitoModel>(
              builder: (context, child, model) {
                int numberOfHabits =
                    model.numberOfHabits(widget.showOnlyCompleted);
                if (numberOfHabits == -1) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }
                if (numberOfHabits == 0) {
                  return Center(
                    child: CustomText(
                      widget.showOnlyCompleted
                          ? MyStrings.noCompletedHabitsMessage
                          : MyStrings.noHabitsMessage,
                      textAlign: TextAlign.center,
                      alternateFont: true,
                    ),
                  );
                }
                List<MyHabit> _myHabits =
                    model.myHabitsAsList(widget.showOnlyCompleted);
                _myHabits.sort(model.sortingMethod);
                return StaggeredGridView.countBuilder(
                  addRepaintBoundaries: true,
                  padding: MySpaces.listViewTopPadding,
                  crossAxisCount: 2,
                  itemCount: numberOfHabits,
                  itemBuilder: (BuildContext context, int index) {
                    MyCategory _myCategory =
                        model.getCategoryById(_myHabits[index].category);
                    return Stack(
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () {
                            setState(() {
                              tileClicked[index] = false;
                            });
                            HabitFunctions.viewMoreOptions(
                              context: context,
                              model: model,
                              myHabit: _myHabits[index],
                              myCategory: _myCategory,
                              offset: tapDownDetails.globalPosition,
                            );
                          },
                          onTapDown: (details) => tapDownDetails = details,
                          onTap: () {
                            setState(() {
                              bool result = tileClicked.containsKey(index)
                                  ? !tileClicked[index]
                                  : true;
                              tileClicked.clear();
                              tileClicked[index] = result;
                            });
                          },
                          child: _myHabits[index].widget(_myCategory),
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
