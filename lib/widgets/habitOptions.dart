import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/habit.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/models/universalValues.dart';
import 'package:scoped_model/scoped_model.dart';

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
  EdgeInsets parentMargin = UniversalValues.marginForParentOption;
  Color doneButtonColor = HabitoColors.habitOption;
  Color doneButtonIconColor = HabitoColors.placeholderGrey;

  initState() {
    super.initState();
    List<Timestamp> updateTimes = widget.myHabit.updateTimes;
    if(updateTimes.length>0 && updateTimes.asMap()[0].toDate().day == DateTime.now().day){
      doneButtonColor = HabitoColors.success;
      doneButtonIconColor = HabitoColors.white;
    }
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
          ScopedModelDescendant<HabitoModel>(
            builder: (context, child, model) {
              return GestureDetector(
                onTap: () {
                  int resultCode = model.markDoneForToday(widget.myHabit);
                  if(resultCode==0){
                    setState(() {
                      doneButtonColor = HabitoColors.success;
                      doneButtonIconColor = HabitoColors.white;
                    });
                  }else if(resultCode==1){
                    model.neverSatisfied(context, "Slow down", "You've already marked your progress for this habit today.");
                  }else if(resultCode==2){
                    model.neverSatisfied(context, "Woops", "Looks like you missed a day or more. Progress has been reset.");
                  }else if(resultCode==3){
                    model.neverSatisfied(context, "Congrats", "You've successfully managed to keep up for 21 days. Tracking for this habit is now complete.");
                  }else{
                    model.neverSatisfied(context, "Try Again", "Could not update your progress.");
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  margin: doneButtonMargin,
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: doneButtonColor,
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
                    color: doneButtonIconColor,
                    size: 18,
                  ),
                ),
              );
            },
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
            onTap: () => widget.toggle(widget.index),
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
