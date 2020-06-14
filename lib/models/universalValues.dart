import 'package:flutter/material.dart';

class UniversalValues {
  static const double plusIconSize = 40;
  //margin and paddings region start
  static const double headingHorizontalMargin = 30;
  //region end

  //font properties region start
  static const double headingFontSize = 45;
  //region end

  //habit options region starts
  static const EdgeInsets marginForHabitFirstOption = EdgeInsets.only(left: 0);
  static const EdgeInsets marginForHabitSecondOption =
      EdgeInsets.only(left: 42);
  static const EdgeInsets marginForHabitThirdOption = EdgeInsets.only(left: 84);
  static const EdgeInsets marginForParentOption = EdgeInsets.only(right: 42);
  //region end
}

class MySpaces {
  static const EdgeInsets listViewTopPadding = EdgeInsets.only(top: 9);
  static const double topPaddingBeforeHeading = 66;
  static const double screenBorder = 15;
  static const Widget gapInBetween = SizedBox(height: 15);
  static const Widget mediumGapInBetween = SizedBox(height: 30);
  static const Widget largeGapInBetween = SizedBox(height: 42);
}

class MyColors {
  static const Color transparent = Colors.transparent;

  static const Color white = Colors.white;
  static const Color almostWhite = Color(0xfffafafa);
  static const Color captionWhite = Colors.white54;

  static const Color black = Colors.black;
  static const Color backdropBlack = Colors.black12;
  static const Color midnight = Color(0xff1F2024);

  static const Color darkTextFieldBackground = Color(0xff2c2b2e);
  static const Color placeholderGrey = Color(0xff636363);
  static const Color ruler = Color(0x80636363);

  static Color buttonBlueBackground = Colors.blue.withAlpha(50);
  static const Color labelBackground = Colors.white10;

  static const Color perfectBlue = Colors.blue;
  static const Color perfectRed = Colors.red;

  static const Color categoryPaletteOne = Colors.orange;
  static const Color categoryPaletteTwo = Colors.deepOrange;
  static const Color categoryPaletteThree = Colors.pink;
  static const Color categoryPaletteFour = Colors.purple;
  static const Color categoryPaletteFive = Colors.deepPurple;
  static const Color categoryPaletteSix = Colors.indigo;
  static const List<Color> standardColorsList = [
    perfectBlue,
    categoryPaletteOne,
    categoryPaletteTwo,
    categoryPaletteThree,
    categoryPaletteFour,
    categoryPaletteFive,
    categoryPaletteSix
  ];

  static const Color habitOption = Colors.white;
  static const Color success = Colors.green;
}

class MyStrings {
  static const appName = "Habito.";

  //auth region starts
  static const signinLabel = "Sign In";
  static const emailLabel = "Email";
  static const passwordLabel = "Password";
  static const emailError = "Invalid email";
  static const googleLabel = "Google";
  //region ends

  //alert strings region starts
  static const deleteCategoryHeading = ["Deleted", "Try Again"];
  static const deleteCategoryBody = [
    "This category has been deleted and child habits unlinked.",
    "This category could not be deleted."
  ];
  static const signInHeading = ["Verify", "Incorrect Login", "Check Email"];
  static const signInBody = [
    "Please verify your email to proceed.",
    "Please re-check your details and try again.",
    "Please check your email to reset your password."
  ];
  static const signUpHeading = ["Verify", "Try Again"];
  static const signUpBody = [
    "We've sent you a verification email to the id you provided.",
    "We could not sign you up at the moment. Sorry for the trouble."
  ];
  static const newFeatureTeaseHeading = "Coming Soon!";
  static const newFeatureTeaseBody =
      "New features coming soon! Write a review from profile to request something.";
  //alert strings region ends

  static const noCategoriesMessage =
      "No categories yet.\nCreate one now by tapping +";
  static const noCompletedHabitsMessage = "No habits have been completed yet.";
  static const noHabitsMessage =
      "Start tracking a habit you want \nto develop by tapping +";
}
