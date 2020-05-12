import 'package:flutter/material.dart';
import 'package:habito/models/habitoModel.dart';
import 'package:habito/widgets/text.dart';
import 'package:scoped_model/scoped_model.dart';

class Profile extends StatelessWidget {
  final Function updateUserState;
  Profile(this.updateUserState);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HabitoModel>(
      builder: (BuildContext context, Widget child, HabitoModel model) {
        return Center(
          child: FlatButton(
            onPressed: () async {
              await model.signOut();
              updateUserState();
            },
            child: CustomText("Logout"),
          ),
        );
      },
    );
  }
}
