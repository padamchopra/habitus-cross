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
  List<MyCategory> _myCategoriesList;
  List<MyHabit> _myHabitsList;
  bool _categoriesLoaded;
  bool _habitsLoaded;

  HabitoModel() {
    _categoriesLoaded = false;
    _habitsLoaded = false;
    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    _myCategoriesList = [];
    _myHabitsList = [];
    checkIfSignedIn().then((value) {
      if (value) {
        fetchCategories();
        fetchHabits();
      }
    });
  }

  //Handle sign ins, outs, and ups
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

  //add new category to the firebase
  Future<bool> addNewCategory(MyCategory myCategory) async {
    if (_user != null) {
      myCategory.userId = _user.uid;
      DocumentReference documentReference =
          _firestore.collection("categories").document();
      await documentReference.setData(myCategory.toJson());
      //now add category locally
      myCategory.documentId = documentReference.documentID;
      _myCategoriesList.insert(0, myCategory);
      notifyListeners();
      return true;
    }
    return false;
  }

  //fetch all saved categories for current user
  void fetchCategories() async {
    if (_user != null) {
      _categoriesLoaded = true;
      _myCategoriesList.clear();
      String userId = _user.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection("categories")
          .where("uid", isEqualTo: userId)
          .orderBy("createdAt", descending: true)
          .getDocuments();
      for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
        Map<String, dynamic> data = documentSnapshot.data;
        MyCategory currentCategory = new MyCategory();
        currentCategory.categoryColor = data["color"];
        currentCategory.categoryName = data["name"];
        currentCategory.userId = userId;
        currentCategory.categoryIconFromCodePoint = data["icon"];
        currentCategory.documentId = documentSnapshot.documentID;
        _myCategoriesList.add(currentCategory);
        notifyListeners();
      }
    }
  }

  MyCategory findCategoryById(String id) {
    if (id == "") {
      return MyCategory();
    }
    if (_categoriesLoaded) {
      return _myCategoriesList.firstWhere(
        (element) => element.documentId == id,
        orElse: () => MyCategory(),
      );
    } else {
      fetchCategories();
      return findCategoryById(id);
    }
  }

  //fetch number of categories
  int numberOfCategories() {
    if (_categoriesLoaded) {
      return _myCategoriesList.length;
    } else {
      fetchCategories();
      return 0;
    }
  }

  get myCategories {
    return _myCategoriesList;
  }

  //add new habit to the firebase
  Future<bool> addNewHabit(MyHabit myHabit) async {
    if (_user != null) {
      myHabit.userId = _user.uid;
      DocumentReference documentReference =
          _firestore.collection("habits").document();
      await documentReference.setData(myHabit.toJson());
      //now add habit locally
      myHabit.documentId = documentReference.documentID;
      _myHabitsList.insert(0, myHabit);
      notifyListeners();
      if (myHabit.category != "") {
        addHabitToCategory(myHabit.documentId, myHabit.category);
      }
      return true;
    }
    return false;
  }

  //fetch all saved habits for current user
  void fetchHabits() async {
    if (_user != null) {
      _habitsLoaded = true;
      _myHabitsList.clear();
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
        Timestamp createdAt = data["createdAt"];
        print("created at $createdAt");
        currentHabit.createdAt = createdAt.toDate();
        currentHabit.isFinished = data["finished"];
        if (currentHabit.isFinished) {
          Timestamp finishedAt = data["finishedAt"];
          currentHabit.finishedAt = finishedAt.toDate();
        }
        currentHabit.category = data["category"];
        currentHabit.daysCompleted = data["numberOfDays"];
        currentHabit.setUpdateTimesFromFirestore(data["updateTimes"]);
        currentHabit.isDeleted = data["deleted"];
        currentHabit.userId = data["uid"];
        currentHabit.documentId = documentSnapshot.documentID;
        _myHabitsList.add(currentHabit);
        notifyListeners();
      }
    }
  }

  //fetch number of habits
  int numberOfHabits() {
    if (_habitsLoaded) {
      return _myHabitsList.length;
    } else {
      fetchHabits();
      return 0;
    }
  }

  get myHabits {
    return _myHabitsList;
  }

  void addHabitToCategory(
      String habitDocumentId, String categoryDocumentId) async {
    _myCategoriesList.forEach((category) {
      if (category.documentId == categoryDocumentId) {
        category.addHabitToList(habitDocumentId);
        notifyListeners();
      }
    });
  }

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
            title: CustomText('Try Again!'),
            content: CustomText('Could not sign you up at the moment.'),
            actions: <Widget>[
              FlatButton(
                child: CustomText('Okay'),
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
