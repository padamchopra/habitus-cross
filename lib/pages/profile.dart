import 'package:flutter/material.dart';
import 'package:habito/functions/profileFunctions.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/general/CustomButton.dart';
import 'package:habito/widgets/general/infoSet.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:scoped_model/scoped_model.dart';

class Profile extends StatelessWidget {
  Profile();

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
                    model.myCategoriesList.length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.activeHabitsInfoTitle,
                    model.myHabitsList.length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.trackedHabitsInfoTitle,
                    model.myCompletedHabitsList.length.toString(),
                  ),
                  MySpaces.gapInBetween,
                  InfoSet(
                    MyStrings.trackedHabitsInfoTitle,
                    "Old -> New",
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
