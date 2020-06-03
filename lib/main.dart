import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/analytics.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/home.dart';
import 'package:habito/pages/login.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  HabitoModel model = HabitoModel();
  Widget _whatToDisplay = CircularProgressIndicator();

  void updateUserState() {
    setState(() {
      model.checkIfSignedIn().then((value) {
        setState(() {
          _whatToDisplay = value == HabitoAuth.SUCCESS
              ? Home(updateUserState, model)
              : Login(updateUserState);
        });
      }).catchError((_) {
        setState(() {
          _whatToDisplay = Login(updateUserState);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateUserState();
    _firebaseMessaging.requestNotificationPermissions();
    Analytics.sendAnalyticsEvent(Analytics.appOpened);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "productsans",
          primaryColor: HabitoColors.black,
          accentColor: HabitoColors.white,
          highlightColor: HabitoColors.white,
          cursorColor: HabitoColors.white,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: HabitoColors.transparent),
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: HabitoColors.almostWhite,
          body: _whatToDisplay,
        ),
      ),
    );
  }
}
