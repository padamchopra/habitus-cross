import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
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
            const PageHeading(MyStrings.profilePageHeading),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(25),
                children: <Widget>[
                  InfoSet(
                    MyStrings.emailLabel,
                    model.userEmail,
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    MyStrings.categoriesInfoTitle,
                    model.myCategoriesList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    MyStrings.activeHabitsInfoTitle,
                    model.myHabitsList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    MyStrings.trackedHabitsInfoTitle,
                    model.myCompletedHabitsList.length.toString(),
                  ),
                  SizedBox(height: 20),
                  InfoSet(
                    MyStrings.trackedHabitsInfoTitle,
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
                          MyStrings.reviewButton,
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
                        await UniversalFunctions.showAlert(
                            context, MyStrings.logoutHeading, MyStrings.logoutBody);
                        model.updateUserState();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText(
                          MyStrings.logoutButton,
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
