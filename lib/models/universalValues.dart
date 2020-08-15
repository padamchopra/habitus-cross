import 'package:flutter/material.dart';

class UniversalValues {
  static const double plusIconSize = 40;
  static const double headingFontSize = 45;
}

class MySpaces {
  static const EdgeInsets listViewTopPadding = EdgeInsets.only(
    top: 9,
    bottom: 18,
  );
  static const double topPaddingBeforeHeading = 81;
  static const double headingHorizontalMargin = 30;
  static const double screenBorder = 15;
  static const Widget gapInBetween = SizedBox(height: 15);
  static const Widget mediumGapInBetween = SizedBox(height: 30);
  static const Widget largeGapInBetween = SizedBox(height: 42);

  //habit option spacing
  static const EdgeInsets marginForHabitFirstOption = EdgeInsets.only(left: 0);
  static const EdgeInsets marginForHabitSecondOption =
      EdgeInsets.only(left: 42);
  static const EdgeInsets marginForHabitThirdOption = EdgeInsets.only(left: 84);
  static const EdgeInsets marginForParentOption = EdgeInsets.only(right: 42);
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

  static const Color alertBlue = Color(0xff027AFE);
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
  static const appName = "Habitus.";

  //auth region starts
  static const signInLabel = "Sign In";
  static const signUpLabel = "Sign Up";
  static const signUpPageHeading = "Join Habito.";
  static const emailLabel = "Email";
  static const passwordLabel = "Password";
  static const confirmPasswordLabel = "Confirm Password";
  static const emailError = "Invalid email";
  static const passwordLengthError = "Password too short.";
  static const passwordMismatchError = "Passwords do not match";
  static const googleLabel = "Google";
  static const facebookLabel = "Facebook";
  static const forgotPasswordLabel = "Forgot Password?";
  static const alternateAuthHeader = "OR SIGN IN WITH";
  static const noAccountLabel = "Don't have an account? ";
  static const alreadyAnAccountLabel = "Already have an account? ";
  //auth region ends

  //categories region starts
  static const categoriesPageHeading = "Categories";
  static const noCategoriesMessage =
      "No categories found.\nCreate one now by tapping +";
  static const previewLabel = "-- Preview --";
  //categories region ends

  //habits region starts
  static const habitsPageHeading = "Habits";
  static const completedHabitsPageHeading = "Tracked";
  static const noCompletedHabitsMessage = "No active habits completed.";
  static const noHabitsMessage =
      "Start tracking a habit you want \nto develop by tapping +";
  //habits region ends

  //profile region starts
  static const profilePageHeading = "Profile";
  static const categoriesInfoTitle = "Categories";
  static const activeHabitsInfoTitle = "Active Habits";
  static const trackedHabitsInfoTitle = "Tracked Habits";
  static const sortInfoTitle = "Sort habits by";
  static const reviewButton = "Review App";
  static const signoutButton = "Sign Out";
  //profile region ends

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
  static const authErrors = {
    'ERROR_INVALID_CREDENTIAL':
        'Invalid credentials. Please check your details again.',
    'ERROR_USER_DISABLED':
        'Looks like your account is disabled. Contact us at jb.padamchopra@gmail.com.',
    'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        'Looks like you are already registered with a different authentication provider.',
    'ERROR_OPERATION_NOT_ALLOWED':
        'Signing in with this provider is no longer allowed.',
    'ERROR_WEAK_PASSWORD': 'Your password is too weak.',
    'ERROR_INVALID_EMAIL': 'Your email is invalid.',
    'ERROR_EMAIL_ALREADY_IN_USE':
        'Your email is already being used by an account. Reach out at jb.padamchopra@gmail.com',
    'ERROR_WRONG_PASSWORD': 'Invalid credentials.',
    'ERROR_USER_NOT_FOUND':
        'No account with this email address was found. Try signing up.',
    'ERROR_TOO_MANY_REQUESTS': 'Too many login requests were made.',
    'ERROR_REQUIRES_RECENT_LOGIN':
        'We need to reauthenticate you. Please login again.'
  };
  static const signUpHeading = ["Verify", "Try Again"];
  static const signUpBody = [
    "We've sent you a verification email to the id you provided.",
    "We could not sign you up at the moment. Sorry for the trouble."
  ];
  static const newFeatureTeaseHeading = "Coming Soon!";
  static const newFeatureTeaseBody =
      "New features coming soon! Write a review from profile to request something.";

  static const logoutHeading = "Sign Out?";
  static const logoutBody =
      "You can always access your content by signing back in.";

  static const deleteAccountHeading = "Are you sure?";
  static const deleteAccountBody =
      "You will not be able to retrieve your saved details or account later.";

  //alert strings region ends

}
