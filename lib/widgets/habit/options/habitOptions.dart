import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/analytics.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
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
  EdgeInsets doneButtonMargin = UniversalValues.marginForHabitSecondOption;
  EdgeInsets moreButtonMargin = UniversalValues.marginForHabitSecondOption;
  EdgeInsets parentMargin = UniversalValues.marginForParentOption;
  Color doneButtonColor = MyColors.habitOption;
  Color doneButtonIconColor = MyColors.placeholderGrey;

  void closeOptions() {
    widget.toggle(widget.index);
  }

  void markHabitDone(HabitoModel model) async {
    Analytics.sendAnalyticsEvent(Analytics.habitOptionToMarkDone);
    if (widget.showOnlyCompleted) {
      model.neverSatisfied(context, "Already tracked.",
          "This habit has already been completed. Try resetting the progress if you want to go at it again.");
      return;
    }
    int resultCode = model.markDoneForToday(widget.myHabit);
    if (resultCode == 0) {
      setState(() {
        doneButtonColor = MyColors.success;
        doneButtonIconColor = MyColors.white;
      });
    } else if (resultCode == 1) {
      model.neverSatisfied(context, "Slow down",
          "You've already marked your progress for this habit today.");
    } else if (resultCode == 2) {
      model.neverSatisfied(context, "Woops",
          "Looks like you missed a day or more. Progress has been reset.");
    } else if (resultCode == 3) {
      model.playConfetti();
      /*await new Future.delayed(const Duration(seconds: 4));
      model.neverSatisfied(context, "Congratulations",
          "You have successfully formed ${model.myHabitsCompletedList.length} habits thrugh Habito!");*/
    } else {
      model.neverSatisfied(
          context, "Try Again", "Could not update your progress.");
    }
    closeOptions();
  }

  void viewHabitDetails() {
    Analytics.sendAnalyticsEvent(Analytics.habitOptionToView);
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
    Analytics.sendAnalyticsEvent(Analytics.habitOptionToView);
    HabitMoreOptions.show(context, model, decideMoreOptionFunction);
  }

  void decideMoreOptionFunction(
      HabitSelecetedOption option, HabitoModel model) {
    switch (option) {
      case HabitSelecetedOption.DUPLICATE_AND_EDIT:
        Analytics.sendAnalyticsEvent(Analytics.habitOptionToDuplicate);
        duplicateAndEdit();
        break;
      case HabitSelecetedOption.RESET_PROGRESS:
        Analytics.sendAnalyticsEvent(Analytics.habitOptionToResetProgress);
        resetProgress(model);
        break;
      case HabitSelecetedOption.DELETE:
        Analytics.sendAnalyticsEvent(Analytics.habitOptionToDelete);
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
        model.neverSatisfied(context, "Reset",
            "Progress was reset successfully. Good luck with this fresh start.");
      } else {
        model.neverSatisfied(
            context, "Try Again", "Progress could not be reset.");
      }
    });
  }

  void deleteHabit(HabitoModel model) {
    closeOptions();
    model.deleteHabit(widget.myHabit).then((value) {
      if (value) {
        model.neverSatisfied(context, "Deleted",
            "That's a bummer. Good luck with the remaining habits.");
      } else {
        model.neverSatisfied(
            context, "Try Again", "Habit could not be deleted.");
      }
    });
  }

  initState() {
    super.initState();
    List<Timestamp> updateTimes = widget.myHabit.updateTimes;
    if (updateTimes.length > 0 &&
        updateTimes.asMap()[0].toDate().day == DateTime.now().day) {
      doneButtonColor = MyColors.success;
      doneButtonIconColor = MyColors.white;
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
