import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/category/categoryModal.dart';
import 'package:habito/widgets/category/categoryMoreOptions.dart';
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
    model.deleteCategory(_selectedCategory).then((value) {
      if (value) {
        model.neverSatisfied(context, "Deleted",
            "This category has been deleted and child habits unlinked.");
      } else {
        model.neverSatisfied(
            context, "Try Again", "Category could not be deleted.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: UniversalValues.topPaddingBeforeHeading,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: UniversalValues.headingHorizontalMargin,
          ),
          child: CustomText(
            "Categories",
            fontSize: UniversalValues.headingFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: HabitoColors.ruler,
          width: double.infinity,
          height: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ScopedModelDescendant<HabitoModel>(
              builder: (context, child, model) {
                int numberOfCategories = model.numberOfCategories();
                if (numberOfCategories == -1) {
                  return Center(
                    child: CircularProgressIndicator(),
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
                  padding: EdgeInsets.only(top: 22.5),
                  itemCount: numberOfCategories,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 18),
                      child: GestureDetector(
                        onTap: () {
                          _selectedCategory = _myCategories[index];
                          CategoryMoreOptions.show(
                            context,
                            model,
                            moreOptionSwitch,
                          );
                        },
                        child: _myCategories[index]
                            .widget(showNumberOfHabits: true),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
