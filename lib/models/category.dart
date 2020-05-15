import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/widgets/text.dart';

class MyCategory {
  String _name;
  List<MyHabit> _myHabits;
  int _color;
  IconData _icon;
  String _documentId;
  String _userId;

  final List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo
  ];

  MyCategory() {
    this._myHabits = [];
    this._color = 0;
    this._icon = Icons.label_outline;
    this._name = "";
    this._documentId = "";
    this._userId = "";
  }

  set categoryName(String name) {
    this._name = name;
  }

  set categoryColor(int color) {
    this._color = color;
  }

  set categoryIcon(IconData icon) {
    this._icon = icon;
  }

  set categoryIconFromCodePoint(int codePoint) {
    this._icon = IconData(codePoint, fontFamily: "MaterialIcons");
  }

  set documentId(String id) {
    this._documentId = id;
  }

  set userId(String id) {
    this._userId = id;
  }

  get numberOfHabits {
    return _myHabits.length;
  }

  get userId {
    return _userId;
  }

  get documentId {
    return _documentId;
  }

  get categoryName {
    return _name;
  }

  get categoryHabits {
    return _myHabits;
  }

  get categoryColor {
    return _color;
  }

  get categoryIcon {
    return _icon;
  }

  Widget widget({bool showNumberOfHabits}) {
    Widget onTheRight = Container();
    if (showNumberOfHabits != null && showNumberOfHabits) {
      onTheRight = Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 36,
            height: 36,
            child: Align(
              alignment: Alignment.center,
              child: CustomText(
                _myHabits.length.toString(),
                fontSize: 18,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }
    //Color(0xff1F2024)
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Color(0xff1F2024),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            _icon,
            color: colors[_color],
            size: 30,
          ),
          SizedBox(
            width: 9,
          ),
          CustomText(
            _name,
            fontSize: 21,
            letterSpacing: 0.2,
          ),
          onTheRight
        ],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": _name,
        "color": _color,
        "uid": _userId,
        "icon": _icon.codePoint,
        "createdAt": FieldValue.serverTimestamp()
      };
}
