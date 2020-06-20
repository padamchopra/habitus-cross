import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/devTesting.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';

mixin HabitModel on ModelData {
  int numberOfHabits(bool isCompleted) {
    if (areHabitsLoaded) {
      return myHabitsMap[isCompleted].length;
    } else {
      return -1;
    }
  }

  void habitsCollectionAdd(MyHabit myHabit) {
    myHabitsMap[myHabit.isFinished][myHabit.documentId] = myHabit;
  }

  HabitReplaceStatus habitsListReplace(MyHabit myHabit) {
    HabitReplaceStatus replaceStatus = HabitReplaceStatus.FAIL;
    if (myHabitsMap[myHabit.isFinished].containsKey(myHabit.documentId)) {
      if (myHabitsMap[myHabit.isFinished][myHabit.documentId].category !=
          myHabit.category) {
        replaceStatus = HabitReplaceStatus.CATEGORY_DIFFERS;
      } else {
        replaceStatus = HabitReplaceStatus.SUCCESS;
      }
      myHabitsMap[myHabit.isFinished][myHabit.documentId] = myHabit;
    }
    return replaceStatus;
  }

  Future<bool> addNewHabit(MyHabit myHabit) async {
    if (isDevTesting) {
      myHabit.documentId = "habitId${myHabitsMap[myHabit.isFinished].length}";
    } else if (firebaseUser != null) {
      myHabit.userId = firebaseUser.uid;
      try {
        DocumentReference documentReference =
            firestore.collection("habits").document();
        await documentReference.setData(myHabit.toJson());
        myHabit.documentId = documentReference.documentID;
        logAnalyticsEvent(AnalyticsEvents.habitNew, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitNew,
          success: false,
          error: e.toString(),
        );
        return false;
      }
    } else
      return false;
    habitsCollectionAdd(myHabit);
    if (myHabit.category != "") {
      addHabitToCategory(myHabit, myHabit.category);
    }
    notifyListeners();
    return true;
  }

  Future<void> updateHabits(List<MyHabit> myHabitsList) async {
    myHabitsList.forEach((habit) async {
      habit.category = "";
      await updateHabit(habit, refreshAssociations: true);
    });
    associateHabitsAndCategories();
    notifyListeners();
  }

  Future<bool> updateHabit(MyHabit myHabit,
      {bool refreshAssociations: false}) async {
    if (isDevTesting) {
      myHabit.userId = DevTesting.userId;
    } else if (firebaseUser != null) {
      myHabit.userId = firebaseUser.uid;
      try {
        await firestore
            .collection("habits")
            .document(myHabit.documentId)
            .updateData(myHabit.updatedJson());
        logAnalyticsEvent(AnalyticsEvents.habitUpdate, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitUpdate,
          success: false,
          error: e.toString(),
        );
        return false;
      }
    } else
      return false;
    HabitReplaceStatus replaceStatus = habitsListReplace(myHabit);
    if (refreshAssociations ||
        replaceStatus == HabitReplaceStatus.CATEGORY_DIFFERS) {
      associateHabitsAndCategories();
    }
    notifyListeners();
    return true;
  }

  Future<bool> resetHabitProgress(MyHabit myHabit) async {
    bool toReturn = false;
    if (myHabitsMap[myHabit.isFinished].containsKey(myHabit.documentId)) {
      MyHabit mySavedHabit =
          myHabitsMap[myHabit.isFinished][myHabit.documentId];
      try {
        mySavedHabit.resetProgress();
        if (!isDevTesting) {
          firestore
              .collection("habits")
              .document(myHabit.documentId)
              .updateData(myHabit.toJson());
          logAnalyticsEvent(AnalyticsEvents.habitReset, success: true);
        }
        habitsCollectionAdd(mySavedHabit);
        toReturn = true;
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitReset,
          success: false,
          error: e.toString(),
        );
        toReturn = false;
      }
      if (toReturn) myHabitsMap[true].remove(myHabit);
    }

    if (toReturn) {
      associateHabitsAndCategories();
      notifyListeners();
    }
    return toReturn;
  }

  Future<bool> deleteHabit(MyHabit myHabit) async {
    bool toReturn = false;
    if (myHabitsMap[myHabit.isFinished].containsKey(myHabit.documentId)) {
      MyHabit mySavedHabit =
          myHabitsMap[myHabit.isFinished][myHabit.documentId];
      try {
        mySavedHabit.isDeleted = true;
        if (!isDevTesting) {
          firestore
              .collection("habits")
              .document(mySavedHabit.documentId)
              .updateData(mySavedHabit.toJson());
          logAnalyticsEvent(AnalyticsEvents.habitDelete, success: true);
        }
        toReturn = true;
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitDelete,
          success: false,
          error: e.toString(),
        );
        mySavedHabit.isDeleted = false;
        toReturn = false;
      }
    }

    if (toReturn) {
      myHabitsMap[myHabit.isFinished].remove(myHabit.documentId);
      associateHabitsAndCategories();
      notifyListeners();
    }
    return toReturn;
  }

  Future<void> fetchHabits() async {
    if (isDevTesting) {
      myHabitsMap = DevTesting.getInitialHabits();
    } else if (firebaseUser != null) {
      myHabitsMap[true].clear();
      myHabitsMap[false].clear();
      String userId = firebaseUser.uid;

      try {
        QuerySnapshot querySnapshot = await firestore
            .collection("habits")
            .where("uid", isEqualTo: userId)
            .where("deleted", isEqualTo: false)
            .orderBy("createdAt", descending: false)
            .getDocuments();
        for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
          MyHabit currentHabit = MyHabit.fromFirebase(
            data: documentSnapshot.data,
            documentId: documentSnapshot.documentID,
          );
          habitsCollectionAdd(currentHabit);
          notifyListeners();
        }
        logAnalyticsEvent(AnalyticsEvents.habitFetch, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitFetch,
          success: false,
          error: e.toString(),
        );
        myHabitsMap[true].clear();
        myHabitsMap[false].clear();
      }
    } else
      return;

    areHabitsLoaded = true;
    notifyListeners();
  }

  HabitProgressChange markDoneForToday(MyHabit myHabit) {
    HabitProgressChange progressChange = HabitProgressChange.FAIL;
    if (myHabitsMap[false].containsKey(myHabit.documentId)) {
      MyHabit mySavedHabit = myHabitsMap[false][myHabit.documentId];
      progressChange = mySavedHabit.markAsDone(isDevTesting);
      if (progressChange != HabitProgressChange.FAIL && !isDevTesting) {
        try {
          firestore
              .collection("habits")
              .document(mySavedHabit.documentId)
              .updateData(mySavedHabit.toJson());
          logAnalyticsEvent(AnalyticsEvents.habitMarkDoneForToday,
              success: true);
        } catch (e) {
          logAnalyticsEvent(
            AnalyticsEvents.habitMarkDoneForToday,
            success: false,
            error: e.toString(),
          );
          mySavedHabit = myHabit;
          progressChange = HabitProgressChange.FAIL;
        }
      }

      if (progressChange == HabitProgressChange.COMPLETE) {
        logAnalyticsEvent(AnalyticsEvents.habitMarkComplete, success: true);
        habitsCollectionAdd(mySavedHabit);
        myHabitsMap[false].remove(myHabit.documentId);
      }
    }

    notifyListeners();
    return progressChange;
  }
}
