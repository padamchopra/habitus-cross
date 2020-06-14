import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/modal/actionButton.dart';
import 'package:habito/widgets/modal/categoryRow.dart';
import 'package:habito/widgets/modal/modalHeader.dart';
import 'package:habito/widgets/modal/nameTextField.dart';
import 'package:habito/widgets/modal/notesTextField.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class HabitModal extends StatefulWidget {
  final HabitModalMode mode;
  final MyHabit myHabit;
  final MyCategory myCategory;
  HabitModal(this.mode, {this.myHabit, this.myCategory});
  @override
  State<StatefulWidget> createState() {
    return _HabitoModalState();
  }
}

class _HabitoModalState extends State<HabitModal> {
  bool categorySet = false;
  MyHabit _myHabit = MyHabit();
  MyCategory _myCategory = MyCategory();
  int _selectedIndex = 0;
  bool initialLoading = true;

  //change according to mode
  String modalHeadText = "New Habit";
  bool editingEnabled = true;
  String title = "";
  String description = "";
  Widget actionButton;
  initState() {
    super.initState();
    if (initialLoading) {
      if (widget.mode == HabitModalMode.NEW)
        actionButton = ActionButton(addNewHabit, "Track");

      if (widget.mode == HabitModalMode.EDIT) {
        modalHeadText = "Edit Habit";
        actionButton = ActionButton(updateHabit, "Update");
      }

      if (widget.mode == HabitModalMode.DUPLICATE) {
        modalHeadText = "Duplicate Habit";
        title = widget.myHabit.title;
        title += title.length < 14 ? " (copy)" : "";
        description = widget.myHabit.description;
        categorySet = true;
        _myCategory = widget.myCategory;
        actionButton = ActionButton(addNewHabit, "Track");
      }

      if (widget.mode == HabitModalMode.VIEW) {
        modalHeadText = "Habit Details";
        editingEnabled = false;
        actionButton = ActionButton(editMyHabit, "Edit");
      }

      if (widget.mode == HabitModalMode.VIEW ||
          widget.mode == HabitModalMode.EDIT) {
        title = widget.myHabit.title;
        description = widget.myHabit.description;
        categorySet = true;
        _myCategory = widget.myCategory;
      }
    }
    initialLoading = false;
  }

  void addNewHabit(model) {
    _myHabit.title = title;
    _myHabit.description = description;
    if (categorySet) {
      _myHabit.category = _myCategory.documentId;
    }
    model.addNewHabit(_myHabit).then((value) {
      if (value) {
        model
            .showAlert(context, "Saved successfully!",
                "${_myHabit.title} is now being tracked. Good luck.")
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        model.showAlert(
            context, "Try again", "Cannot track this habit right now.");
      }
    });
  }

  void editMyHabit(HabitoModel model) {
    if (widget.myHabit.isFinished) {
      model.showAlert(context, "Error",
          "Cannot edit habit as it has already been completed");
      return;
    }
    setState(() {
      modalHeadText = "Edit Habit";
      editingEnabled = true;
      actionButton = ActionButton(updateHabit, "Update");
      _myHabit = widget.myHabit;
      if (widget.myHabit.category == "") {
        categorySet = false;
        _myCategory = MyCategory();
      }
    });
  }

  void updateHabit(model) {
    _myHabit.title = title;
    _myHabit.description = description;
    if (categorySet) {
      _myHabit.category = _myCategory.documentId;
    }
    model.updateHabit(_myHabit).then((value) {
      if (value) {
        model
            .showAlert(context, "Updated successfully!",
                "${_myHabit.title} has been updated.")
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        model.showAlert(context, "Try again", "Cannot update habit right now.");
      }
    });
  }

  void showPicker() {
    if (!editingEnabled) return;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ScopedModelDescendant<HabitoModel>(
            builder: (context, child, model) {
              List<MyCategory> myCategories = model.myCategoriesList;
              if (categorySet) {
                _selectedIndex = 0;
              }
              return Container(
                color: MyColors.white,
                height: 217,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              categorySet = false;
                              Navigator.of(context).pop();
                            });
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
                              categorySet = true;
                              _myCategory = myCategories[_selectedIndex];
                              Navigator.of(context).pop();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomText(
                              "Done",
                              color: MyColors.perfectBlue,
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
                      color: MyColors.ruler,
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
          color: MyColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ModalHeader(modalHeadText, context),
            SizedBox(height: 30),
            NameTextField(
              (text) => title = text,
              editingEnabled,
              title,
            ),
            categorySet
                ? CategoryRow(
                    showPicker,
                    color: _myCategory.categoryColor,
                    icon: _myCategory.categoryIcon,
                  )
                : CategoryRow(showPicker),
            SizedBox(height: 6),
            NotesTextField(
              (text) => description = text,
              editingEnabled,
              description,
            ),
            actionButton,
          ],
        ),
      ),
    );
  }
}
