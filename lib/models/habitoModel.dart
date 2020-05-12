import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class HabitoModel extends Model {
  FirebaseAuth _auth;
  FirebaseUser _user;

  HabitoModel() {
    _auth = FirebaseAuth.instance;
  }

  //Handle sign ins, outs, and ups
  Future<bool> checkIfSignedIn() async {
    _user = await _auth.currentUser();
    if (_user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      return true;
    } on Exception catch (_){
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (_user != null) {
      return true;
    } else {
      return false;
    }
  }

  //warning
  Future<void> neverSatisfied(BuildContext context, String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(description),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Try Again!'),
            content: Text('Could not sign you up at the moment.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}
