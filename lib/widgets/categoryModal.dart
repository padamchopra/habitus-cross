import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoryModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryModalState();
  }
}

class _CategoryModalState extends State<CategoryModal> {
  bool iconSet = false;
  MyCategory _myCategory = MyCategory();

  Widget buildColorPickerBtn(Color color, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _myCategory.categoryColor = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(index == 1 ? 6 : 0),
              bottomLeft: Radius.circular(index == 1 ? 6 : 0),
              topRight: Radius.circular(index == 6 ? 6 : 0),
              bottomRight: Radius.circular(index == 6 ? 6 : 0),
            ),
          ),
          height: 30,
          child: index == _myCategory.categoryColorIndex
              ? Icon(
                  Icons.check,
                  color: HabitoColors.white,
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: HabitoColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: CustomText(
                    "New Category",
                    color: HabitoColors.black,
                    textAlign: TextAlign.center,
                    letterSpacing: 0.2,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (text) {
                setState(() {
                  _myCategory.categoryName = text;
                });
              },
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              keyboardType: TextInputType.text,
              maxLength: 15,
              cursorColor: HabitoColors.perfectBlue,
              style: TextStyle(color: HabitoColors.black, fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: TextStyle(color: HabitoColors.white),
                filled: true,
                hintStyle: new TextStyle(color: HabitoColors.placeholderGrey),
                hintText: "Name",
                contentPadding:
                    EdgeInsets.fromLTRB(10, 21, 10, 0),
                fillColor: HabitoColors.white,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  "Icon",
                  color: HabitoColors.black,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  "->",
                  color: HabitoColors.black,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    IconData iconData = await FlutterIconPicker.showIconPicker(
                        context,
                        iconPackMode: IconPack.material);
                    if (iconData != _myCategory.categoryIcon) {
                      iconSet = true;
                    }
                    setState(() {
                      _myCategory.categoryIcon = iconData;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: HabitoColors.backdropBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      iconSet
                          ? _myCategory.categoryIcon
                          : Icons.arrow_drop_down,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 18,
              ),
              child: Row(
                children: <Widget>[
                  buildColorPickerBtn(HabitoColors.categoryPaletteOne, 1),
                  buildColorPickerBtn(HabitoColors.categoryPaletteTwo, 2),
                  buildColorPickerBtn(HabitoColors.categoryPaletteThree, 3),
                  buildColorPickerBtn(HabitoColors.categoryPaletteFour, 4),
                  buildColorPickerBtn(HabitoColors.categoryPaletteFive, 5),
                  buildColorPickerBtn(HabitoColors.categoryPaletteSix, 6),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: CustomText(
                "-- Preview --",
                color: HabitoColors.placeholderGrey,
                fontSize: 12,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
              child: _myCategory.widget(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ScopedModelDescendant<HabitoModel>(
                  builder:
                      (BuildContext _context, Widget child, HabitoModel model) {
                    return OutlineButton(
                      onPressed: () {
                        model.addNewCategory(_myCategory).then((value) {
                          if (value) {
                            print("saved and returned");
                            model
                                .neverSatisfied(context, "Saved successfully!",
                                    "${_myCategory.categoryName} has been added to your categories.")
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          } else {
                            model.neverSatisfied(context, "Try again",
                                "Could not save this category.");
                          }
                        });
                      },
                      child: CustomText(
                        "Add",
                        color: HabitoColors.black,
                        textAlign: TextAlign.center,
                        letterSpacing: 0.2,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
