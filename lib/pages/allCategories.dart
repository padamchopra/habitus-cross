import 'package:flutter/material.dart';
import 'package:habito/models/analytics.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habitoModel.dart';
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

  void initState() {
    super.initState();
    Analytics.sendAnalyticsEvent(Analytics.categoriesOpened);
  }

  void moreOptionSwitch(CategorySelectedOption option, HabitoModel model) {
    switch (option) {
      case CategorySelectedOption.VIEW_HABITS:
        Analytics.sendAnalyticsEvent(Analytics.categoryOptionToViewHabits);
        break;
      case CategorySelectedOption.EDIT:
        Analytics.sendAnalyticsEvent(Analytics.categoryOptionToEdit);
        openCategoryModal(CategoryModalMode.EDIT);
        break;
      case CategorySelectedOption.DUPLICATE_AND_EDIT:
        Analytics.sendAnalyticsEvent(Analytics.categoryOptionToDuplicate);
        openCategoryModal(CategoryModalMode.DUPLICATE);
        break;
      case CategorySelectedOption.DELETE:
        Analytics.sendAnalyticsEvent(Analytics.categoryOptionToDelete);
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
    model.deleteCategory(_selectedCategory).then((value) {
      model.neverSatisfied(
        context,
        MyStrings.deleteCategoryHeading[value ? 0 : 1],
        MyStrings.deleteCategoryBody[value ? 0 : 1],
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
                  child: CustomText(
                    "No categories yet.\nCreate one now by tapping +",
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
