import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  static Future<void> sendAnalyticsEvent(String eventName) async {
    print("Analytics Event: $eventName");
    switch (eventName) {
      case appOpened:
        await _firebaseAnalytics.logAppOpen();
        break;
      case authLoginSuccess:
        await _firebaseAnalytics.logLogin();
        break;
      case authSignUpSuccess:
        await _firebaseAnalytics.logSignUp(signUpMethod: 'Email and Password');
        break;
      default:
        await _firebaseAnalytics.logEvent(name: eventName);
        break;
    }
  }

  static const String appOpened = "Habito Opened";
  static const String storeReviewOpened = "Store Review Opened";
  static const String categoriesOpened = "Categories Screen";
  static const String habitsOpened = "Habits Screen";
  static const String homeOpened = "Home Screen";
  static const String loginOpened = "Login Screen";
  static const String signUpOpened = "Sign Up Screen";
  static const String profileOpened = "Profile Screen";

  static const String authVerifyNeeded = "Auth: Verification Needed";
  static const String authLoginSuccess = "Auth: Login Success";
  static const String authLoginFailure = "Auth: Login Failure";
  static const String authPasswordReset = "Auth: Password Reset";
  static const String authSignUpSuccess = "Auth: Sign Up Success";
  static const String authSignUpFailure = "Auth: Sign Up Failure";
  static const String authSignOut = "Auth: Sign Out";

  static const String addNewModalClicked = "Add: Modal opened";
  static const String addNewHabit = "Add: Habit";
  static const String addNewCategory = "Add: Category";

  static const String habitCompleted = "Habit: Complete";

  static const String categoryOptionToViewHabits =
      "Category Option: View Habits";
  static const String categoryOptionToEdit = "Category Option: Edit";
  static const String categoryOptionToDuplicate = "Category Option: Duplicate";
  static const String categoryOptionToDelete = "Category Option: Delete";

  static const String habitOptionsToggled = "Habit Options Toggled";
  static const String habitOptionToMarkDone = "Habit Option: Mark Done";
  static const String habitOptionToView = "Habit Option: View";
  static const String habitOptionToMoreOptions = "Habit Option: More Options";
  static const String habitOptionToDuplicate = "Habit Option: Duplicate";
  static const String habitOptionToResetProgress = "Habit Option: Reset";
  static const String habitOptionToDelete = "Habit Option: Delete";
}
