import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/widgets/text.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class HabitoModel extends Model {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Firestore _firestore;
  List<MyCategory> myCategoriesList;
  List<MyHabit> myHabitsList;
  bool _categoriesLoaded;
  bool _habitsLoaded;

  HabitoModel() {
    _categoriesLoaded = false;
    _habitsLoaded = false;
    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    myCategoriesList = [];
    myHabitsList = [];
    checkIfSignedIn().then((value) {
      if (value) {
        fetchCategories();
      }
    });
  }

  //authentication region begins
  Future<bool> checkIfSignedIn() async {
    _user = await _auth.currentUser();
    if (_user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> signOut() async {
    await _auth.signOut();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    _user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (_user != null) {
      return true;
    } else {
      return false;
    }
  }

  //region ends

  //categories region starts
  Future<bool> addNewCategory(MyCategory myCategory) async {
    if (_user != null) {
      myCategory.userId = _user.uid;
      DocumentReference documentReference =
          _firestore.collection("categories").document();
      await documentReference.setData(myCategory.toJson());
      //now add category locally
      myCategory.documentId = documentReference.documentID;
      myCategoriesList.insert(0, myCategory);
      notifyListeners();
      return true;
    }
    return false;
  }

  void fetchCategories() async {
    if (_user != null) {
      myCategoriesList.clear();
      String userId = _user.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection("categories")
          .where("uid", isEqualTo: userId)
          .orderBy("createdAt", descending: false)
          .getDocuments();
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        Map<String, dynamic> data = documentSnapshot.data;
        MyCategory currentCategory = new MyCategory();
        currentCategory.categoryColor = data["color"];
        currentCategory.categoryName = data["name"];
        currentCategory.userId = userId;
        currentCategory.categoryIconFromCodePoint = data["icon"];
        currentCategory.documentId = documentSnapshot.documentID;
        myCategoriesList.add(currentCategory);
        notifyListeners();
      }
      _categoriesLoaded = true;
      myCategoriesList.toSet().toList();
      fetchHabits();
    }
  }

  MyCategory findCategoryById(String id) {
    if (id == "") {
      return MyCategory();
    }
    if (_categoriesLoaded) {
      return myCategoriesList.firstWhere(
        (element) => element.documentId == id,
        orElse: () => MyCategory(),
      );
    } else {
      fetchCategories();
      return findCategoryById(id);
    }
  }

  int numberOfCategories() {
    if (_categoriesLoaded) {
      return myCategoriesList.length;
    } else {
      return -1;
    }
  }
  //region ends

  //Habit collection region starts
  Future<bool> addNewHabit(MyHabit myHabit) async {
    if (_user != null) {
      myHabit.userId = _user.uid;
      DocumentReference documentReference =
          _firestore.collection("habits").document();
      await documentReference.setData(myHabit.toJson());
      //now add habit locally
      myHabit.documentId = documentReference.documentID;
      myHabitsList.insert(0, myHabit);
      notifyListeners();
      if (myHabit.category != "") {
        addHabitToCategory(myHabit.documentId, myHabit.category);
      }
      return true;
    }
    return false;
  }

  Future<bool> updateHabit(MyHabit myHabit) async {
    if (_user != null) {
      myHabit.userId = _user.uid;
      await _firestore
          .collection("habits")
          .document(myHabit.documentId)
          .updateData(myHabit.updatedJson());
      //now update habit locally
      myHabitsList.forEach((element) {
        if (element.documentId == myHabit.documentId) {
          element = myHabit;
          associateHabitsAndCategories();
        }
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  void fetchHabits() async {
    if (_user != null) {
      myHabitsList.clear();
      String userId = _user.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection("habits")
          .where("uid", isEqualTo: userId)
          .orderBy("createdAt", descending: false)
          .getDocuments();
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        Map<String, dynamic> data = documentSnapshot.data;
        MyHabit currentHabit = new MyHabit();
        currentHabit.title = data["name"];
        currentHabit.description = data["notes"];
        currentHabit.createdAt = data["createdAt"];
        currentHabit.isFinished = data["finished"];
        if (currentHabit.isFinished) {
          currentHabit.finishedAt = data["finishedAt"];
        }
        currentHabit.category = data["category"];
        currentHabit.daysCompleted = data["numberOfDays"];
        currentHabit.updateTimes = data["updateTimes"];
        currentHabit.isDeleted = data["deleted"];
        currentHabit.userId = data["uid"];
        currentHabit.documentId = documentSnapshot.documentID;
        myHabitsList.add(currentHabit);
        notifyListeners();
      }
      _habitsLoaded = true;
      myHabitsList.toSet().toList();
      associateHabitsAndCategories();
    }
  }

  int numberOfHabits() {
    if (_habitsLoaded) {
      return myHabitsList.length;
    } else {
      return -1;
    }
  }
  //region ends

  //habit updation region starts
  int markDoneForToday(MyHabit myHabit) {
    /// 0: success in updating
    /// 1: already updated today
    /// 2: more than 1 day in difference
    /// 3: completed 21 days
    /// 4: some other error
    int resultCode = 4;
    myHabitsList.forEach((habit) {
      if (habit.documentId == myHabit.documentId) {
        resultCode = habit.markAsDone();
        if (resultCode != 4) {
          _firestore
              .collection("habits")
              .document(habit.documentId)
              .updateData(habit.toJson());
        }
      }
    });
    notifyListeners();
    return resultCode;
  }
  //region ends

  //Habit Category intersection region starts
  void associateHabitsAndCategories() {
    Map<String, List<String>> map = new Map();
    for (MyHabit myHabit in myHabitsList) {
      if (myHabit.category != "") {
        if (map.containsKey(myHabit.category)) {
          map[myHabit.category].add(myHabit.documentId);
        } else {
          map[myHabit.category] = [];
          map[myHabit.category].add(myHabit.documentId);
        }
      }
    }
    myCategoriesList.forEach((category) {
      if (map.containsKey(category.documentId)) {
        category.habitsList = map[category.documentId];
      }
    });
    notifyListeners();
  }

  void addHabitToCategory(
      String habitDocumentId, String categoryDocumentId) async {
    myCategoriesList.forEach((category) {
      if (category.documentId == categoryDocumentId) {
        category.addHabitToList(habitDocumentId);
        notifyListeners();
      }
    });
  }
  //region ends

  //warning
  Future<void> neverSatisfied(
      BuildContext context, String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: CustomText(
              title,
              color: HabitoColors.black,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: CustomText(
                description,
                color: HabitoColors.black,
                textAlign: TextAlign.center,
                fontSize: 14,
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: CustomText(
                  'OK',
                  color: HabitoColors.perfectBlue,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: CustomText(
              title,
              color: HabitoColors.black,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            content: CustomText(
              description,
              color: HabitoColors.black,
              textAlign: TextAlign.center,
              fontSize: 16,
            ),
            actions: <Widget>[
              FlatButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: double.infinity),
                  child: CustomText(
                    'OK',
                    color: HabitoColors.perfectBlue,
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }
}
