import 'package:flutter/material.dart';
import 'package:habito/functions/categoryFunctions.dart';
import 'package:habito/models/category.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PageHeading(MyStrings.categoriesPageHeading),
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
                    alternateFont: true,
                  ),
                );
              }

              List<MyCategory> _myCategories = model.myCategoriesAsList;
              TapDownDetails tapDownDetails;
              return ListView.builder(
                padding: MySpaces.listViewTopPadding,
                itemCount: numberOfCategories,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => CategoryFunctions.viewMoreOptions(
                      context: context,
                      model: model,
                      myCategory: _myCategories[index],
                      offset: tapDownDetails.globalPosition,
                    ),
                    onTapDown: (details) => tapDownDetails = details,
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
