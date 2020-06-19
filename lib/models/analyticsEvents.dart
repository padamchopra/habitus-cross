class AnalyticsEvents {
  static const String appOpened = "Habito: App Opened";
  
  static const String authSentVerificationEmail =
      "Auth: Verification Email Sent";
  static const String authSignIn = "Auth: Sign in";
  static const String authSignInWithGoogle = "Auth: Sign in with Google";
  static const String authSignInWithFacebook = "Auth: Sign in with Facebook";
  static const String authPasswordReset = "Auth: Password Reset";
  static const String authSignUp = "Auth: Sign Up";
  static const String authSignOut = "Auth: Sign Out";
  static const String authDeleteAccount = "Auth: Delete Account";

  static const String categoryFetch = "Category: Fetch";
  static const String categoryNew = "Category: New";
  static const String categoryUpdate = "Category: Update";
  static const String categoryDelete = "Category: Delete";

  static const String habitFetch = "Habit: Fetch";
  static const String habitNew = "Habit: New";
  static const String habitUpdate = "Habit: Update";
  static const String habitCompletedDelete = "Habit: Delete Completed";
  static const String habitDelete = "Habit: Delete";
  static const String habitCompletedReset = "Habit: Reset Progress for completed";
  static const String habitReset = "Habit: Reset Progress";
  static const String habitMarkDoneForToday = "Habit: Log Day";
  static const String habitMarkComplete = "Habit: Log Complete";
}
