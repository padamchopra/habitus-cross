import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/habitoModel.dart';
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
      backgroundColor: Color(0xfffafafa),
      body: Stack(
        children: <Widget>[
          Background(Colors.black),
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
                      color: Colors.white,
                      fontSize: 57,
                      letterSpacing: -2.4,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    TextFormField(
                      focusNode: _focusNode1,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_focusNode2),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textInputAction: TextInputAction.next,
                      validator: (_email) => EmailValidator.validate(_email)
                          ? null
                          : "Invalid email",
                      onSaved: (_email) => email = _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Color(0xff636363),
                        ),
                        hintStyle: new TextStyle(color: Color(0xff636363)),
                        hintText: "Email",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 21),
                        fillColor: Color(0xff2c2b2e),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      focusNode: _focusNode2,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_focusNode3),
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      validator: (_password) {
                        if (_password.length >= 6) {
                          password = _password;
                          return null;
                        } else {
                          return "Too short.";
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff636363),
                        ),
                        hintStyle: new TextStyle(color: Color(0xff636363)),
                        hintText: "Password",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 21),
                        fillColor: Color(0xff2c2b2e),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      focusNode: _focusNode3,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      validator: (_password) => password == _password
                          ? null
                          : "Passwords do not match",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff636363),
                        ),
                        hintStyle: new TextStyle(color: Color(0xff636363)),
                        hintText: "Confirm password",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 21),
                        fillColor: Color(0xff2c2b2e),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ScopedModelDescendant<HabitoModel>(
                      builder: (BuildContext context, Widget child,
                          HabitoModel model) {
                        return MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              model.signUp(email, password).then((value) {
                                if (value) {
                                  model.signOut().whenComplete(
                                      () => Navigator.of(context).pop());
                                } else {
                                  model.neverSatisfied(context, "Try Again",
                                      "We could not sign you up at the moment. Sorry for the trouble.");
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
                              color: Colors.white,
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
                        color: Colors.blue,
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
