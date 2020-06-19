import 'package:flutter/material.dart';
import 'package:habito/widgets/general/alertNotifyDialog.dart';
import 'package:habito/widgets/general/confirmationDialog.dart';

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

  static Future<void> showActionDialog({
    @required BuildContext context,
    @required String title,
    @required String description,
    @required Function positiveCallback,
    Function otherCallback,
    String positiveLabel: 'OK',
    String otherLabel,
    bool otherIsNegative: false,
    bool positiveIsNegative: false,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title,
          description,
          positiveCallback,
          otherCallback,
          positiveLabel,
          otherLabel,
          otherIsNegative,
          positiveIsNegative,
        );
      },
    );
  }
}
