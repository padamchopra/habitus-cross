import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habito/models/analyticsEvents.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/devTesting.dart';
import 'package:habito/state/habitoModel.dart';

mixin CategoryModel on ModelData {
  int numberOfCategories() {
    if (areCategoriesLoaded) {
      return myCategories.length;
    } else {
      return -1;
    }
  }

  bool categoriesListReplace(MyCategory myCategory) {
    if (myCategories.containsKey(myCategory.documentId)) {
      myCategories[myCategory.documentId] = myCategory;
      return true;
    }
    return false;
  }

  MyCategory getCategoryById(String id) {
    if (id != "" && myCategories.containsKey(id)) {
      return myCategories[id];
    } else {
      if (!areCategoriesLoaded) fetchCategories();
      return MyCategory();
    }
  }

  Future<void> fetchCategories() async {
    if (isDevTesting) {
      myCategories = DevTesting.getInitialCategories();
    } else if (firebaseUser != null) {
      myCategories.clear();
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
          myCategories[documentSnapshot.documentID] = currentCategory;
          notifyListeners();
        }
        logAnalyticsEvent(AnalyticsEvents.categoryFetch, success: true);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.categoryFetch,
          success: false,
          error: e.toString(),
        );
        myCategories.clear();
      }

      notifyListeners();
      areCategoriesLoaded = true;
    } else
      return;
  }

  Future<bool> addNewCategory(MyCategory myCategory) async {
    if (isDevTesting) {
      myCategory.documentId = "categoryId${myCategories.length + 1}";
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
          error: e.toString(),
        );
        return false;
      }
    } else
      return false;

    myCategories[myCategory.documentId] = myCategory;
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
          error: e.toString(),
        );
        return false;
      }
    } else
      return false;
    notifyListeners();
    return true;
  }

  Future<Map<String, bool>> deleteCategory(MyCategory myCategory) async {
    Map<String, bool> myAssociatedHabits = new Map();

    if (myCategories.containsKey(myCategory.documentId)) {
      MyCategory mySavedCategory = myCategories[myCategory.documentId];
      try {
        mySavedCategory.deleted = true;
        if (!isDevTesting) {
          firestore
              .collection("categories")
              .document(mySavedCategory.documentId)
              .updateData(mySavedCategory.toJson());
          logAnalyticsEvent(AnalyticsEvents.categoryDelete, success: true);
        }
        myAssociatedHabits = mySavedCategory.habitsMap;
        myCategories.remove(myCategory.documentId);
      } catch (e) {
        logAnalyticsEvent(
          AnalyticsEvents.categoryDelete,
          success: false,
          error: e.toString(),
        );
        myAssociatedHabits.clear();
      }
    }
    return myAssociatedHabits;
  }
}
