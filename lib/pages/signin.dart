import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habito/functions/authFunctions.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/auth/blueButton.dart';
import 'package:habito/widgets/auth/darkTextField.dart';
import 'package:habito/widgets/auth/OAuthButton.dart';
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
                  letterSpacing: -1,
                ),
                MySpaces.largeGapInBetween,
                DarkTextField(
                  focusNode: _focusNode1,
                  hint: MyStrings.emailLabel,
                  validator: (_email) {
                    if (AuthFunctions.validateEmail(_email)) {
                      email = _email;
                      return null;
                    }
                    return MyStrings.emailError;
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
                  label: MyStrings.signInLabel,
                  onPress: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      AuthFunctions.signInWithPassword(
                          context, model, email, password);
                    }
                  },
                ),
                MySpaces.gapInBetween,
                CustomText(
                  MyStrings.forgotPasswordLabel,
                  color: MyColors.captionWhite,
                  fontSize: 15,
                  alternateFont: true,
                  textAlign: TextAlign.end,
                  onTap: () {
                    if(_formKey.currentState.validate()){
                      AuthFunctions.forgotPasswordWithEmail(
                      context, model, email);
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
                        MyStrings.alternateAuthHeader,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    OAuthButton(
                      assetName: 'google',
                      label: MyStrings.googleLabel,
                      width: MediaQuery.of(context).size.width / 2.6,
                      signIn: () =>
                          AuthFunctions.signInWithGoogle(context, model),
                    ),
                    OAuthButton(
                      assetName: 'facebook',
                      label: MyStrings.facebookLabel,
                      width: MediaQuery.of(context).size.width / 2.6,
                      signIn: () =>
                          AuthFunctions.signInWithFacebook(context, model),
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
              onTap: () => AuthFunctions.redirectToSignUp(context, model),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    MyStrings.noAccountLabel,
                    fontSize: 17,
                  ),
                  CustomText(
                    MyStrings.signUpLabel,
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
