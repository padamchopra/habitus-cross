import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';

class CustomText extends StatelessWidget {
  final String content;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final TextDecoration textDecoration;
  final double letterSpacing;
  final bool alternateFont;
  final Function onTap;
  const CustomText(this.content,
      {this.fontWeight: FontWeight.normal,
      this.textAlign: TextAlign.start,
      this.color: MyColors.white,
      this.fontSize: 20,
      this.textDecoration: TextDecoration.none,
      this.letterSpacing: 0,
      this.alternateFont: false,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      content,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: alternateFont ? 'productsans' : 'roboto',
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        decoration: textDecoration,
      ),
    );

    if (onTap == null) {
      return text;
    }
    return GestureDetector(
      onTap: onTap,
      child: text,
    );
  }
}
