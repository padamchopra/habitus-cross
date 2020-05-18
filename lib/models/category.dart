import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class MyCategory {
  String _name;
  List<String> _myHabits;
  int _color;
  IconData _icon;
  String _documentId;
  String _userId;
  bool _deleted;

  final List<Color> colors = [
    HabitoColors.perfectBlue,
    HabitoColors.categoryPaletteOne,
    HabitoColors.categoryPaletteTwo,
    HabitoColors.categoryPaletteThree,
    HabitoColors.categoryPaletteFour,
    HabitoColors.categoryPaletteFive,
    HabitoColors.categoryPaletteSix
  ];

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

  get categoryColor{
    return colors[_color];
  }

  get categoryIcon {
    return _icon;
  }

  void addHabitToList(String id){
    _myHabits.insert(0, id);
  }

  Widget widget({bool showNumberOfHabits}) {
    Widget onTheRight = Container();
    double _rightPadding = 0;
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
              color: HabitoColors.labelBackground,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: HabitoColors.midnight,
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
          Padding(
            padding: EdgeInsets.only(right: _rightPadding),
            child: CustomText(
              _name,
              fontSize: 21,
              letterSpacing: 0.2,
            ),
          ),
          onTheRight
        ],
      ),
    );
  }

  Widget spinnerTile() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            _icon,
            color: HabitoColors.black,
          ),
          SizedBox(
            width: 6,
          ),
          CustomText(
            _name,
            color: HabitoColors.black,
            fontSize: 18,
          )
        ],
      ),
    );
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
