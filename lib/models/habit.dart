import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/category.dart';
import 'package:habito/models/enums.dart';
import 'package:habito/widgets/habit/habitTile.dart';
import 'package:habito/widgets/habit/habitTileUnderCategory.dart';

class MyHabit {
  String _title;
  String _description;
  Timestamp _createdAt;
  bool _finished;
  Timestamp _finishedAt;
  String _category;
  int _numberOfDays;
  List<Timestamp> _updateTimes;
  bool _deleted;
  String _userId;
  String _documentId;

  MyHabit() {
    this._finished = false;
    this._category = "";
    this._numberOfDays = 0;
    this._updateTimes = [];
    this._deleted = false;
    this._createdAt = Timestamp.now();
    this._finishedAt = Timestamp.now();
  }

  MyHabit.fromFirebase({
    @required Map<String, dynamic> data,
    @required String documentId,
  }) {
    this._title = data["name"];
    this._description = data["notes"];
    this._createdAt = data["createdAt"];
    this._finished = data["finished"];
    if (_finished) {
      this._finishedAt = data["finishedAt"];
    }else{
      this._finishedAt = Timestamp.now();
    }
    this._category = data["category"];
    this._numberOfDays = data["numberOfDays"];
    this._deleted = data["deleted"];
    this._userId = data["uid"];
    this._documentId = documentId;
    this._updateTimes = [];
    data["updateTimes"].forEach((element) {
      Timestamp timestamp = element;
      this._updateTimes.add(timestamp);
    });
  }

  MyHabit.fromHabit(MyHabit myHabit) {
    this._title = myHabit.title;
    this._description = myHabit.description;
    this._createdAt = myHabit.createdAt;
    this._finished = myHabit.isFinished;
    this._finishedAt = myHabit.finishedAt;
    this._category = myHabit.category;
    this._numberOfDays = myHabit.numberOfDays;
    this._updateTimes = myHabit.updateTimes;
    this._deleted = myHabit.isDeleted;
    this._userId = myHabit.userId;
    this._documentId = myHabit.documentId;
  }

  set title(String title) {
    this._title = title;
  }

  set documentId(String id) {
    this._documentId = id;
  }

  set createdAt(Timestamp date) {
    this._createdAt = date;
  }

  set finishedAt(Timestamp date) {
    this._finishedAt = date;
  }

  set description(String description) {
    this._description = description;
  }

  set isFinished(bool finished) {
    this._finished = finished;
    this._finishedAt = Timestamp.now();
  }

  set category(String category) {
    this._category = category;
  }

  set isDeleted(bool delete) {
    this._deleted = delete;
  }

  set userId(String userId) {
    this._userId = userId;
  }

  set daysCompleted(int days) {
    this._numberOfDays = days;
  }

  set updateTimes(List<dynamic> updates) {
    updates.forEach((element) {
      Timestamp timestamp = element;
      _updateTimes.add(timestamp);
    });
  }

  get title {
    return _title;
  }

  get documentId {
    return _documentId;
  }

  get description {
    return _description;
  }

  get createdAt {
    return _createdAt;
  }

  get isFinished {
    return _finished;
  }

  get finishedAt {
    return _finishedAt;
  }

  get category {
    return _category;
  }

  get isDeleted {
    return _deleted;
  }

  get userId {
    return _userId;
  }

  get daysCompleted {
    return _numberOfDays;
  }

  get updateTimes {
    return _updateTimes;
  }

  get numberOfDays {
    return _numberOfDays;
  }

  HabitProgressChange markAsDone(bool override) {
    if (override) {
      ++_numberOfDays;
      _updateTimes.insert(0, Timestamp.now());
      if (_numberOfDays == 21) {
        _finished = true;
        _finishedAt = Timestamp.now();
        return HabitProgressChange.COMPLETE;
      }
      return HabitProgressChange.SUCCESS;
    }
    if (_numberOfDays == 0) {
      ++_numberOfDays;
      _updateTimes.insert(0, Timestamp.now());
      return HabitProgressChange.SUCCESS;
    }
    DateTime latest = _updateTimes[0].toDate();
    DateTime today = DateTime.now();
    if (today.month == latest.month) {
      if (today.day - latest.day > 1) {
        _updateTimes.clear();
        _numberOfDays = 0;
        return HabitProgressChange.LATE;
      } else if (today.day == latest.day) {
        return HabitProgressChange.UPDATED_TODAY;
      } else {
        ++_numberOfDays;
        _updateTimes.insert(0, Timestamp.now());
        if (_numberOfDays == 21) {
          _finished = true;
          _finishedAt = Timestamp.now();
          return HabitProgressChange.COMPLETE;
        }
        return HabitProgressChange.SUCCESS;
      }
    } else if (today.month - latest.month <= 1) {
      if (latest.add(Duration(days: 1)).day == today.day) {
        ++_numberOfDays;
        _updateTimes.insert(0, Timestamp.now());
        if (_numberOfDays == 21) {
          _finished = true;
          _finishedAt = Timestamp.now();
          return HabitProgressChange.COMPLETE;
        }
        return HabitProgressChange.SUCCESS;
      }
      _updateTimes.clear();
      _numberOfDays = 0;
      return HabitProgressChange.LATE;
    }
    return HabitProgressChange.FAIL;
  }

  void resetProgress() {
    _finished = false;
    _numberOfDays = 0;
    _updateTimes.clear();
  }

  Widget widget(MyCategory myCategory) {
    return HabitTile(this, myCategory);
  }

  Widget underCategoryWidget(MyCategory myCategory) {
    return HabitTileUnderCategory(this, myCategory);
  }

  Map<String, dynamic> toJson() => {
        "name": _title,
        "notes": _description,
        "createdAt": _createdAt,
        "finished": _finished,
        "finishedAt": _finishedAt,
        "category": _category,
        "numberOfDays": _numberOfDays,
        "updateTimes": _updateTimes,
        "deleted": _deleted,
        "uid": _userId,
      };

  Map<String, dynamic> updatedJson() => {
        "name": _title,
        "notes": _description,
        "category": _category,
      };
}
