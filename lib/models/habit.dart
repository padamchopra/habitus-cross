import 'package:habito/models/category.dart';

class MyHabit {
  String _title;
  String _description;
  DateTime _createdAt;
  bool _finished;
  DateTime _finishedAt;
  MyCategory _category;
  int _numberOfDays;
  List<DateTime> _updateTimes;
  bool _deleted;

  MyHabit() {
    this._createdAt = DateTime.now();
    this._finished = false;
    this._finishedAt = _createdAt.add(Duration(days: 21));
    this._category = MyCategory();
    this._numberOfDays = 0;
    this._updateTimes = [];
  }

  set habitTitle(String title) {
    this._title = title;
  }

  set habitDescription(String description) {
    this._description = description;
  }

  set habitFinished(bool finished) {
    this._finished = finished;
    this._finishedAt = DateTime.now();
  }

  set habitCategory(MyCategory category) {
    this._category = category;
  }

  set habitDeleted(bool delete){
    this._deleted = delete;
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
        if(_numberOfDays>=21){
          this._finished = true;
          this._finishedAt = DateTime.now();
          return 3;
        }else{
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
    if(_updateTimes.length == 0 || (DateTime.now().day - _updateTimes[0].day)==1){
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

  get habitTitle{
    return _title;
  }

  get habitDescription{
    return _description;
  }

  get habitFinished {
    return _finished;
  }

  get habitFinishedAt {
    return _finishedAt;
  }

  get habitCategory {
    return _category;
  }

  get habitDeleted {
    return _deleted;
  }
}
