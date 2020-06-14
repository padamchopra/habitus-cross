import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/signup.dart';
import 'package:habito/widgets/auth/blueButton.dart';
import 'package:habito/widgets/auth/darkTextField.dart';
import 'package:habito/widgets/auth/googleSignIn.dart';
import 'package:habito/widgets/background.dart';
import 'package:habito/widgets/text.dart';

class SignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final HabitoModel model;
  SignIn(this.model);

  @override
  Widget build(BuildContext context) {
    String email = "", password = "";
    var ruler = Container(
      width: 30,
      height: 1,
      color: MyColors.placeholderGrey,
    );

    return Stack(
      children: <Widget>[
        Background(MyColors.black),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: MySpaces.screenBorder,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  MyStrings.appName,
                  fontSize: 54,
                  fontWeight: FontWeight.w700,
                  alternateFont: true,
                ),
                MySpaces.largeGapInBetween,
                DarkTextField(
                  focusNode: _focusNode1,
                  hint: MyStrings.emailLabel,
                  validator: (_email) {
                    if (EmailValidator.validate(_email)) {
                      email = _email;
                      return null;
                    } else {
                      return MyStrings.emailError;
                    }
                  },
                  onSave: (_) {},
                  inputType: TextInputType.emailAddress,
                  nextFocusNode: _focusNode2,
                  icon: Icons.alternate_email,
                ),
                MySpaces.gapInBetween,
                DarkTextField(
                  focusNode: _focusNode2,
                  hint: MyStrings.passwordLabel,
                  validator: (_) {},
                  onSave: (_password) => password = _password,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                MySpaces.mediumGapInBetween,
                BlueButton(
                  label: MyStrings.signinLabel,
                  onPress: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      HabitoAuth signedInResult =
                          await model.signIn(email, password);
                      if (signedInResult == HabitoAuth.SUCCESS) {
                        await model.fetchUserData();
                        model.updateUserState();
                      } else {
                        int index = 1;
                        if (signedInResult ==
                            HabitoAuth.VERIFICATION_REQUIRED) {
                          index = 0;
                        }
                        model.showAlert(
                          context,
                          MyStrings.signInHeading[index],
                          MyStrings.signInBody[index],
                        );
                      }
                    }
                  },
                ),
                MySpaces.gapInBetween,
                CustomText(
                  "Forgot Password?",
                  color: MyColors.captionWhite,
                  fontSize: 15,
                  alternateFont: true,
                  textAlign: TextAlign.end,
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      model.requestPasswordReset(email).then((value) {
                        model.showAlert(
                          context,
                          MyStrings.signInHeading[2],
                          MyStrings.signInBody[2],
                        );
                      });
                    }
                  },
                ),
                MySpaces.largeGapInBetween,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ruler,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomText(
                        "OR SIGN IN WITH",
                        color: MyColors.captionWhite,
                        fontSize: 12,
                        alternateFont: true,
                      ),
                    ),
                    ruler,
                  ],
                ),
                MySpaces.gapInBetween,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GoogleSignInButton(
                      width: MediaQuery.of(context).size.width / 3,
                      signIn: () => model.signInWithGoogle(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: Platform.isIOS ? 42 : 24),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signup()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    "Don't have an account? ",
                    fontSize: 17,
                  ),
                  CustomText(
                    "Sign Up",
                    color: MyColors.perfectBlue,
                    fontSize: 17,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
