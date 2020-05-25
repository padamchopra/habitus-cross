import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class GeneralInfo extends StatelessWidget {
  final String label;
  final String information;
  GeneralInfo(this.label, this.information);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          label,
          color: HabitoColors.captionWhite,
          fontSize: 15,
        ),
        SizedBox(
          height: 3,
        ),
        CustomText(
          information,
          fontSize: 21,
        )
      ],
    );
  }
}
