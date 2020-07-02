import 'package:flutter/material.dart';
import 'package:habito/functions/profileFunctions.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/general/CustomButton.dart';
import 'package:habito/widgets/general/infoSet.dart';
import 'package:habito/widgets/general/itemPicker.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class Profile extends StatelessWidget {
  final List<String> sortingOptions = [
    "Old -> New",
    "A -> Z",
    "Days Completed",
    "Categories"
  ];

  Widget buildPickerWidget(String optionName) {
    return CustomText(
      optionName,
      fontSize: 18,
      color: Colors.black,
      alternateFont: true,
    );
  }

  Widget buildIOSDefaultWidget(String label) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: MyColors.midnight,
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CustomText(
              label,
              fontSize: 18,
              alternateFont: true,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_drop_down,
              color: MyColors.placeholderGrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HabitoModel>(
      builder: (BuildContext context, Widget child, HabitoModel model) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const PageHeading(MyStrings.profilePageHeading),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(25),
                children: <Widget>[
                  InfoSet(
                    MyStrings.emailLabel,
                    model.userEmail,
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.categoriesInfoTitle,
                    model.myCategories.length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.activeHabitsInfoTitle,
                    model.myHabitsAsList(false).length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.trackedHabitsInfoTitle,
                    model.myHabitsAsList(true).length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  CustomText(
                    MyStrings.sortInfoTitle,
                    color: MyColors.captionWhite,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  ItemPicker(
                    context: context,
                    newValueAssigned: (String sortBy) {
                      model.updateSortingMethod(context, sortBy);
                    },
                    options: sortingOptions,
                    buildPickerWidget: buildPickerWidget,
                    buildIOSDefaultWidget: buildIOSDefaultWidget,
                    defaultValue: model.sortingHabitsByDefaultName,
                  ),
                  MySpaces.largeGapInBetween,
                  CustomButton(
                    label: MyStrings.reviewButton,
                    onPress: ProfileFunctions.reviewApp,
                    color: MyColors.midnight,
                  ),
                  MySpaces.gapInBetween,
                  CustomButton(
                    label: MyStrings.signoutButton,
                    onPress: () => ProfileFunctions.signOut(context, model),
                    color: MyColors.midnight,
                  ),
                  MySpaces.gapInBetween,
                  CustomButton(
                    label: "Delete Account",
                    onPress: () =>
                        ProfileFunctions.deleteAccount(context, model),
                    color: MyColors.perfectRed,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
