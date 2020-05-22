import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class AllCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllCategoriesState();
  }
}

class _AllCategoriesState extends State<AllCategories> {
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
                List<MyCategory> _myCategoriesList = model.myCategoriesList;
                Map<int, MyCategory> _myCategories = _myCategoriesList.asMap();
                return ListView.builder(
                  padding: EdgeInsets.only(top: 22.5),
                  itemCount: numberOfCategories,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 18),
                      child:
                          _myCategories[index].widget(showNumberOfHabits: true),
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
