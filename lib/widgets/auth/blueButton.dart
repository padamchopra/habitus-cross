import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class BlueButton extends StatelessWidget {
  final String label;
  final Function onPress;
  BlueButton({
    @required this.label,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: MyColors.perfectBlue,
      onPressed: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        width: double.infinity,
        child: CustomText(
          MyStrings.signinLabel,
          color: MyColors.white,
          textAlign: TextAlign.center,
          alternateFont: true,
        ),
      ),
    );
  }
}
