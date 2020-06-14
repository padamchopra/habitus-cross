import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  final BuildContext context;
  ModalHeader(this.title, this.context);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: CustomText(
            title,
            color: MyColors.black,
            textAlign: TextAlign.center,
            letterSpacing: 0.2,
            alternateFont: true,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.close),
          ),
        )
      ],
    );
  }
}
