import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/widgets/category/categoryModal.dart';
import 'package:habito/widgets/general/options.dart';

class CategoryFunctions {
  static void viewMoreOptions({
    @required BuildContext context,
    @required HabitoModel model,
    @required MyCategory myCategory,
    @required Offset offset,
  }) async {
    Map<String, dynamic> values = {
      "Edit": CategorySelectedOption.EDIT,
      "Duplicate and Edit": CategorySelectedOption.DUPLICATE_AND_EDIT,
      "Delete": CategorySelectedOption.DELETE,
    };
    CategorySelectedOption option = await Options.show(
        context, offset, CategorySelectedOption.NONE, values);
    handleCategoryOptionSelect(model, option, myCategory);
  }

  static void handleCategoryOptionSelect(
    HabitoModel model,
    CategorySelectedOption option,
    MyCategory category,
  ) {
    switch (option) {
      case CategorySelectedOption.VIEW_HABITS:
        break;
      case CategorySelectedOption.EDIT:
        openCategoryModal(model, CategoryModalMode.EDIT, category);
        break;
      case CategorySelectedOption.DUPLICATE_AND_EDIT:
        openCategoryModal(model, CategoryModalMode.DUPLICATE, category);
        break;
      case CategorySelectedOption.DELETE:
        deleteCategory(model, category);
        break;
      case CategorySelectedOption.NONE:
        break;
    }
  }

  static void openCategoryModal(
    HabitoModel model,
    CategoryModalMode option,
    MyCategory category,
  ) {
    GlobalKey<ScaffoldState> key = model.globalScaffoldKey;
    showModalBottomSheet(
      context: key.currentState.context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return CategoryModal(
          option,
          myCategory: category,
        );
      },
    );
  }

  static void deleteCategory(HabitoModel model, MyCategory category) async {
    GlobalKey<ScaffoldState> key = model.globalScaffoldKey;
    Map<String, bool> associatedHabits = await model.deleteCategory(category);
    int index = 1;
    if (associatedHabits.isNotEmpty) {
      model.updateHabits(associatedHabits);
      index = 0;
    }
    UniversalFunctions.showAlert(
      key.currentState.context,
      MyStrings.deleteCategoryHeading[index],
      MyStrings.deleteCategoryBody[index],
    );
  }
}
