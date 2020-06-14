import 'package:flutter/material.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/general/infoSet.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_redirect/store_redirect.dart';

class Profile extends StatelessWidget {
  Profile();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HabitoModel>(
      builder: (BuildContext context, Widget child, HabitoModel model) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const PageHeading("Profile"),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(25),
                children: <Widget>[
                  InfoSet(
                    "Email",
                    model.userEmail,
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    "Categories",
                    model.myCategoriesList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    "Active Habits",
                    model.myHabitsList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    "Tracked Habits",
                    model.myCompletedHabitsList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    "Sort by (more coming soon)",
                    "Old -> New",
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: MyColors.midnight,
                      onPressed: () {
                        StoreRedirect.redirect(
                          androidAppId: "me.padamchopra.habito",
                          iOSAppId: "1516750469",
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText(
                          "Review",
                          alternateFont: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      color: MyColors.midnight,
                      onPressed: () async {
                        await model.signOut();
                        await model.showAlert(
                            context, "Signing Out", "Thanks for using Habito!");
                        model.updateUserState();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText(
                          "Logout",
                          alternateFont: true,
                        ),
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
