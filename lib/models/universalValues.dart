import 'package:flutter/material.dart';

class UniversalValues {
  //margin and paddings region start
  static const double headingHorizontalMargin = 30;
  //region end

  //font properties region start
  static const double headingFontSize = 45;
  //region end

  //habit options region starts
  static const EdgeInsets marginForHabitFirstOption = EdgeInsets.only(left: 0);
  static const EdgeInsets marginForHabitSecondOption =
      EdgeInsets.only(left: 42);
  static const EdgeInsets marginForHabitThirdOption = EdgeInsets.only(left: 84);
  static const EdgeInsets marginForParentOption = EdgeInsets.only(right: 42);
  //region end
}

class MySpaces {
  static const EdgeInsets listViewTopPadding = EdgeInsets.only(top: 9);
  static const double topPaddingBeforeHeading = 66;
}

class MyColors {
  static const Color transparent = Colors.transparent;

  static const Color white = Colors.white;
  static const Color almostWhite = Color(0xfffafafa);
  static const Color captionWhite = Colors.white54;

  static const Color black = Colors.black;
  static const Color backdropBlack = Colors.black12;
  static const Color midnight = Color(0xff1F2024);

  static const Color darkTextFieldBackground = Color(0xff2c2b2e);
  static const Color placeholderGrey = Color(0xff636363);
  static const Color ruler = Color(0x80636363);

  static Color buttonBlueBackground = Colors.blue.withAlpha(50);
  static const Color labelBackground = Colors.white10;

  static const Color perfectBlue = Colors.blue;
  static const Color perfectRed = Colors.red;

  static const Color categoryPaletteOne = Colors.orange;
  static const Color categoryPaletteTwo = Colors.deepOrange;
  static const Color categoryPaletteThree = Colors.pink;
  static const Color categoryPaletteFour = Colors.purple;
  static const Color categoryPaletteFive = Colors.deepPurple;
  static const Color categoryPaletteSix = Colors.indigo;
  static const List<Color> standardColorsList = [
    perfectBlue,
    categoryPaletteOne,
    categoryPaletteTwo,
    categoryPaletteThree,
    categoryPaletteFour,
    categoryPaletteFive,
    categoryPaletteSix
  ];

  static const Color habitOption = Colors.white;
  static const Color success = Colors.green;
}

class MyStrings {
  static const deleteCategoryHeading = ["Deleted", "Try Again"];
  static const deleteCategoryBody = [
    "This category has been deleted and child habits unlinked.",
    "This category could not be deleted."
  ];
}
