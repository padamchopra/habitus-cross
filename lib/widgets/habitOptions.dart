import 'package:flutter/material.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/universalValues.dart';

class HabitOptions extends StatefulWidget {
  final int index;
  final MyHabit myHabit;
  final Function toggle;
  HabitOptions(this.index, this.myHabit, this.toggle);

  @override
  State<StatefulWidget> createState() {
    return _HabitOptionsState();
  }
}

class _HabitOptionsState extends State<HabitOptions> {
  EdgeInsets doneButtonMargin = UniversalValues.marginForHabitCloseOption;
  EdgeInsets viewMoreButtonMargin = UniversalValues.marginForHabitCloseOption;
  EdgeInsets parentMargin = EdgeInsets.only(right: 42);

  initState() {
    super.initState();
    new Future.delayed(Duration(milliseconds: 10)).then((_) {
      setState(() {
        doneButtonMargin = UniversalValues.marginForHabitDoneOption;
        viewMoreButtonMargin = UniversalValues.marginForHabitViewMoreOption;
        parentMargin = EdgeInsets.all(0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
      margin: parentMargin,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print("clicked mark done");
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate,
              margin: doneButtonMargin,
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: HabitoColors.habitOption,
                boxShadow: [
                  BoxShadow(
                    color: HabitoColors.backdropBlack,
                    spreadRadius: 3,
                    blurRadius: 3,
                  )
                ],
              ),
              child: Icon(
                Icons.check,
                color: HabitoColors.placeholderGrey,
                size: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("clicked view more");
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate,
              margin: viewMoreButtonMargin,
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: HabitoColors.habitOption,
                boxShadow: [
                  BoxShadow(
                    color: HabitoColors.backdropBlack,
                    spreadRadius: 3,
                    blurRadius: 3,
                  )
                ],
              ),
              child: Icon(
                Icons.remove_red_eye,
                color: HabitoColors.placeholderGrey,
                size: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("clicked close options");
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.decelerate,
              margin: UniversalValues.marginForHabitCloseOption,
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: HabitoColors.placeholderGrey,
                boxShadow: [
                  BoxShadow(
                    color: HabitoColors.backdropBlack,
                    spreadRadius: 6,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Icon(
                Icons.close,
                color: HabitoColors.habitOption,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
