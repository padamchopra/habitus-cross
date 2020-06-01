import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/habit.dart';

class DevTesting {
  static String userId = "Tester";

  static MyCategory category(
      int color, String name, IconData icon, int documentId, int daysAgo) {
    MyCategory currentCategory = new MyCategory();
    currentCategory.categoryColor = color;
    currentCategory.categoryName = name;
    currentCategory.userId = "testuser";
    currentCategory.categoryIcon = icon;
    currentCategory.documentId = "categoryId$documentId";
    currentCategory.createdAt =
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: daysAgo)));
    return currentCategory;
  }

  static MyHabit habit(String name, String notes, int daysAgo, int categoryId,
      bool deleted, int habitId) {
    MyHabit currentHabit = new MyHabit();
    currentHabit.title = name;
    currentHabit.description = notes;
    currentHabit.createdAt =
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: daysAgo)));
    currentHabit.isFinished = daysAgo > 20 ? true : false;
    if (currentHabit.isFinished) {
      currentHabit.finishedAt = Timestamp.fromDate(
          DateTime.now().subtract(Duration(days: daysAgo + 21)));
    }
    currentHabit.category = categoryId == -1 ? "" : "categoryId$categoryId";
    currentHabit.daysCompleted = daysAgo;
    currentHabit.updateTimes = [
      Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))
    ];
    currentHabit.isDeleted = deleted;
    currentHabit.userId = userId;
    currentHabit.documentId = "habitId$habitId";
    return currentHabit;
  }
}
