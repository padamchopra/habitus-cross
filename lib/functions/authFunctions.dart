import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/signup.dart';
import 'package:habito/state/habitoModel.dart';

class AuthFunctions {
  static void signInWithPassword(
    BuildContext context,
    HabitoModel model,
    String email,
    String password,
  ) async {
    HabitoAuth signedInResult = await model.signIn(context, email, password);
    if (signedInResult == HabitoAuth.SUCCESS) {
      await model.fetchUserData();
      model.updateUserState();
    } else if (signedInResult == HabitoAuth.VERIFICATION_REQUIRED) {
      UniversalFunctions.showAlert(
        context,
        MyStrings.signInHeading[0],
        MyStrings.signInBody[0],
      );
    }
  }

  static void signUpWithPassword(
    BuildContext context,
    HabitoModel model,
    String email,
    String password,
  ) async {
    HabitoAuth signUpResult = await model.signUp(context, email, password);
    if (signUpResult == HabitoAuth.VERIFICATION_REQUIRED) {
      UniversalFunctions.showAlert(
        context,
        MyStrings.signUpHeading[0],
        MyStrings.signUpBody[0],
      ).then((value) =>
          model.signOut().whenComplete(() => Navigator.of(context).pop()));
    }
  }

  static void forgotPasswordWithEmail(
      BuildContext context, HabitoModel model, String email) async {
    HabitoAuth requestResult = await model.requestPasswordReset(context, email);
    if (requestResult == HabitoAuth.SUCCESS) {
      UniversalFunctions.showAlert(
        context,
        MyStrings.signInHeading[2],
        MyStrings.signInBody[2],
      );
    }
  }

  static void signInWithGoogle(BuildContext context, HabitoModel model) async {
    HabitoAuth result = await model.signInWithGoogle(context);
    if (result == HabitoAuth.SUCCESS) {
      await model.fetchUserData();
      model.updateUserState();
    }
  }

  static void signInWithFacebook(
      BuildContext context, HabitoModel model) async {
    String appId = "724863751416279";
    String redirectUrl = "https://www.facebook.com/connect/login_success.html";
    String token = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$appId&redirect_uri=$redirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: false),
    );

    HabitoAuth result;
    if (token != null) {
      result = await model.signInWithFacebook(context, token);
    }
    if (result != null && result == HabitoAuth.SUCCESS) {
      await model.fetchUserData();
      model.updateUserState();
    }
  }

  static void redirectToSignUp(BuildContext context, HabitoModel model) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Signup(model)));
  }

  static bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }
}

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        clearCache: true,
        clearCookies: true,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ));
  }
}
