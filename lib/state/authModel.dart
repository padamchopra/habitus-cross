import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/state/habitoModel.dart';

mixin AuthModel on ModelData {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<HabitoAuth> checkIfSignedIn({bool sendEmail: false}) async {
    if (isDevTesting) return HabitoAuth.SUCCESS;
    try {
      firebaseUser = await firebaseAuth.currentUser();
      if (firebaseUser != null) {
        if (firebaseUser.providerId == "password" && !firebaseUser.isEmailVerified){
          if (sendEmail) await firebaseUser.sendEmailVerification();
          return HabitoAuth.VERIFICATION_REQUIRED;
        }
        return HabitoAuth.SUCCESS;
      }
      return HabitoAuth.NO_USER;
    } on Exception catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signOut() async {
    if (isDevTesting) return HabitoAuth.SIGNED_OUT;
    try {
      await firebaseAuth.signOut();
      return HabitoAuth.SIGNED_OUT;
    } on Exception catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signIn(String email, String password) async {
    if (isDevTesting) {
      return HabitoAuth.SUCCESS;
    }
    try {
      firebaseUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return (await checkIfSignedIn(sendEmail: true));
    } on Exception catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signUp(String email, String password) async {
    if (isDevTesting) return HabitoAuth.SUCCESS;
    try {
      firebaseUser = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      return (await checkIfSignedIn(sendEmail: true));
    } on Exception catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> requestPasswordReset(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return HabitoAuth.SUCCESS;
    } on Exception catch (_) {
      return HabitoAuth.FAIL;
    }
  }

  Future<HabitoAuth> signInWithGoogle() async {
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
      return HabitoAuth.FAIL;
    }
  }

}
