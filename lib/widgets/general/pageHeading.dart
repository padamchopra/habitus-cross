import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';

class PageHeading extends StatelessWidget {
  final String heading;
  const PageHeading(this.heading);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: MySpaces.topPaddingBeforeHeading),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MySpaces.headingHorizontalMargin,
          ),
          child: CustomText(
            heading,
            fontSize: UniversalValues.headingFontSize,
            fontWeight: FontWeight.bold,
            alternateFont: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: MyColors.ruler,
          width: double.infinity,
          height: 1,
        ),
      ],
    );
  }
}
