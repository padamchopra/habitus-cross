import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPress;
  final Color color;
  CustomButton({
    @required this.label,
    @required this.onPress,
    this.color: MyColors.perfectBlue,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      onPressed: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        width: double.infinity,
        child: CustomText(
          label,
          color: MyColors.white,
          textAlign: TextAlign.center,
          alternateFont: true,
        ),
      ),
    );
  }
}
