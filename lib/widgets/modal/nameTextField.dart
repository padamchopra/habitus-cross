import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';

class NameTextField extends StatelessWidget {
  final Function onChangedFunction;
  final bool enabled;
  final String initialText;
  NameTextField(this.onChangedFunction, this.enabled, this.initialText);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialText,
      onChanged: onChangedFunction,
      enabled: enabled,
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      autofocus: true,
      keyboardType: TextInputType.text,
      cursorColor: MyColors.perfectBlue,
      maxLength: 20,
      style: TextStyle(color: MyColors.black, fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelStyle: TextStyle(color: MyColors.white),
        filled: true,
        hintStyle: new TextStyle(color: MyColors.placeholderGrey),
        hintText: "Name",
        contentPadding: EdgeInsets.fromLTRB(10, 21, 10, 0),
        fillColor: MyColors.white,
      ),
    );
  }
}
