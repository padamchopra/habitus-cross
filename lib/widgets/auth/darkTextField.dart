import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';

class DarkTextField extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final Function validator;
  final Function onSave;
  final TextInputType inputType;
  final IconData icon;
  final String hint;
  final bool obscureText;
  DarkTextField({
    @required this.focusNode,
    @required this.hint,
    @required this.validator,
    @required this.onSave,
    this.nextFocusNode,
    this.inputType: TextInputType.text,
    this.icon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: obscureText != null && obscureText,
      textInputAction:
          nextFocusNode == null ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(nextFocusNode != null ? nextFocusNode : FocusNode());
      },
      validator: validator,
      onSaved: onSave,
      autocorrect: false,
      keyboardType: inputType,
      cursorColor: MyColors.white,
      style: TextStyle(
        color: MyColors.white,
        fontSize: 18,
        fontFamily: 'roboto'
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        labelStyle: TextStyle(color: MyColors.white),
        filled: true,
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: MyColors.placeholderGrey,
              )
            : null,
        hintStyle: new TextStyle(color: MyColors.placeholderGrey),
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 21),
        fillColor: MyColors.darkTextFieldBackground,
      ),
    );
  }
}
