import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/auth/darkTextField.dart';
import 'package:habito/widgets/background.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class Signup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = new FocusNode();
  final _focusNode2 = new FocusNode();
  final _focusNode3 = new FocusNode();

  @override
  Widget build(BuildContext context) {
    String email, password;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: MyColors.almostWhite,
      body: Stack(
        children: <Widget>[
          Background(MyColors.black),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomText(
                      "Join habito.",
                      color: MyColors.white,
                      fontSize: 57,
                      letterSpacing: -2.4,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    DarkTextField(
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                      hint: "Email",
                      validator: (_email) => EmailValidator.validate(_email)
                          ? null
                          : "Invalid email",
                      inputType: TextInputType.emailAddress,
                      onSave: (_email) => email = _email,
                      icon: Icons.alternate_email,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    DarkTextField(
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                      hint: "Password",
                      validator: (_password) {
                        if (_password.length >= 6) {
                          password = _password;
                          return null;
                        }
                        return "Too short.";
                      },
                      onSave: (_) {},
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    DarkTextField(
                      focusNode: _focusNode3,
                      hint: "Confirm Password",
                      validator: (_password) => password == _password
                          ? null
                          : "Passwords do not match",
                      onSave: (_) {},
                      obscureText: true,
                      icon: Icons.lock_outline,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ScopedModelDescendant<HabitoModel>(
                      builder: (BuildContext context, Widget child,
                          HabitoModel model) {
                        return MaterialButton(
                          color: MyColors.perfectBlue,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              model.signUp(email, password).then((value) {
                                if (value == HabitoAuth.SUCCESS) {
                                  model
                                      .showAlert(
                                    context,
                                    MyStrings.signUpHeading[0],
                                    MyStrings.signUpBody[0],
                                  )
                                      .then((_) {
                                    model.signOut().whenComplete(
                                        () => Navigator.of(context).pop());
                                  });
                                } else {
                                  model.showAlert(
                                    context,
                                    MyStrings.signUpHeading[1],
                                    MyStrings.signUpBody[1],
                                  );
                                  Navigator.of(context).pop();
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            width: MediaQuery.of(context).size.width,
                            child: CustomText(
                              "Sign Up",
                              color: MyColors.white,
                              textAlign: TextAlign.center,
                              fontSize: 21,
                            ),
                          ),
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
                      "Already have an account?",
                      fontSize: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(
                        "Log In",
                        fontSize: 18,
                        color: MyColors.perfectBlue,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
