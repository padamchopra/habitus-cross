import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class GoogleSignInButton extends StatelessWidget {
  final double width;
  final Function signIn;
  GoogleSignInButton({
    @required this.width,
    @required this.signIn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FlatButton(
        color: MyColors.midnight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: MyColors.midnight),
        ),
        onPressed: signIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image(
                image: AssetImage("assets/icons/google.png"),
                height: 16,
              ),
              CustomText(
                MyStrings.googleLabel,
                fontSize: 16,
                alternateFont: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
