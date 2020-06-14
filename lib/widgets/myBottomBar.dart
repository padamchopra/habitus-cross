import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';

class MyBottomBar extends StatelessWidget {
  final int currentPage;
  final Function function;
  MyBottomBar(this.currentPage, this.function);

  Widget barIcon(IconData icon, int index) {
    return IconButton(
      color: MyColors.placeholderGrey,
      icon: Icon(
        icon,
        color: currentPage == index ? MyColors.perfectBlue : null,
        size: 27,
      ),
      onPressed: () => function(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: MyColors.midnight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            barIcon(Icons.home, 0),
            barIcon(Icons.apps, 1),
            SizedBox(
              width: 60,
            ),
            barIcon(Icons.assignment_turned_in, 2),
            barIcon(currentPage == 3 ? Icons.person : Icons.perm_identity, 3),
          ],
        ),
      ),
    );
  }
}
