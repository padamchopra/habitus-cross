import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/habitFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/habit/options/optionCircle.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitOptions extends StatefulWidget {
  final int index;
  final MyHabit myHabit;
  final MyCategory myCategory;
  final Function toggle;
  HabitOptions(
    this.index,
    this.myHabit,
    this.myCategory,
    this.toggle,
  );

  @override
  State<StatefulWidget> createState() {
    return _HabitOptionsState();
  }
}

class _HabitOptionsState extends State<HabitOptions> {
  EdgeInsets doneButtonMargin = MySpaces.marginForHabitSecondOption;
  EdgeInsets moreButtonMargin = MySpaces.marginForHabitSecondOption;
  EdgeInsets parentMargin = MySpaces.marginForParentOption;
  Color doneButtonColor = MyColors.habitOption;
  Color doneButtonIconColor = MyColors.placeholderGrey;

  void closeOptions() {
    widget.toggle(widget.index);
  }

  void viewMoreOptions(model, offset) {
    closeOptions();
    HabitFunctions.viewMoreOptions(
      context: context,
      model: model,
      myHabit: widget.myHabit,
      myCategory: widget.myCategory,
      offset: offset,
    );
  }

  void markHabitDone(context, model, myHabit) {
    closeOptions();
    HabitFunctions.markHabitDone(
      context: context,
      model: model,
      myHabit: myHabit,
    );
  }

  void viewHabitDetails(context, myHabit, myCategory) {
    closeOptions();
    HabitFunctions.viewHabitDetails(
      context: context,
      myHabit: myHabit,
      myCategory: myCategory,
    );
  }

  initState() {
    super.initState();
    List<Timestamp> updateTimes = widget.myHabit.updateTimes;
    if (updateTimes != null &&
        updateTimes.length > 0 &&
        updateTimes.asMap()[0].toDate().day == DateTime.now().day) {
      doneButtonColor = MyColors.success;
      doneButtonIconColor = MyColors.white;
    }
    new Future.delayed(Duration(milliseconds: 10)).then((_) {
      setState(() {
        doneButtonMargin = MySpaces.marginForHabitFirstOption;
        moreButtonMargin = MySpaces.marginForHabitThirdOption;
        parentMargin = EdgeInsets.all(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
      margin: parentMargin,
      child: ScopedModelDescendant<HabitoModel>(
        builder: (context, child, model) {
          return Stack(
            children: [
              OptionCircle(
                (_) => markHabitDone(
                  context,
                  model,
                  widget.myHabit,
                ),
                doneButtonMargin,
                Icons.check,
              ),
              OptionCircle(
                (_) => viewHabitDetails(
                  context,
                  widget.myHabit,
                  widget.myCategory,
                ),
                MySpaces.marginForHabitSecondOption,
                Icons.remove_red_eye,
              ),
              OptionCircle(
                (TapDownDetails tapDownDetails) =>
                    viewMoreOptions(model, tapDownDetails.globalPosition),
                moreButtonMargin,
                Icons.more_horiz,
              ),
            ],
          );
        },
      ),
    );
  }
}
