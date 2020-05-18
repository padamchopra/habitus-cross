import 'package:cloud_firestore/cloud_firestore.dart';

class MyHabit {
  String _title;
  String _description;
  DateTime _createdAt;
  bool _finished;
  DateTime _finishedAt;
  String _category;
  int _numberOfDays;
  List<DateTime> _updateTimes;
  bool _deleted;
  String _userId;
  String _documentId;

  MyHabit() {
    this._finished = false;
    this._category = "";
    this._numberOfDays = 0;
    this._updateTimes = [];
    this._deleted = false;
  }

  set title(String title) {
    this._title = title;
  }

  set documentId(String id) {
    this._documentId = id;
  }

  set createdAt(DateTime date) {
    this._createdAt = date;
  }

  set finishedAt(DateTime date) {
    this._finishedAt = date;
  }

  set description(String description) {
    this._description = description;
  }

  set isFinished(bool finished) {
    this._finished = finished;
    this._finishedAt = DateTime.now();
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

  set updateTimes(List<DateTime> updates) {
    this._updateTimes = updates;
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

  int markDoneForToday() {
    /// 0: success in updating
    /// 1: already updated today
    /// 2: more than 1 day in difference
    /// 3: completed 21 days
    if (!alreadyUpdated()) {
      //not updated today
      DateTime now = DateTime.now();
      if (checkIfOnTrack()) {
        this._numberOfDays++;
        this._updateTimes.insert(0, now);
        if (_numberOfDays >= 21) {
          this._finished = true;
          this._finishedAt = DateTime.now();
          return 3;
        } else {
          return 0;
        }
      } else {
        return 2;
      }
    } else {
      return 1;
    }
  }

  bool checkIfOnTrack() {
    if (_updateTimes.length == 0 ||
        (DateTime.now().day - _updateTimes[0].day) == 1) {
      return true;
    }
    return false;
  }

  bool alreadyUpdated() {
    if (_updateTimes.length == 0) return false;
    DateTime lastUpdate = _updateTimes[0];
    if (lastUpdate.day == DateTime.now().day) return true;
    return false;
  }

  void setUpdateTimesFromFirestore(List<dynamic> updates) {
    updates.forEach((element) {
      Timestamp current = element;
      this._updateTimes.add(current.toDate());
    });
  }

  Map<String, dynamic> toJson() => {
        "name": _title,
        "notes": _description,
        "createdAt": FieldValue.serverTimestamp(),
        "finished": _finished,
        "finishedAt": FieldValue.serverTimestamp(),
        "category": _category,
        "numberOfDays": _numberOfDays,
        "updateTimes": _updateTimes,
        "deleted": _deleted,
        "uid": _userId,
      };
}
