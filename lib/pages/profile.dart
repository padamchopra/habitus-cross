import 'package:flutter/material.dart';
import 'package:habito/models/analytics.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/general/pageHeading.dart';
import 'package:habito/widgets/generalInfo.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store_redirect/store_redirect.dart';

class Profile extends StatelessWidget {
  final Function updateUserState;
  Profile(this.updateUserState);

  @override
  Widget build(BuildContext context) {
    Analytics.sendAnalyticsEvent(Analytics.profileOpened);
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
                      color: MyColors.midnight,
                      onPressed: () {
                        Analytics.sendAnalyticsEvent(
                            Analytics.storeReviewOpened);
                        StoreRedirect.redirect(
                          androidAppId: "me.padamchopra.habito",
                          iOSAppId: "1516750469",
                        );
                      },
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
                      color: MyColors.midnight,
                      onPressed: () async {
                        Analytics.sendAnalyticsEvent(Analytics.authSignOut);
                        await model.signOut();
                        await model.neverSatisfied(
                            context, "Signing Out", "Thanks for using Habito!");
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
