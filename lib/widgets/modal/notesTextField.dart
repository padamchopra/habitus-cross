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
      cursorColor: HabitoColors.perfectBlue,
      maxLines: null,
      style: TextStyle(color: HabitoColors.black, fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelStyle: TextStyle(color: HabitoColors.white),
        filled: true,
        hintStyle: new TextStyle(color: HabitoColors.placeholderGrey),
        hintText: "Notes",
        prefixIcon: Icon(
          Icons.chat_bubble_outline,
          color: HabitoColors.placeholderGrey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 21),
        fillColor: HabitoColors.white,
      ),
    );
  }
}
