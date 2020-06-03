import 'package:flutter/material.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/generalInfo.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_redirect/store_redirect.dart';

class Profile extends StatelessWidget {
  final Function updateUserState;
  Profile(this.updateUserState);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HabitoModel>(
      builder: (BuildContext context, Widget child, HabitoModel model) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: UniversalValues.topPaddingBeforeHeading,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: UniversalValues.headingHorizontalMargin),
              child: CustomText(
                "Profile",
                color: HabitoColors.white,
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
              child: ListView(
                padding: EdgeInsets.all(25),
                children: <Widget>[
                  GeneralInfo(
                    "Email",
                    model.userEmail,
                  ),
                  SizedBox(height: 20),
                  GeneralInfo(
                    "Categories",
                    model.myCategoriesList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  GeneralInfo(
                    "Active Habits",
                    model.myHabitsList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  GeneralInfo(
                    "Tracked Habits",
                    model.myHabitsCompletedList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  GeneralInfo(
                    "Sort by (more coming soon)",
                    "Old -> New",
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: HabitoColors.midnight,
                      onPressed: () => StoreRedirect.redirect(),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText("Review"),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: HabitoColors.midnight,
                      onPressed: () async {
                        await model.signOut();
                        await model.neverSatisfied(context, "Signing Out", "Thanks for using Habito!");
                        updateUserState();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText("Logout"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
