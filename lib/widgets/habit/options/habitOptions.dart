import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/habit/options/habitMoreOptions.dart';
import 'package:habito/widgets/habit/options/optionCircle.dart';
import 'package:habito/widgets/habitModal.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitOptions extends StatefulWidget {
  final int index;
  final MyHabit myHabit;
  final MyCategory myCategory;
  final Function toggle;
  HabitOptions(this.index, this.myHabit, this.myCategory, this.toggle);

  @override
  State<StatefulWidget> createState() {
    return _HabitOptionsState();
  }
}

class _HabitOptionsState extends State<HabitOptions> {
  EdgeInsets doneButtonMargin = UniversalValues.marginForHabitSecondOption;
  EdgeInsets moreButtonMargin = UniversalValues.marginForHabitSecondOption;
  EdgeInsets parentMargin = UniversalValues.marginForParentOption;
  Color doneButtonColor = HabitoColors.habitOption;
  Color doneButtonIconColor = HabitoColors.placeholderGrey;

  void closeOptions() {
    widget.toggle(widget.index);
  }

  void markHabitDone(HabitoModel model) {
    int resultCode = model.markDoneForToday(widget.myHabit);
    if (resultCode == 0 || resultCode == 3) {
      setState(() {
        doneButtonColor = HabitoColors.success;
        doneButtonIconColor = HabitoColors.white;
      });
    } else if (resultCode == 1) {
      model.neverSatisfied(context, "Slow down",
          "You've already marked your progress for this habit today.");
    } else if (resultCode == 2) {
      model.neverSatisfied(context, "Woops",
          "Looks like you missed a day or more. Progress has been reset.");
    } else if (resultCode == 3) {
      model.neverSatisfied(context, "Congrats",
          "You've successfully managed to keep up for 21 days. Tracking for this habit is now complete.");
    } else {
      model.neverSatisfied(
          context, "Try Again", "Could not update your progress.");
    }
    closeOptions();
  }

  void viewHabitDetails() {
    closeOptions();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return HabitModal(
          HabitModalMode.VIEW,
          myHabit: widget.myHabit,
          myCategory: widget.myCategory,
        );
      },
    );
  }

  void viewMoreOptions(model) {
    HabitMoreOptions.show(context, model);
    closeOptions();
  }

  initState() {
    super.initState();
    List<Timestamp> updateTimes = widget.myHabit.updateTimes;
    if (updateTimes.length > 0 &&
        updateTimes.asMap()[0].toDate().day == DateTime.now().day) {
      doneButtonColor = HabitoColors.success;
      doneButtonIconColor = HabitoColors.white;
    }
    new Future.delayed(Duration(milliseconds: 10)).then((_) {
      setState(() {
        doneButtonMargin = UniversalValues.marginForHabitFirstOption;
        moreButtonMargin = UniversalValues.marginForHabitThirdOption;
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
                () => markHabitDone(model),
                doneButtonMargin,
                Icons.check,
              ),
              OptionCircle(
                viewHabitDetails,
                UniversalValues.marginForHabitSecondOption,
                Icons.remove_red_eye,
              ),
              OptionCircle(
                () => viewMoreOptions(model),
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
