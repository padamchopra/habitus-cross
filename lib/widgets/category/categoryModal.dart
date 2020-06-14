import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/modal/actionButton.dart';
import 'package:habito/widgets/modal/iconRow.dart';
import 'package:habito/widgets/modal/modalHeader.dart';
import 'package:habito/widgets/modal/nameTextField.dart';
import 'package:habito/widgets/text.dart';

class CategoryModal extends StatefulWidget {
  final CategoryModalMode mode;
  final MyCategory myCategory;
  CategoryModal(this.mode, {this.myCategory});
  @override
  State<StatefulWidget> createState() {
    return _CategoryModalState();
  }
}

class _CategoryModalState extends State<CategoryModal> {
  bool iconSet = false;
  MyCategory _myCategory = MyCategory();

  bool initialLoading = true;

  //change according to mode
  String modalHeadText = "New Category";
  bool editingEnabled = true;
  Widget actionButton;
  initState() {
    super.initState();
    print(widget.mode);
    if (initialLoading) {
      if (widget.mode == CategoryModalMode.NEW)
        actionButton = ActionButton(addNewCategory, "Add");

      if (widget.mode == CategoryModalMode.EDIT) {
        modalHeadText = "Edit Category";
        actionButton = ActionButton(updateCategory, "Update");
        iconSet = true;
        _myCategory = widget.myCategory;
      }

      if (widget.mode == CategoryModalMode.DUPLICATE) {
        modalHeadText = "Duplicate Category";
        iconSet = true;
        _myCategory.categoryName = widget.myCategory.categoryName;
        _myCategory.categoryIcon = widget.myCategory.categoryIcon;
        _myCategory.categoryColor = widget.myCategory.categoryColorIndex;
        actionButton = ActionButton(addNewCategory, "Add");
      }

      if (widget.mode == CategoryModalMode.VIEW) {
        modalHeadText = "Category Details";
        editingEnabled = false;
        iconSet = true;
        _myCategory = widget.myCategory;
        actionButton = ActionButton(editMyCategory, "Edit");
      }
    }
    initialLoading = false;
  }

  void showPicker() async {
    IconData iconData = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.material);
    if (iconData != _myCategory.categoryIcon) {
      iconSet = true;
    }
    setState(() {
      _myCategory.categoryIcon = iconData;
    });
  }

  void addNewCategory(model) {
    model.addNewCategory(_myCategory).then((value) {
      if (value) {
        print("saved and returned");
        model
            .showAlert(context, "Saved successfully!",
                "${_myCategory.categoryName} has been added to your categories.")
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        model.showAlert(
            context, "Try again", "Could not save this category.");
      }
    });
  }

  void updateCategory(model) {
    model.updateCategory(_myCategory).then((value) {
      if (value) {
        print("saved and returned");
        model
            .showAlert(context, "Updated successfully!",
                "${_myCategory.categoryName} has been updated.")
            .then((value) {
          Navigator.of(context).pop();
        });
      } else {
        model.showAlert(
            context, "Try again", "Cannot update category right now.");
      }
    });
  }

  void editMyCategory(_) {
    setState(() {
      editingEnabled = true;
      modalHeadText = "Edit Category";
      actionButton = ActionButton(updateCategory, "Update");
    });
  }

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
                  color: MyColors.white,
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
          color: MyColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ModalHeader(modalHeadText, context),
            SizedBox(height: 30),
            NameTextField(
              (text) {
                setState(() {
                  _myCategory.categoryName = text;
                });
              },
              editingEnabled,
              _myCategory.categoryName,
            ),
            iconSet
                ? IconRow(
                    showPicker,
                    icon: _myCategory.categoryIcon,
                  )
                : IconRow(showPicker),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 18,
              ),
              child: Row(
                children: <Widget>[
                  buildColorPickerBtn(MyColors.categoryPaletteOne, 1),
                  buildColorPickerBtn(MyColors.categoryPaletteTwo, 2),
                  buildColorPickerBtn(MyColors.categoryPaletteThree, 3),
                  buildColorPickerBtn(MyColors.categoryPaletteFour, 4),
                  buildColorPickerBtn(MyColors.categoryPaletteFive, 5),
                  buildColorPickerBtn(MyColors.categoryPaletteSix, 6),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: CustomText(
                "-- Preview --",
                color: MyColors.placeholderGrey,
                fontSize: 12,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
              child: _myCategory.widget(overridePadding: true),
            ),
            SizedBox(
              height: 20,
            ),
            actionButton,
          ],
        ),
      ),
    );
  }
}
