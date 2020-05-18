import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitoModalState();
  }
}

class _HabitoModalState extends State<HabitModal> {
  bool _categorySet = false;
  MyHabit _myHabit = MyHabit();
  MyCategory _myCategory = MyCategory();
  int _selectedIndex = 0;

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ScopedModelDescendant<HabitoModel>(
            builder: (context, child, model) {
              List<MyCategory> myCategories = model.myCategories;
              if (_categorySet) {
                _selectedIndex = 0;
              }
              return Container(
                color: HabitoColors.white,
                height: 217,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _categorySet = false;
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomText(
                              "Unassign",
                              color: HabitoColors.perfectRed,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _categorySet = true;
                              _myCategory = myCategories[_selectedIndex];
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomText(
                              "Done",
                              color: HabitoColors.perfectBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.6,
                      color: HabitoColors.ruler,
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          _selectedIndex = index;
                        },
                        childCount: myCategories.length,
                        itemBuilder: (context, index) {
                          return myCategories[index].spinnerTile();
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
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
                    "New Habit",
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
                _myHabit.title = text;
              },
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              keyboardType: TextInputType.text,
              cursorColor: HabitoColors.perfectBlue,
              maxLength: 20,
              style: TextStyle(color: HabitoColors.black, fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: TextStyle(color: HabitoColors.white),
                filled: true,
                hintStyle: new TextStyle(color: HabitoColors.placeholderGrey),
                hintText: "Name",
                contentPadding: EdgeInsets.fromLTRB(10, 21, 10, 0),
                fillColor: HabitoColors.white,
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  "Category",
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
                  onTap: showPicker,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: _categorySet
                          ? _myCategory.categoryColor
                          : HabitoColors.backdropBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _categorySet
                        ? Icon(
                            _myCategory.categoryIcon,
                            color: HabitoColors.white,
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            TextField(
              onChanged: (text) {
                _myHabit.description = text;
              },
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
                prefixIcon: Icon(Icons.chat_bubble_outline, color: HabitoColors.placeholderGrey,),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 21),
                fillColor: HabitoColors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ScopedModelDescendant<HabitoModel>(
                  builder:
                      (BuildContext _context, Widget child, HabitoModel model) {
                    return OutlineButton(
                      onPressed: () {
                        if(_categorySet){
                          _myHabit.category = _myCategory.documentId;
                        }
                        model.addNewHabit(_myHabit).then((value) {
                          if (value) {
                            print("saved and returned");
                            model
                                .neverSatisfied(context, "Saved successfully!",
                                    "${_myHabit.title} is now being tracked. Good luck.")
                                .then((value) {
                              Navigator.of(context).pop();
                            });
                          } else {
                            model.neverSatisfied(context, "Try again",
                                "Cannot track this habit right now.");
                          }
                        });
                      },
                      child: CustomText(
                        "Track",
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
