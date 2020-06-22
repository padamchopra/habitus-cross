import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/pages/home.dart';
import 'package:habito/pages/signin.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
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
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  HabitoModel model = HabitoModel();
  Widget _widget = Center(
    child: CircularProgressIndicator(),
  );

  void updateHomeWidget() {
    setState(() {
      if (model.userState == HabitoAuth.SUCCESS) {
        _widget = Home(model);
      } else {
        _widget = SignIn(model);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    model.globalScaffoldKey = globalScaffoldKey;
    model.updateHomeRootWidget = updateHomeWidget;
    _firebaseMessaging.requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "roboto",
          primaryColor: MyColors.black,
          accentColor: MyColors.white,
          highlightColor: MyColors.white,
          cursorColor: MyColors.white,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: MyColors.transparent),
        ),
        home: Scaffold(
          key: globalScaffoldKey,
          resizeToAvoidBottomPadding: false,
          backgroundColor: MyColors.black,
          body: _widget,
        ),
      ),
    );
  }
}
