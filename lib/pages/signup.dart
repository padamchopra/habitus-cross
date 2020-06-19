import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/authFunctions.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/auth/darkTextField.dart';
import 'package:habito/widgets/background.dart';
import 'package:habito/widgets/general/CustomButton.dart';
import 'package:habito/widgets/text.dart';

class Signup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = new FocusNode();
  final _focusNode2 = new FocusNode();
  final _focusNode3 = new FocusNode();
  final HabitoModel model;
  Signup(this.model);

  @override
  Widget build(BuildContext context) {
    String email, password;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: MyColors.almostWhite,
      body: Stack(
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
                    MyStrings.signUpPageHeading,
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
                        return null;
                      }
                      return MyStrings.emailError;
                    },
                    onSave: (_email) => email = _email,
                    inputType: TextInputType.emailAddress,
                    nextFocusNode: _focusNode2,
                    icon: Icons.alternate_email,
                  ),
                  MySpaces.gapInBetween,
                  DarkTextField(
                    focusNode: _focusNode2,
                    nextFocusNode: _focusNode3,
                    hint: MyStrings.passwordLabel,
                    validator: (_password) {
                      if (_password.length >= 6) {
                        password = _password;
                        return null;
                      }
                      return MyStrings.passwordLengthError;
                    },
                    onSave: (_) {},
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  MySpaces.gapInBetween,
                  DarkTextField(
                    focusNode: _focusNode3,
                    hint: MyStrings.confirmPasswordLabel,
                    validator: (_password) => password == _password
                        ? null
                        : MyStrings.passwordMismatchError,
                    onSave: (_) {},
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  MySpaces.mediumGapInBetween,
                  CustomButton(
                    label: MyStrings.signUpLabel,
                    onPress: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        AuthFunctions.signUpWithPassword(
                            context, model, email, password);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: Platform.isIOS ? 42 : 24),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      MyStrings.alreadyAnAccountLabel,
                      fontSize: 17,
                    ),
                    CustomText(
                      MyStrings.signInLabel,
                      color: MyColors.perfectBlue,
                      fontSize: 17,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
