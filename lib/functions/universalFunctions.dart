import 'package:flutter/material.dart';
import 'package:habito/widgets/general/alertNotifyDialog.dart';

class UniversalFunctions {
  static Future<void> showAlert(
      BuildContext context, String title, String description) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertNotifyDialog(title, description);
      },
    );
  }
}
