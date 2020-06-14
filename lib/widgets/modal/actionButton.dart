import 'package:flutter/material.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class ActionButton extends StatelessWidget {
  final Function onTap;
  final String text;
  ActionButton(this.onTap, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ScopedModelDescendant<HabitoModel>(
          builder: (_context, child, model) {
            return OutlineButton(
              onPressed: () => onTap(model),
              child: CustomText(
                text,
                color: MyColors.black,
                textAlign: TextAlign.center,
                letterSpacing: 0.2,
                fontSize: 18,
              ),
            );
          },
        ),
      ],
    );
  }
}
