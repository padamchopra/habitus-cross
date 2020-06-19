import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habito/functions/universalFunctions.dart';
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
          return HabitoAuth.VERIFICATION_REQUIRED;
        }
        return HabitoAuth.SUCCESS;
      }
      return HabitoAuth.NO_USER;
    } catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signOut() async {
    if (isDevTesting) return HabitoAuth.SIGNED_OUT;
    try {
      await firebaseAuth.signOut();
      return HabitoAuth.SIGNED_OUT;
    } catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> deleteAccount(BuildContext context) async {
    if (isDevTesting) return HabitoAuth.DELETED;
    try {
      await firebaseUser.delete();
      return HabitoAuth.DELETED;
    } catch (e) {
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
      return (await checkIfSignedIn(emailAuth: true, sendEmail: true));
    } catch (e) {
      handleAuthError(context, e);
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> requestPasswordReset(
      BuildContext context, String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return HabitoAuth.SUCCESS;
    } catch (e) {
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
      return (await checkIfSignedIn());
    } catch (e) {
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
      return (await checkIfSignedIn());
    } catch (e) {
      handleAuthError(context, e);
      await signOut();
      return HabitoAuth.FAIL;
    }
  }

  void handleAuthError(context, e) {
    String title = "Try Again";
    String body = "Cannot carry out authentication in right now.";
    if (MyStrings.authErrors.containsKey(e.code)) {
      body = MyStrings.authErrors[e.code];
    }
    UniversalFunctions.showAlert(context, title, body);
  }
}
