import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/category/categoryModal.dart';
import 'package:habito/widgets/general/addNewModal.dart';
import 'package:habito/widgets/habit/habitModal.dart';

class HomeFunctions {
  static void showMyBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext _context) {
        return AddNewModal();
      },
    );
  }

  static void addNewHabit(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return HabitModal(HabitModalMode.NEW);
      },
    );
  }

  static void addNewCategory(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return CategoryModal(CategoryModalMode.NEW);
      },
    );
  }

  static void addNewExport(BuildContext context) {
    UniversalFunctions.showAlert(
      context,
      MyStrings.newFeatureTeaseHeading,
      MyStrings.newFeatureTeaseBody,
    );
  }
}
