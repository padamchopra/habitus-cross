import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/widgets/general/options.dart';
import 'package:habito/widgets/habit/habitModal.dart';

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
    HabitoModel model,
    HabitSelectedOption option,
    MyHabit myHabit,
    MyCategory myCategory,
  ) {
    switch (option) {
      case HabitSelectedOption.DUPLICATE_AND_EDIT:
        duplicateAndEdit(model, myHabit, myCategory);
        break;
      case HabitSelectedOption.RESET_PROGRESS:
        resetProgress(model, myHabit);
        break;
      case HabitSelectedOption.DELETE:
        deleteHabit(model, myHabit);
        break;
      case HabitSelectedOption.NONE:
        break;
    }
  }

  static void resetProgress(
    HabitoModel model,
    MyHabit myHabit,
  ) async {
    GlobalKey<ScaffoldState> key = model.globalScaffoldKey;
    bool resetResult = await model.resetHabitProgress(myHabit);
    UniversalFunctions.showAlert(
      key.currentContext,
      resetResult ? "Reset" : "Try Again",
      resetResult
          ? "Progress was reset successfully. Good luck with this fresh start."
          : "Progress could not be reset.",
    );
  }

  static void deleteHabit(
    HabitoModel model,
    MyHabit myHabit,
  ) async {
    GlobalKey<ScaffoldState> key = model.globalScaffoldKey;
    bool deletionResult = await model.deleteHabit(myHabit);

    UniversalFunctions.showAlert(
      key.currentContext,
      deletionResult ? "Deleted" : "Try Again",
      deletionResult
          ? "That's a bummer. Good luck with the remaining habits."
          : "Habit could not be deleted.",
    );
  }

  static void duplicateAndEdit(
    HabitoModel model,
    MyHabit myHabit,
    MyCategory myCategory,
  ) {
    GlobalKey<ScaffoldState> key = model.globalScaffoldKey;
    key.currentState.showBottomSheet((context) => HabitModal(
          HabitModalMode.DUPLICATE,
          myHabit: myHabit,
          myCategory: myCategory,
        ));
  }

  static void viewMoreOptions({
    @required BuildContext context,
    @required HabitoModel model,
    @required MyHabit myHabit,
    @required MyCategory myCategory,
    @required Offset offset,
  }) async {
    Map<String, dynamic> values = {
      "Duplicate and Edit": HabitSelectedOption.DUPLICATE_AND_EDIT,
      "Reset Progress": HabitSelectedOption.RESET_PROGRESS,
      "Delete": HabitSelectedOption.DELETE,
    };
    HabitSelectedOption option =
        await Options.show(context, offset, HabitSelectedOption.NONE, values);
    handleHabitOptionSelect(model, option, myHabit, myCategory);
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
