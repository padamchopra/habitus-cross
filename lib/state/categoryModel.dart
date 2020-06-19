import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/devTesting.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/state/habitoModel.dart';

mixin CategoryModel on ModelData {
  int numberOfCategories() {
    if (areCategoriesLoaded) {
      return myCategoriesList.length;
    } else {
      return -1;
    }
  }

  bool categoriesListReplace(MyCategory myCategory) {
    bool toReturn = false;
    myCategoriesList.forEach((element) {
      if (element.documentId == myCategory.documentId) {
        element = myCategory;
        toReturn = true;
      }
    });
    return toReturn;
  }

  MyCategory findCategoryById(String id) {
    if (!areCategoriesLoaded) {
      fetchCategories();
    }
    if (id == "") {
      return MyCategory();
    }
    return myCategoriesList.firstWhere(
      (element) => element.documentId == id,
      orElse: () => MyCategory(),
    );
  }

  Future<void> fetchCategories() async {
    if (isDevTesting) {
      myCategoriesList.addAll(DevTesting.getInitialCategories());
    } else if (firebaseUser != null) {
      myCategoriesList.clear();
      String userId = firebaseUser.uid;

      try {
        QuerySnapshot querySnapshot = await firestore
            .collection("categories")
            .where("uid", isEqualTo: userId)
            .where("deleted", isEqualTo: false)
            .orderBy("createdAt", descending: false)
            .getDocuments();
        for (DocumentSnapshot documentSnapshot in querySnapshot.documents) {
          MyCategory currentCategory = new MyCategory.fromFirebase(
            data: documentSnapshot.data,
            userId: userId,
            documentId: documentSnapshot.documentID,
          );
          myCategoriesList.add(currentCategory);
          notifyListeners();
        }
        logAnalyticsEvent(AnalyticsEvents.categoryFetch, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.categoryFetch,
          success: false,
          error: e.code,
        );
        myCategoriesList.clear();
      }

      myCategoriesList = myCategoriesList.toSet().toList();
      notifyListeners();
      areCategoriesLoaded = true;
    } else
      return;
  }

  Future<bool> addNewCategory(MyCategory myCategory) async {
    if (isDevTesting) {
      myCategory.documentId = "categoryId${myCategoriesList.length + 1}";
    } else if (firebaseUser != null) {
      myCategory.userId = firebaseUser.uid;
      try {
        DocumentReference documentReference =
            firestore.collection("categories").document();
        await documentReference.setData(myCategory.toJson());
        logAnalyticsEvent(AnalyticsEvents.categoryNew, success: true);
        myCategory.documentId = documentReference.documentID;
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.categoryNew,
          success: false,
          error: e.code,
        );
        return false;
      }
    } else
      return false;

    myCategoriesList.insert(0, myCategory);
    notifyListeners();
    return true;
  }

  Future<bool> updateCategory(MyCategory myCategory) async {
    if (isDevTesting) {
      myCategory.userId = DevTesting.userId;
    } else if (firebaseUser != null) {
      myCategory.userId = firebaseUser.uid;
      try {
        await firestore
            .collection("categories")
            .document(myCategory.documentId)
            .updateData(myCategory.toJson());
        logAnalyticsEvent(AnalyticsEvents.categoryUpdate, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.categoryUpdate,
          success: true,
          error: e.code,
        );
        return false;
      }
    } else
      return false;
    associateHabitsAndCategories();
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> deleteCategory(MyCategory myCategory) async {
    Map<String, dynamic> toReturn = {"deleted": false, "associatedHabits": []};
    List<MyHabit> myAssociatedHabits = [];
    myCategoriesList.forEach((category) {
      if (category.documentId == myCategory.documentId) {
        myAssociatedHabits = category.habitsList;
        category.deleted = true;
        try {
          if (!isDevTesting) {
            firestore
                .collection("categories")
                .document(category.documentId)
                .updateData(category.toJson());
            logAnalyticsEvent(AnalyticsEvents.categoryDelete, success: true);
          }
          toReturn["deleted"] = true;
        } catch (e) {
          logAnalyticsEvent(
            AnalyticsEvents.categoryDelete,
            success: false,
            error: e.code,
          );
          category.deleted = false;
          toReturn["deleted"] = false;
        }
      }
    });

    if (toReturn["deleted"]) {
      myCategoriesList.remove(myCategory);
      toReturn["associatedHabits"] = myAssociatedHabits;
    }
    return toReturn;
  }
}
