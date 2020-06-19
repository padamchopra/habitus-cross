import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/devTesting.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/authModel.dart';
import 'package:habito/state/categoryModel.dart';
import 'package:habito/state/habitModel.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class HabitoModel extends Model
    with ModelData, AuthModel, CategoryModel, HabitModel {
  Function updateHomeRootWidget = () {};
  HabitoAuth userState;
  Widget homeRootWidget = Center(
    child: CircularProgressIndicator(),
  );

  HabitoModel() {
    initialiseVariables();
    updateUserState();
  }

  void updateUserState() async {
    HabitoAuth result = await checkIfSignedIn();
    if (result == HabitoAuth.SUCCESS) {
      fetchUserData();
      userState = HabitoAuth.SUCCESS;
    } else {
      userState = HabitoAuth.NO_USER;
    }
    updateHomeRootWidget();
  }

  Future<void> fetchUserData() async {
    await fetchCategories();
    await fetchHabits();
    associateHabitsAndCategories();
  }
}

mixin ModelData on Model {
  bool isDevTesting;
  FirebaseAuth firebaseAuth;
  FirebaseUser firebaseUser;
  Firestore firestore;
  FirebaseAnalytics firebaseAnalytics;
  List<MyCategory> myCategoriesList;
  List<MyHabit> myHabitsList;
  List<MyHabit> myCompletedHabitsList;
  bool areCategoriesLoaded;
  bool areHabitsLoaded;
  Function playConfetti;

  void initialiseVariables() {
    isDevTesting = DevTesting.testing && !DevTesting.showSignIn;
    playConfetti = () {};
    firebaseAnalytics = FirebaseAnalytics();
    areCategoriesLoaded = false;
    areHabitsLoaded = false;
    myCategoriesList = [];
    myHabitsList = [];
    myCompletedHabitsList = [];
    if (!isDevTesting) {
      firebaseAuth = FirebaseAuth.instance;
      firestore = Firestore.instance;
      logAnalyticsEvent(AnalyticsEvents.appOpened, success: true);
    }
  }

  void associateHabitsAndCategories() {
    Map<String, List<MyHabit>> map = new Map();
    for (MyHabit myHabit in myHabitsList) {
      if (myHabit.category != "") {
        if (map.containsKey(myHabit.category)) {
          map[myHabit.category].add(myHabit);
        } else {
          map[myHabit.category] = [];
          map[myHabit.category].add(myHabit);
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

  void addHabitToCategory(MyHabit habit, String categoryDocumentId) async {
    myCategoriesList.forEach((category) {
      if (category.documentId == categoryDocumentId) {
        category.addHabitToList(habit);
        notifyListeners();
      }
    });
  }

  void logAnalyticsEvent(String eventName, {bool success, error}) {
    if (success == null) {
      firebaseAnalytics.logEvent(name: eventName);
    } else {
      firebaseAnalytics.logEvent(
        name: eventName,
        parameters: {
          "success": success,
          "error": error,
        },
      );
    }
  }

  get userEmail {
    if (isDevTesting) {
      return DevTesting.userEmail;
    }
    return firebaseUser.email;
  }
}
