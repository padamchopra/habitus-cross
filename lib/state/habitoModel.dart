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
import 'package:habito/state/profileModel.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class HabitoModel extends Model
    with ModelData, AuthModel, CategoryModel, HabitModel, ProfileModel {
  Function updateHomeRootWidget = () {};
  GlobalKey<ScaffoldState> _globalScaffoldKey;
  HabitoAuth userState;
  Widget homeRootWidget = Center(
    child: CircularProgressIndicator(),
  );

  get globalScaffoldKey {
    return _globalScaffoldKey;
  }

  set globalScaffoldKey(key) {
    this._globalScaffoldKey = key;
  }

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
    await loadSortingPreference();
    await fetchCategories();
    await fetchHabits();
  }
}

mixin ModelData on Model {
  bool isDevTesting;
  FirebaseAuth firebaseAuth;
  FirebaseUser firebaseUser;
  Firestore firestore;
  FirebaseAnalytics firebaseAnalytics;
  Map<String, MyCategory> myCategories = new Map();
  Map<bool, Map<String, MyHabit>> myHabitsMap;
  bool areCategoriesLoaded;
  bool areHabitsLoaded;
  Function playConfetti;
  Function sortingMethod = (o1, o2) {
    return -1;
  };
  String sortingHabitsByDefaultName = "Select Option";

  void initialiseVariables() {
    isDevTesting = DevTesting.testing && !DevTesting.showSignIn;
    playConfetti = () {};
    firebaseAnalytics = FirebaseAnalytics();
    areCategoriesLoaded = false;
    areHabitsLoaded = false;
    myHabitsMap = {
      false: {},
      true: {},
    };
    if (!isDevTesting) {
      firebaseAuth = FirebaseAuth.instance;
      firestore = Firestore.instance;
      logAnalyticsEvent(AnalyticsEvents.appOpened, success: true);
    }
  }

  get myCategoriesAsList {
    return myCategories.values.toList();
  }

  List<MyHabit> myHabitsAsList(bool completed) {
    return myHabitsMap[completed].values.toList();
  }

  void removeHabitFromCategory(MyHabit myHabit) {
    if (myHabit.category != "") {
      myCategories[myHabit.category].habitsMap.remove(myHabit.documentId);
    }
  }

  void addHabitToCategory(MyHabit myHabit) {
    if (myHabit.category != "") {
      myCategories[myHabit.category].addHabitToMap(myHabit);
    }
  }

  void logAnalyticsEvent(String eventName,
      {bool success: true, error: "None"}) {
    print(eventName);
    if (DevTesting.notLoggingAnalytics) return;
    firebaseAnalytics.logEvent(
      name: eventName,
      parameters: {
        "success": success,
        "error": error,
      },
    );
  }

  get userEmail {
    if (isDevTesting) {
      return DevTesting.userEmail;
    }
    return firebaseUser.email;
  }
}
