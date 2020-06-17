import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class OAuthButton extends StatelessWidget {
  final String assetName;
  final String label;
  final double width;
  final Function signIn;
  OAuthButton({
    @required this.assetName,
    @required this.label,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: AssetImage("assets/icons/$assetName.png"),
                height: 16,
                width: 16,
              ),
              CustomText(
                label,
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
