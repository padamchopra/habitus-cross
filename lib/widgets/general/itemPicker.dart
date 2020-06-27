import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemPicker extends StatefulWidget {
  final BuildContext context;
  final Function newValueAssigned;
  final List<Widget> options;
  final Function buildMainWidget;
  final Widget iOSDefault;
  ItemPicker({
    @required this.context,
    @required this.newValueAssigned,
    @required this.options,
    @required this.buildMainWidget,
    @required this.iOSDefault,
  });

  @override
  State<StatefulWidget> createState() {
    return _ItemPickerState();
  }
}

class _ItemPickerState extends State<ItemPicker> {
  Widget iOSMainWidget;
  int _confirmedIndex = -1;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    refreshWidget();
  }

  void refreshWidget() {
    if (_confirmedIndex == -1) {
      iOSMainWidget = widget.iOSDefault;
    } else {
      iOSMainWidget = widget.buildMainWidget(_confirmedIndex);
    }
  }

  void showIOSPicker(HabitoModel model) {
    showModalBottomSheet(
        context: widget.context,
        builder: (BuildContext context) {
          return Container(
            color: MyColors.white,
            height: 240,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmedIndex = -1;
                          refreshWidget();
                        });
                        widget.newValueAssigned(null);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText(
                          "Unassign",
                          color: MyColors.perfectRed,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmedIndex = _selectedIndex;
                          refreshWidget();
                        });
                        widget
                            .newValueAssigned(widget.options[_confirmedIndex]);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomText(
                          "Done",
                          color: MyColors.alertBlue,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 0.6,
                  color: MyColors.ruler,
                ),
                Expanded(
                  child: CupertinoPicker.builder(
                    scrollController: FixedExtentScrollController(
                        initialItem: _confirmedIndex < 0 ? 0 : _confirmedIndex),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) => _selectedIndex = index,
                    childCount: widget.options.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40,
                        child: Align(
                          alignment: Alignment.center,
                          child: widget.options[index],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HabitoModel>(
      builder: (context, child, model) {
        return Platform.isIOS
            ? GestureDetector(
                onTap: () => showIOSPicker(model),
                child: iOSMainWidget,
              )
            : Container();
      },
    );
  }
}
