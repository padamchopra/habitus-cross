import 'package:cloud_firestore/cloud_firestore.dart';

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
      _updateTimes.insert(0, timestamp);
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

  int markAsDone() {
    /// 0: success in updating
    /// 1: already updated today
    /// 2: more than 1 day in difference
    /// 3: completed 21 days
    /// 4: some other error
    if (_numberOfDays == 0) {
      ++_numberOfDays;
      _updateTimes.insert(0, Timestamp.now());
      return 0;
    }
    Timestamp latest = _updateTimes.asMap()[0];
    Timestamp today = Timestamp.now();
    if (today.toDate().month == latest.toDate().month) {
      if (today.toDate().day - latest.toDate().day > 1) {
        _updateTimes.clear();
        _numberOfDays = 0;
        return 2;
      } else if (today.toDate().day == latest.toDate().day) {
        return 1;
      } else {
        ++_numberOfDays;
        _updateTimes.insert(0, Timestamp.now());
        if (_numberOfDays == 21) {
          _finished = true;
          _finishedAt = Timestamp.now();
          return 3;
        }
        return 0;
      }
    } else if (today.toDate().month - latest.toDate().month <= 1) {
      if(latest.toDate().add(Duration(days: 1)).day == today.toDate().day){
        ++_numberOfDays;
        _updateTimes.insert(0, Timestamp.now());
        if (_numberOfDays == 21) {
          _finished = true;
          _finishedAt = Timestamp.now();
          return 3;
        }
        return 0;
      }else{
        return 2;
      }
    } else {
      return 4;
    }
  }

  Map<String, dynamic> toJson() => {
        "name": _title,
        "notes": _description,
        "createdAt": _createdAt,
        "finished": _finished,
        "finishedAt": FieldValue.serverTimestamp(),
        "category": _category,
        "numberOfDays": _numberOfDays,
        "updateTimes": _updateTimes,
        "deleted": _deleted,
        "uid": _userId,
      };
}
