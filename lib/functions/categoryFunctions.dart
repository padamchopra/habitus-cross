import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/widgets/category/categoryModal.dart';

class CategoryFunctions {
  static void handleCategoryOptionSelect(
      {@required BuildContext optionsContext,
      @required BuildContext screenContext,
      HabitoModel model,
      @required CategorySelectedOption option,
      @required MyCategory category}) {
    Navigator.of(optionsContext).pop();
    switch (option) {
      case CategorySelectedOption.VIEW_HABITS:
        break;
      case CategorySelectedOption.EDIT:
        openCategoryModal(screenContext, CategoryModalMode.EDIT, category);
        break;
      case CategorySelectedOption.DUPLICATE_AND_EDIT:
        openCategoryModal(screenContext, CategoryModalMode.DUPLICATE, category);
        break;
      case CategorySelectedOption.DELETE:
        deleteCategory(screenContext, model, category);
        break;
    }
  }

  static void openCategoryModal(
      BuildContext context, CategoryModalMode option, MyCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return CategoryModal(
          option,
          myCategory: category,
        );
      },
    );
  }

  static void deleteCategory(
      BuildContext context, HabitoModel model, MyCategory category) {
    model.deleteCategory(category).then((resultMap) {
      int index = 1;
      if (resultMap["deleted"]) {
        model.updateHabits(resultMap["associatedHabits"]);
        index = 0;
      }
      UniversalFunctions.showAlert(
        context,
        MyStrings.deleteCategoryHeading[index],
        MyStrings.deleteCategoryBody[index],
      );
    });
  }
}
