import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/analytics.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/signup.dart';
import 'package:habito/widgets/background.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final Function updateUserState;
  Login(this.updateUserState);

  @override
  Widget build(BuildContext context) {
    String email, password, tempEmail;
    Analytics.sendAnalyticsEvent(Analytics.loginOpened);

    return Stack(
      children: <Widget>[
        Background(MyColors.black),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            child: CustomText(
              "Habito.",
              color: MyColors.white,
              fontSize: 57,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  TextFormField(
                    focusNode: _focusNode1,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_focusNode2),
                    validator: (_email) {
                      if (EmailValidator.validate(_email)) {
                        tempEmail = _email;
                        return null;
                      } else {
                        return "Invalid email";
                      }
                    },
                    onSaved: (_email) => email = _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: MyColors.white,
                    style: TextStyle(color: MyColors.white, fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      labelStyle: TextStyle(color: MyColors.white),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: MyColors.placeholderGrey,
                      ),
                      hintStyle: new TextStyle(color: MyColors.placeholderGrey),
                      hintText: "Email",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 21),
                      fillColor: MyColors.darkTextFieldBackground,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    focusNode: _focusNode2,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: MyColors.white,
                    onSaved: (_password) => password = _password,
                    style: TextStyle(color: MyColors.white, fontSize: 18),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      labelStyle: TextStyle(color: MyColors.white),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: MyColors.placeholderGrey,
                      ),
                      hintStyle: new TextStyle(color: MyColors.placeholderGrey),
                      hintText: "Password",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 21),
                      fillColor: MyColors.darkTextFieldBackground,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ScopedModelDescendant<HabitoModel>(
                    builder: (BuildContext context, Widget child,
                        HabitoModel model) {
                      return Column(
                        children: [
                          MaterialButton(
                            color: MyColors.perfectBlue,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                HabitoAuth signedInResult =
                                    await model.signIn(email, password);
                                if (signedInResult == HabitoAuth.SUCCESS) {
                                  Analytics.sendAnalyticsEvent(
                                      Analytics.authLoginSuccess);
                                  updateUserState();
                                } else {
                                  int index = 1;
                                  if (signedInResult ==
                                      HabitoAuth.VERIFICATION_REQUIRED) {
                                    Analytics.sendAnalyticsEvent(
                                        Analytics.authVerifyNeeded);
                                    index = 0;
                                  } else {
                                    Analytics.sendAnalyticsEvent(
                                        Analytics.authLoginFailure);
                                  }
                                  model.neverSatisfied(
                                    context,
                                    MyStrings.signInHeading[index],
                                    MyStrings.signInBody[index],
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 18),
                              width: MediaQuery.of(context).size.width,
                              child: CustomText(
                                "Login",
                                color: MyColors.white,
                                textAlign: TextAlign.center,
                                fontSize: 21,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                model
                                    .requestPasswordReset(tempEmail)
                                    .then((value) {
                                  Analytics.sendAnalyticsEvent(
                                      Analytics.authPasswordReset);
                                  model.neverSatisfied(
                                    context,
                                    MyStrings.signInHeading[2],
                                    MyStrings.signInBody[2],
                                  );
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomText(
                                "Forgot Password?",
                                color: MyColors.placeholderGrey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 54),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomText(
                    "Don't have an account?",
                    fontSize: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: CustomText(
                      "Sign Up",
                      fontSize: 18,
                      color: MyColors.perfectBlue,
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
