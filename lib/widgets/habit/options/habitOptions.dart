import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/habit/habitModal.dart';
import 'package:habito/widgets/habit/options/habitMoreOptions.dart';
import 'package:habito/widgets/habit/options/optionCircle.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitOptions extends StatefulWidget {
  final int index;
  final MyHabit myHabit;
  final MyCategory myCategory;
  final Function toggle;
  final bool showOnlyCompleted;
  HabitOptions(this.index, this.myHabit, this.myCategory, this.toggle,
      this.showOnlyCompleted);

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

  void markHabitDone(HabitoModel model) async {
    if (widget.showOnlyCompleted) {
      UniversalFunctions.showAlert(context, "Already tracked.",
          "This habit has already been completed. Try resetting the progress if you want to go at it again.");
      return;
    }
    HabitProgressChange progressChange = model.markDoneForToday(widget.myHabit);
    if (progressChange == HabitProgressChange.SUCCESS) {
      setState(() {
        doneButtonColor = MyColors.success;
        doneButtonIconColor = MyColors.white;
      });
    } else if (progressChange == HabitProgressChange.UPDATED_TODAY) {
      UniversalFunctions.showAlert(context, "Slow down",
          "You've already marked your progress for this habit today.");
    } else if (progressChange == HabitProgressChange.LATE) {
      UniversalFunctions.showAlert(context, "Woops",
          "Looks like you missed a day or more. Progress has been reset.");
    } else if (progressChange == HabitProgressChange.COMPLETE) {
      model.playConfetti();
    } else {
      UniversalFunctions.showAlert(context, "Try Again", "Could not update your progress.");
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
    HabitMoreOptions.show(context, model, decideMoreOptionFunction);
  }

  void decideMoreOptionFunction(
      HabitSelecetedOption option, HabitoModel model) {
    switch (option) {
      case HabitSelecetedOption.DUPLICATE_AND_EDIT:
        duplicateAndEdit();
        break;
      case HabitSelecetedOption.RESET_PROGRESS:
        resetProgress(model);
        break;
      case HabitSelecetedOption.DELETE:
        deleteHabit(model);
        break;
    }
  }

  void duplicateAndEdit() {
    closeOptions();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return HabitModal(
          HabitModalMode.DUPLICATE,
          myHabit: widget.myHabit,
          myCategory: widget.myCategory,
        );
      },
    );
  }

  void resetProgress(HabitoModel model) {
    closeOptions();
    model.resetHabitProgress(widget.myHabit).then((value) {
      if (value) {
        UniversalFunctions.showAlert(context, "Reset",
            "Progress was reset successfully. Good luck with this fresh start.");
      } else {
        UniversalFunctions.showAlert(context, "Try Again", "Progress could not be reset.");
      }
    });
  }

  void deleteHabit(HabitoModel model) {
    closeOptions();
    model.deleteHabit(widget.myHabit).then((value) {
      if (value) {
        UniversalFunctions.showAlert(context, "Deleted",
            "That's a bummer. Good luck with the remaining habits.");
      } else {
        UniversalFunctions.showAlert(context, "Try Again", "Habit could not be deleted.");
      }
    });
  }

  initState() {
    super.initState();
    List<Timestamp> updateTimes = widget.myHabit.updateTimes;
    if (updateTimes != null && updateTimes.length > 0 &&
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
                () => markHabitDone(model),
                doneButtonMargin,
                Icons.check,
              ),
              OptionCircle(
                viewHabitDetails,
                MySpaces.marginForHabitSecondOption,
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
