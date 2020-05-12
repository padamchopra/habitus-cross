import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/habitoModel.dart';
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
    String email, password;
    return Stack(
      children: <Widget>[
        Background(Colors.black),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            child: CustomText(
              "Habito.",
              color: Colors.white,
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
                    validator: (_email) => EmailValidator.validate(_email)
                        ? null
                        : "Invalid email",
                    onSaved: (_email) => email = _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    onSaved: (_password) => password = _password,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    obscureText: true,
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
                    height: 30,
                  ),
                  ScopedModelDescendant<HabitoModel>(
                    builder: (BuildContext context, Widget child,
                        HabitoModel model) {
                      return MaterialButton(
                        color: Colors.blue,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            bool signedIn = await model.signIn(email, password);
                            if (signedIn) {
                              updateUserState();
                            } else {
                              model.neverSatisfied(context, "Incorrect Login", "Please re-check your details and try again.");
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18),
                          width: MediaQuery.of(context).size.width,
                          child: CustomText(
                            "Login",
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
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
