import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';

class NotesTextField extends StatelessWidget {
  final Function onValueChange;
  final bool enabled;
  final String initialText;
  NotesTextField(this.onValueChange, this.enabled, this.initialText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onValueChange,
      enabled: enabled,
      initialValue: initialText,
      autocorrect: false,
      textCapitalization: TextCapitalization.sentences,
      autofocus: true,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      cursorColor: MyColors.perfectBlue,
      maxLines: null,
      style: TextStyle(color: MyColors.black, fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelStyle: TextStyle(color: MyColors.white),
        filled: true,
        hintStyle: new TextStyle(color: MyColors.placeholderGrey),
        hintText: "Notes",
        prefixIcon: Icon(
          Icons.chat_bubble_outline,
          color: MyColors.placeholderGrey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 21),
        fillColor: MyColors.white,
      ),
    );
  }
}
