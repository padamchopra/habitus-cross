import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/widgets/habit/habitModal.dart';
import 'package:habito/widgets/habit/options/habitMoreOptions.dart';

class HabitFunctions {
  static void markHabitDone({
    @required BuildContext context,
    @required HabitoModel model,
    @required MyHabit myHabit,
  }) async {
    if (myHabit.isFinished) {
      UniversalFunctions.showAlert(
        context,
        "Already Tracked",
        "Tracking for this habit has already been completed.",
      );
      return;
    }
    HabitProgressChange progressChange = model.markDoneForToday(myHabit);
    if (progressChange == HabitProgressChange.SUCCESS) {
    } else if (progressChange == HabitProgressChange.UPDATED_TODAY) {
      UniversalFunctions.showAlert(context, "Slow down",
          "You've already marked your progress for this habit today.");
    } else if (progressChange == HabitProgressChange.LATE) {
      UniversalFunctions.showAlert(context, "Woops",
          "Looks like you missed a day or more. Progress has been reset.");
    } else if (progressChange == HabitProgressChange.COMPLETE) {
      model.playConfetti();
    } else {
      UniversalFunctions.showAlert(
          context, "Try Again", "Could not update your progress.");
    }
  }

  static void handleHabitOptionSelect(
    BuildContext context,
    HabitoModel model,
    HabitSelecetedOption option,
    MyHabit myHabit,
    MyCategory myCategory,
  ) {
    switch (option) {
      case HabitSelecetedOption.DUPLICATE_AND_EDIT:
        duplicateAndEdit(context, myHabit, myCategory);
        break;
      case HabitSelecetedOption.RESET_PROGRESS:
        resetProgress(context, model, myHabit);
        break;
      case HabitSelecetedOption.DELETE:
        deleteHabit(context, model, myHabit);
        break;
    }
  }

  static void resetProgress(
    BuildContext context,
    HabitoModel model,
    MyHabit myHabit,
  ) {
    model.resetHabitProgress(myHabit).then((value) {
      if (value) {
        UniversalFunctions.showAlert(
          context,
          "Reset",
          "Progress was reset successfully. Good luck with this fresh start.",
        );
      } else {
        UniversalFunctions.showAlert(
          context,
          "Try Again",
          "Progress could not be reset.",
        );
      }
    });
  }

  static void deleteHabit(
    BuildContext context,
    HabitoModel model,
    MyHabit myHabit,
  ) async {
    bool deletionResult = await model.deleteHabit(myHabit);
    if (deletionResult) {
      UniversalFunctions.showAlert(
        context,
        "Deleted",
        "That's a bummer. Good luck with the remaining habits.",
      );
    } else {
      UniversalFunctions.showAlert(
        context,
        "Try Again",
        "Habit could not be deleted.",
      );
    }
  }

  static void duplicateAndEdit(
    BuildContext context,
    MyHabit myHabit,
    MyCategory myCategory,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return HabitModal(
          HabitModalMode.DUPLICATE,
          myHabit: myHabit,
          myCategory: myCategory,
        );
      },
    );
  }

  static void viewMoreOptions({
    @required BuildContext context,
    @required HabitoModel model,
    @required MyHabit myHabit,
    @required MyCategory myCategory,
  }) {
    HabitMoreOptions.show(context, model, myHabit, myCategory);
  }

  static void viewHabitDetails({
    @required BuildContext context,
    @required MyHabit myHabit,
    @required MyCategory myCategory,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return HabitModal(
          HabitModalMode.VIEW,
          myHabit: myHabit,
          myCategory: myCategory,
        );
      },
    );
  }
}
