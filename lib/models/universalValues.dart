import 'package:flutter/material.dart';

class UniversalValues{
  //margin and paddings region start
  static double topPaddingBeforeHeading = 99;
  static double headingHorizontalMargin = 30;
  //region end

  //font properties region start
  static double headingFontSize = 45;
  //region end

  //habit options region starts
  static var marginForHabitFirstOption = EdgeInsets.only(left: 0);
  static var marginForHabitSecondOption = EdgeInsets.only(left: 42);
  static var marginForHabitThirdOption = EdgeInsets.only(left: 84);
  static var marginForParentOption = EdgeInsets.only(right: 42);
  //region end
}

class HabitoColors{
  static Color transparent = Colors.transparent;

  static Color white = Colors.white;
  static Color almostWhite = Color(0xfffafafa);
  static Color captionWhite = Colors.white54;

  static Color black = Colors.black;
  static Color backdropBlack = Colors.black12;
  static Color midnight = Color(0xff1F2024);

  static Color darkTextFieldBackground = Color(0xff2c2b2e);
  static Color placeholderGrey = Color(0xff636363);
  static Color ruler = Color(0x80636363);

  static Color buttonBlueBackground = Colors.blue.withAlpha(50);
  static Color labelBackground = Colors.white10;

  static Color perfectBlue = Colors.blue;
  static Color perfectRed = Colors.red;

  static Color categoryPaletteOne = Colors.orange;
  static Color categoryPaletteTwo = Colors.deepOrange;
  static Color categoryPaletteThree = Colors.pink;
  static Color categoryPaletteFour = Colors.purple;
  static Color categoryPaletteFive = Colors.deepPurple;
  static Color categoryPaletteSix = Colors.indigo;
  static List<Color> standardColorsList = [
    perfectBlue,
    categoryPaletteOne,
    categoryPaletteTwo,
    categoryPaletteThree,
    categoryPaletteFour,
    categoryPaletteFive,
    categoryPaletteSix
  ];

  static Color habitOption = Colors.white;
  static Color success = Colors.green;
}