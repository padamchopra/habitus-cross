import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/category/categorySpinnerTile.dart';
import 'package:habito/widgets/category/categoryTile.dart';

class MyCategory {
  String _name;
  List<String> _myHabits;
  int _color;
  IconData _icon;
  String _documentId;
  String _userId;
  bool _deleted;

  MyCategory() {
    this._myHabits = [];
    this._color = 0;
    this._icon = Icons.label_outline;
    this._name = "";
    this._documentId = "";
    this._userId = "";
    this._deleted = false;
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

  set habitsList(List<String> habits) {
    this._myHabits = habits;
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

  get categoryColorIndex {
    return _color;
  }

  get categoryColor {
    return HabitoColors.standardColorsList[_color];
  }

  get categoryIcon {
    return _icon;
  }

  void addHabitToList(String id) {
    _myHabits.insert(0, id);
  }

  Widget widget({bool showNumberOfHabits}) {
    return CategoryTile(
      showNumberOfHabits == null ? false : true,
      _myHabits,
      _icon,
      _color,
      _name,
    );
  }

  Widget spinnerTile() {
    return CategorySpinnerTile(_icon, _name);
  }

  Map<String, dynamic> toJson() => {
        "name": _name,
        "color": _color,
        "uid": _userId,
        "icon": _icon.codePoint,
        "deleted": _deleted,
        "createdAt": FieldValue.serverTimestamp()
      };
}
