import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/state/habitoModel.dart';

mixin AuthModel on ModelData {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<HabitoAuth> checkIfSignedIn(
      {bool emailAuth: false, bool sendEmail: false}) async {
    if (isDevTesting) return HabitoAuth.SUCCESS;
    try {
      firebaseUser = await firebaseAuth.currentUser();
      if (firebaseUser != null) {
        if (emailAuth && !firebaseUser.isEmailVerified) {
          if (sendEmail) await firebaseUser.sendEmailVerification();
          logAnalyticsEvent(AnalyticsEvents.authSentVerificationEmail);
          return HabitoAuth.VERIFICATION_REQUIRED;
        }
        logAnalyticsEvent(AnalyticsEvents.authSignIn, success: true);
        return HabitoAuth.SUCCESS;
      }
      return HabitoAuth.NO_USER;
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignIn,
        success: false,
        error: e.toString(),
      );
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signOut() async {
    if (isDevTesting) return HabitoAuth.SIGNED_OUT;
    try {
      await firebaseAuth.signOut();
      logAnalyticsEvent(AnalyticsEvents.authSignOut, success: true);
      return HabitoAuth.SIGNED_OUT;
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignOut,
        success: false,
        error: e.toString(),
      );
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> deleteAccount(BuildContext context) async {
    if (isDevTesting) return HabitoAuth.DELETED;
    try {
      await firebaseUser.delete();
      logAnalyticsEvent(AnalyticsEvents.authDeleteAccount, success: true);
      return HabitoAuth.DELETED;
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authDeleteAccount,
        success: false,
        error: e.code,
      );
      handleAuthError(context, e);
      await signOut();
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signIn(
      BuildContext context, String email, String password) async {
    if (isDevTesting) {
      return HabitoAuth.SUCCESS;
    }
    try {
      firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return (await checkIfSignedIn(emailAuth: true, sendEmail: true));
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignIn,
        success: false,
        error: e.code,
      );
      handleAuthError(context, e);
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signUp(
      BuildContext context, String email, String password) async {
    if (isDevTesting) return HabitoAuth.SUCCESS;
    try {
      firebaseUser = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      logAnalyticsEvent(
        AnalyticsEvents.authSignUp,
        success: true,
      );
      return (await checkIfSignedIn(emailAuth: true, sendEmail: true));
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignUp,
        success: false,
        error: e.code,
      );
      handleAuthError(context, e);
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> requestPasswordReset(
      BuildContext context, String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      logAnalyticsEvent(
        AnalyticsEvents.authPasswordReset,
        success: true,
      );
      return HabitoAuth.SUCCESS;
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authPasswordReset,
        success: true,
        error: e.code,
      );
      handleAuthError(context, e);
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      logAnalyticsEvent(
        AnalyticsEvents.authSignInWithGoogle,
        success: true,
      );
      return (await checkIfSignedIn());
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignInWithGoogle,
        success: false,
        error: e.code,
      );
      handleAuthError(context, e);
      await signOut();
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signInWithFacebook(
      BuildContext context, String token) async {
    try {
      final facebookAuthCredential =
          FacebookAuthProvider.getCredential(accessToken: token);
      await firebaseAuth.signInWithCredential(facebookAuthCredential);
      logAnalyticsEvent(
        AnalyticsEvents.authSignInWithFacebook,
        success: true,
      );
      return (await checkIfSignedIn());
    } catch (e) {
      logAnalyticsEvent(
        AnalyticsEvents.authSignInWithFacebook,
        success: false,
        error: e.code,
      );
      handleAuthError(context, e);
      await signOut();
      return HabitoAuth.FAIL;
    }
  }

  void handleAuthError(context, e) {
    String title = "Try Again";
    String body = "Cannot carry out authentication right now.";
    if (MyStrings.authErrors.containsKey(e.code)) {
      body = MyStrings.authErrors[e.code];
    }
    UniversalFunctions.showAlert(context, title, body);
  }
}
