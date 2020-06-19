import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/devTesting.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';

mixin HabitModel on ModelData {
  int numberOfHabits() {
    if (areHabitsLoaded) {
      return myHabitsList.length;
    } else {
      return -1;
    }
  }

  int numberOfCompletedHabits() {
    if (areHabitsLoaded) {
      return myCompletedHabitsList.length;
    } else {
      return -1;
    }
  }

  void habitsListAdd(MyHabit myHabit) {
    if (myHabit.isFinished) {
      myCompletedHabitsList.insert(0, myHabit);
    } else {
      myHabitsList.insert(0, myHabit);
    }
  }

  void habitsListAddAtEnd(MyHabit myHabit) {
    if (myHabit.isFinished) {
      myCompletedHabitsList.add(myHabit);
    } else {
      myHabitsList.add(myHabit);
    }
  }

  HabitReplaceStatus habitsListReplace(MyHabit myHabit) {
    HabitReplaceStatus replaceStatus = HabitReplaceStatus.FAIL;
    if (myHabit.isFinished) {
      myCompletedHabitsList.forEach((element) {
        if (element.documentId == myHabit.documentId) {
          if (element.category != myHabit.category) {
            replaceStatus = HabitReplaceStatus.CATEGORY_DIFFERS;
          } else {
            replaceStatus = HabitReplaceStatus.SUCCESS;
          }
          element = myHabit;
        }
      });
    } else {
      myHabitsList.forEach((element) {
        if (element.documentId == myHabit.documentId) {
          if (element.category != myHabit.category) {
            replaceStatus = HabitReplaceStatus.CATEGORY_DIFFERS;
          } else {
            replaceStatus = HabitReplaceStatus.SUCCESS;
          }
          element = myHabit;
        }
      });
    }
    return replaceStatus;
  }

  Future<bool> addNewHabit(MyHabit myHabit) async {
    if (isDevTesting) {
      myHabit.documentId = "habitId${myHabitsList.length}";
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
          error: e.code,
        );
        return false;
      }
    } else
      return false;
    habitsListAdd(myHabit);
    if (myHabit.category != "") {
      addHabitToCategory(myHabit, myHabit.category);
    }
    notifyListeners();
    return true;
  }

  Future<void> updateHabits(List<MyHabit> myHabits) async {
    myHabits.forEach((habit) async {
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
          error: e.code,
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
    if (myHabit.isFinished) {
      myCompletedHabitsList.forEach((habit) {
        if (habit.documentId == myHabit.documentId) {
          try {
            myHabit.resetProgress();
            if (!isDevTesting) {
              firestore
                  .collection("habits")
                  .document(myHabit.documentId)
                  .updateData(myHabit.toJson());
              logAnalyticsEvent(AnalyticsEvents.habitCompletedReset,
                  success: true);
            }
            habitsListAdd(myHabit);
            habit.resetProgress();
            toReturn = true;
          } catch (e) {
            logAnalyticsEvent(
              AnalyticsEvents.habitCompletedReset,
              success: false,
              error: e.code,
            );
            toReturn = false;
          }
        }
      });
      if (toReturn) myCompletedHabitsList.remove(myHabit);
    } else {
      myHabitsList.forEach((habit) {
        if (habit.documentId == myHabit.documentId) {
          try {
            MyHabit duplicateHabit = habit;
            duplicateHabit.resetProgress();
            if (!isDevTesting) {
              firestore
                  .collection("habits")
                  .document(duplicateHabit.documentId)
                  .updateData(duplicateHabit.toJson());
              logAnalyticsEvent(AnalyticsEvents.habitReset, success: true);
            }
            habit.resetProgress();
            toReturn = true;
          } catch (e) {
            logAnalyticsEvent(
              AnalyticsEvents.habitReset,
              success: false,
              error: e.code,
            );
            toReturn = false;
          }
        }
      });
    }
    if (toReturn) {
      associateHabitsAndCategories();
      notifyListeners();
    }
    return toReturn;
  }

  Future<bool> deleteHabit(MyHabit myHabit) async {
    bool toReturn = false;
    if (myHabit.isFinished) {
      myCompletedHabitsList.forEach((habit) {
        if (habit.documentId == myHabit.documentId) {
          try {
            habit.isDeleted = true;
            if (!isDevTesting) {
              firestore
                  .collection("habits")
                  .document(habit.documentId)
                  .updateData(habit.toJson());
              logAnalyticsEvent(AnalyticsEvents.habitCompletedDelete,
                  success: true);
            }
            toReturn = true;
          } catch (e) {
            logAnalyticsEvent(
              AnalyticsEvents.habitCompletedDelete,
              success: false,
              error: e.code,
            );
            habit.isDeleted = false;
            toReturn = false;
          }
        }
      });
    } else {
      myHabitsList.forEach((habit) {
        if (habit.documentId == myHabit.documentId) {
          try {
            habit.isDeleted = true;
            if (!isDevTesting) {
              firestore
                  .collection("habits")
                  .document(habit.documentId)
                  .updateData(habit.toJson());
              logAnalyticsEvent(AnalyticsEvents.habitDelete, success: true);
            }
            toReturn = true;
          } catch (e) {
            logAnalyticsEvent(
              AnalyticsEvents.habitDelete,
              success: false,
              error: e.code,
            );
            habit.isDeleted = false;
            toReturn = false;
          }
        }
      });
    }
    if (toReturn) {
      if (myHabit.isFinished) {
        myCompletedHabitsList.remove(myHabit);
      } else {
        myHabitsList.remove(myHabit);
      }
      associateHabitsAndCategories();
      notifyListeners();
    }
    return toReturn;
  }

  Future<void> fetchHabits() async {
    if (isDevTesting) {
      DevTesting.getInitialHabits()
          .forEach((element) => habitsListAddAtEnd(element));
    } else if (firebaseUser != null) {
      myHabitsList.clear();
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
          habitsListAddAtEnd(currentHabit);
          notifyListeners();
        }
        logAnalyticsEvent(AnalyticsEvents.habitFetch, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.habitFetch,
          success: false,
          error: e.code,
        );
        myHabitsList.clear();
      }
    } else
      return;

    myHabitsList = myHabitsList.toSet().toList();
    areHabitsLoaded = true;
    notifyListeners();
  }

  HabitProgressChange markDoneForToday(MyHabit myHabit) {
    HabitProgressChange progressChange = HabitProgressChange.FAIL;
    myHabitsList.forEach((habit) {
      if (habit.documentId == myHabit.documentId) {
        progressChange = habit.markAsDone(isDevTesting);
        if (progressChange != HabitProgressChange.FAIL && !isDevTesting) {
          try {
            firestore
                .collection("habits")
                .document(habit.documentId)
                .updateData(habit.toJson());
            logAnalyticsEvent(AnalyticsEvents.habitMarkDoneForToday,
                success: true);
          } catch (e) {
            logAnalyticsEvent(
              AnalyticsEvents.habitMarkDoneForToday,
              success: false,
              error: e.code,
            );
            habit = myHabit;
            progressChange = HabitProgressChange.FAIL;
          }
        }
      }
    });
    if (progressChange == HabitProgressChange.COMPLETE) {
      logAnalyticsEvent(AnalyticsEvents.habitMarkComplete, success: true);
      myHabitsList.remove(myHabit);
      habitsListAdd(myHabit);
    }
    notifyListeners();
    return progressChange;
  }
}
