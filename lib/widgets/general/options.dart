import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Options {
  static Future<dynamic> show(
    BuildContext context,
    Offset offset,
    defaultValue,
    Map<String, dynamic> values,
  ) async {
    if (Platform.isIOS) {
      return await iOSOptions(context, defaultValue, values);
    } else {
      return await androidOptions(context, defaultValue, values, offset);
    }
  }

  static Future<dynamic> iOSOptions(
    BuildContext context,
    defaultValue,
    Map<String, dynamic> values,
  ) async {
    var option = defaultValue;
    var options = [];

    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext _context) {
        values.forEach((key, value) {
          options.add(CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(_context).pop();
              option = value;
            },
            child: Text(key),
          ));
        });

        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(_context).pop(),
            child: Text("Cancel"),
          ),
          actions: options,
        );
      },
    );

    return option;
  }

  static Future<dynamic> androidOptions(
    BuildContext context,
    defaultValue,
    Map<String, dynamic> values,
    Offset offset,
  ) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    List<PopupMenuItem> options = [];
    values.forEach((key, value) {
      options.add(PopupMenuItem(
        child: Text(key),
        value: value,
      ));
    });

    var option = await showMenu(
      context: context,
      elevation: 2,
      initialValue: defaultValue,
      position: RelativeRect.fromRect(
          offset & Size(10, 10), Offset.zero & overlay.size),
      items: options,
    );

    return option;
  }
}
