import 'package:flutter/material.dart';
import 'package:habito/models/habitoModel.dart';
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
  HabitoModel model = HabitoModel();
  Widget _whatToDisplay = CircularProgressIndicator();

  void updateUserState() {
    setState(() {
      model.checkIfSignedIn().then((value) {
        setState(() {
          _whatToDisplay = value ? Home(updateUserState) : Login(updateUserState);
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
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "productsans",
          primaryColor: Colors.black,
          accentColor: Colors.white,
          highlightColor: Colors.white,
          cursorColor: Colors.white,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color(0xfffafafa),
          body: _whatToDisplay,
        ),
      ),
    );
  }
}
