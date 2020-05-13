import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class NewCategoryModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewCategoryModalState();
  }
}

class _NewCategoryModalState extends State<NewCategoryModal> {
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
          child: index == _myCategory.categoryColor
              ? Icon(
                  Icons.check,
                  color: Colors.white,
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
          color: Colors.white,
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
                    color: Colors.black,
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
              cursorColor: Colors.blue,
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                hintStyle: new TextStyle(color: Color(0xff636363)),
                hintText: "Name",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 21),
                fillColor: Colors.white,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  "Icon",
                  color: Colors.black,
                  fontSize: 18,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  "->",
                  color: Colors.black,
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
                      color: Colors.black12,
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
                  buildColorPickerBtn(Colors.orange, 1),
                  buildColorPickerBtn(Colors.deepOrange, 2),
                  buildColorPickerBtn(Colors.pink, 3),
                  buildColorPickerBtn(Colors.purple, 4),
                  buildColorPickerBtn(Colors.deepPurple, 5),
                  buildColorPickerBtn(Colors.indigo, 6),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: CustomText(
                "-- Preview --",
                color: Colors.black54,
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
                        color: Colors.black,
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
