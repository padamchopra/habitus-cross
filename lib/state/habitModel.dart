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

  void habitsListReplace(MyHabit myHabit) {
    if (myHabitsMap[myHabit.isFinished].containsKey(myHabit.documentId)) {
      MyHabit mySavedHabit =
          myHabitsMap[myHabit.isFinished][myHabit.documentId];
      if (mySavedHabit.category != myHabit.category) {
        //update category associations
        removeHabitFromCategory(mySavedHabit);
        addHabitToCategory(myHabit);
      }
      myHabitsMap[myHabit.isFinished][myHabit.documentId] = myHabit;
    }
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
    addHabitToCategory(myHabit);
    notifyListeners();
    return true;
  }

  Future<void> updateHabits(Map<bool, String> myHabitsList) async {
    myHabitsList.forEach((key, value) async {
      MyHabit mySavedHabit = myHabitsMap[value][key];
      mySavedHabit.category = "";
      await updateHabit(mySavedHabit);
    });
    notifyListeners();
  }

  Future<bool> updateHabit(MyHabit myHabit) async {
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
    habitsListReplace(myHabit);
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
        myHabitsMap[true].remove(myHabit);
        myCategories[mySavedHabit.category].habitsMap[mySavedHabit.documentId] =
            false;
        notifyListeners();
        toReturn = true;
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitReset,
          success: false,
          error: e.toString(),
        );
        toReturn = false;
      }
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
      removeHabitFromCategory(myHabit);
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
          addHabitToCategory(currentHabit);
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
