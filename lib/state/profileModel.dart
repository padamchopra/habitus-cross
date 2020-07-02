import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/functions/universalFunctions.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';

mixin ProfileModel on ModelData {
  Future<void> loadSortingPreference() async {
    try {
      DocumentSnapshot ds = await firestore
          .collection("preferences")
          .document(firebaseUser.uid)
          .get();
      if (ds != null) {
        Map<String, dynamic> data = ds.data;
        if (data.containsKey("sort-habits")) {
          await setSortingMethod(data["sort-habits"]);
        }
      }
    } catch (e) {
      sortingMethod = (o1, o2) {
        return -1;
      };
    }
  }

  void updateSortingMethod(BuildContext context, String sortHabitsBy) async {
    try {
      await firestore
          .collection("preferences")
          .document(firebaseUser.uid)
          .setData({"sort-habits": sortHabitsBy}, merge: true);
      setSortingMethod(sortHabitsBy);
    } catch (e) {
      UniversalFunctions.showAlert(context, "Updation failed",
          "Try again. Could not save your sorting preference.");
    }
  }

  Future<void> setSortingMethod(String sortingMethodString) async {
    sortingHabitsByDefaultName = sortingMethodString;
    switch (sortingMethodString) {
      case "Old -> New":
        sortingMethod = oldToNewSort;
        break;
      case "A -> Z":
        sortingMethod = aToZSort;
        break;
      case "Days Completed":
        sortingMethod = daysCompleted;
        break;
      case "Categories":
        sortingMethod = categories;
        break;
      default:
        sortingHabitsByDefaultName = "Select Option";
        sortingMethod = (o1, o2) {
          return -1;
        };
    }
    notifyListeners();
  }

  int oldToNewSort(MyHabit h1, MyHabit h2) {
    Timestamp t1 = h1.createdAt;
    Timestamp t2 = h2.createdAt;
    return t1.compareTo(t2);
  }

  int aToZSort(MyHabit h1, MyHabit h2) {
    String name1 = h1.title;
    String name2 = h2.title;
    return name1.compareTo(name2);
  }

  int daysCompleted(MyHabit h1, MyHabit h2) {
    int days1 = h1.daysCompleted;
    int days2 = h1.daysCompleted;
    return days1.compareTo(days2);
  }

  int categories(MyHabit h1, MyHabit h2) {
    String categoryId1 = h1.category;
    String categoryId2 = h2.category;
    if (categoryId1 == "") {
      return -1;
    } else if (categoryId2 == "") {
      return 1;
    }
    return categoryId1.compareTo(categoryId2);
  }
}
