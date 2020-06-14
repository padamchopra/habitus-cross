import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/category/categoryModal.dart';
import 'package:habito/widgets/category/categoryMoreOptions.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class AllCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllCategoriesState();
  }
}

class _AllCategoriesState extends State<AllCategories> {
  MyCategory _selectedCategory = MyCategory();

  void moreOptionSwitch(CategorySelectedOption option, HabitoModel model) {
    switch (option) {
      case CategorySelectedOption.VIEW_HABITS:
        break;
      case CategorySelectedOption.EDIT:
        openCategoryModal(CategoryModalMode.EDIT);
        break;
      case CategorySelectedOption.DUPLICATE_AND_EDIT:
        openCategoryModal(CategoryModalMode.DUPLICATE);
        break;
      case CategorySelectedOption.DELETE:
        deleteCategory(model);
        break;
    }
  }

  void openCategoryModal(option) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return CategoryModal(
          option,
          myCategory: _selectedCategory,
        );
      },
    );
  }

  void deleteCategory(HabitoModel model) {
    model.deleteCategory(_selectedCategory).then((resultMap) {
      int index = 1;
      if (resultMap["deleted"]) {
        model.updateHabits(resultMap["associatedHabits"]);
        index = 0;
      }
      model.showAlert(
        context,
        MyStrings.deleteCategoryHeading[index],
        MyStrings.deleteCategoryBody[index],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PageHeading("Categories"),
        Expanded(
          child: ScopedModelDescendant<HabitoModel>(
            builder: (context, child, model) {
              int numberOfCategories = model.numberOfCategories();
              if (numberOfCategories == -1) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (numberOfCategories == 0) {
                return Center(
                  child: const CustomText(
                    MyStrings.noCategoriesMessage,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              List<MyCategory> _myCategories = model.myCategoriesList;
              return ListView.builder(
                padding: MySpaces.listViewTopPadding,
                itemCount: numberOfCategories,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _selectedCategory = _myCategories[index];
                      CategoryMoreOptions.show(
                        context,
                        model,
                        moreOptionSwitch,
                      );
                    },
                    child:
                        _myCategories[index].widget(showNumberOfHabits: true),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
