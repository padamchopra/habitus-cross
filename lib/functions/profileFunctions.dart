import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:store_redirect/store_redirect.dart';

class ProfileFunctions {
  static void reviewApp() {
    StoreRedirect.redirect(
      androidAppId: "me.padamchopra.habito",
      iOSAppId: "1516750469",
    );
  }

  static void signOut(BuildContext context, HabitoModel model) {
    UniversalFunctions.showActionDialog(
      context: context,
      title: MyStrings.logoutHeading,
      description: MyStrings.logoutBody,
      positiveCallback: () async {
        await model.signOut();
        model.updateUserState();
      },
      positiveLabel: "Sign Out",
      otherCallback: () {},
      otherLabel: "Cancel",
    );
  }

  static void deleteAccount(BuildContext context, HabitoModel model) {
    UniversalFunctions.showActionDialog(
      context: context,
      title: MyStrings.deleteAccountHeading,
      description: MyStrings.deleteAccountBody,
      positiveCallback: () async {
        HabitoAuth deletionResult = await model.deleteAccount(context);
        if (deletionResult == HabitoAuth.DELETED) {
          UniversalFunctions.showAlert(
            context,
            "Account deleted",
            "We hate to see you go. Good luck!",
          );
        }
        model.updateUserState();
      },
      positiveLabel: "Delete",
      otherCallback: () {},
      otherLabel: "Cancel",
      positiveIsNegative: true,
    );
  }
}
