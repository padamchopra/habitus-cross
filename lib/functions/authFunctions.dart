import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/signup.dart';
import 'package:habito/state/habitoModel.dart';

class AuthFunctions {
  static void signInWithPassword(
    BuildContext context,
    HabitoModel model,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      HabitoAuth signedInResult = await model.signIn(email, password);
      if (signedInResult == HabitoAuth.SUCCESS) {
        await model.fetchUserData();
        model.updateUserState();
      } else {
        int index = 1;
        if (signedInResult == HabitoAuth.VERIFICATION_REQUIRED) {
          index = 0;
        }
        UniversalFunctions.showAlert(
          context,
          MyStrings.signInHeading[index],
          MyStrings.signInBody[index],
        );
      }
    }
  }

  static void signUpWithPassword(
    BuildContext context,
    HabitoModel model,
    GlobalKey<FormState> formKey,
    String email,
    String password,
  ) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      HabitoAuth signUpResult = await model.signUp(email, password);
      if (signUpResult == HabitoAuth.SUCCESS) {
        UniversalFunctions.showAlert(
          context,
          MyStrings.signUpHeading[0],
          MyStrings.signUpBody[0],
        ).then((_) {
          model.signOut().whenComplete(() => Navigator.of(context).pop());
        });
      } else {
        UniversalFunctions.showAlert(
          context,
          MyStrings.signUpHeading[1],
          MyStrings.signUpBody[1],
        );
        Navigator.of(context).pop();
      }
    }
  }

  static void forgotPasswordWithEmail(BuildContext context, HabitoModel model,
      GlobalKey<FormState> formKey, String email) {
    if (formKey.currentState.validate()) {
      model.requestPasswordReset(email).then((value) {
        UniversalFunctions.showAlert(
          context,
          MyStrings.signInHeading[2],
          MyStrings.signInBody[2],
        );
      });
    }
  }

  static void signInWithGoogle(HabitoModel model) {
    model.signInWithGoogle();
  }

  static void redirectToSignUp(BuildContext context, HabitoModel model) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Signup(model)));
  }

  static bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }
}
