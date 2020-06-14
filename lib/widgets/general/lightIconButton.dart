import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class LightIconButton extends StatelessWidget {
  final IconData icon;
  final String name;
  final Function function;
  LightIconButton(this.icon, this.name, this.function);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: MyColors.buttonBlueBackground,
          ),
          child: IconButton(
            onPressed: () {
              function();
            },
            icon: Icon(
              icon,
              size: 30,
              color: MyColors.perfectBlue,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        CustomText(
          name,
          fontSize: 15,
          color: MyColors.black,
          letterSpacing: 0.2,
          alternateFont: true,
        ),
      ],
    );
  }
}
