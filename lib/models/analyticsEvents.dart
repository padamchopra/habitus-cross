class AnalyticsEvents {
  static const String appOpened = "Habito_App_Opened";
  
  static const String authSentVerificationEmail =
      "Auth_Verification_Email_Sent";
  static const String authSignIn = "Auth_Sign_in";
  static const String authSignInWithGoogle = "Auth_Sign_in_with_Google";
  static const String authSignInWithFacebook = "Auth_Sign_in_with_Facebook";
  static const String authPasswordReset = "Auth_Password_Reset";
  static const String authSignUp = "Auth_Sign_Up";
  static const String authSignOut = "Auth_Sign_Out";
  static const String authDeleteAccount = "Auth_Delete_Account";

  static const String categoryFetch = "Category_Fetch";
  static const String categoryNew = "Category_New";
  static const String categoryUpdate = "Category_Update";
  static const String categoryDelete = "Category_Delete";

  static const String habitFetch = "Habit_Fetch";
  static const String habitNew = "Habit_New";
  static const String habitUpdate = "Habit_Update";
  static const String habitDelete = "Habit_Delete";
  static const String habitReset = "Habit_Reset_Progress";
  static const String habitMarkDoneForToday = "Habit_Log_Day";
  static const String habitMarkComplete = "Habit_Log_Complete";
}
