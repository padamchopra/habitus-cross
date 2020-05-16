import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'package:habito/pages/allCategories.dart';
import 'package:habito/pages/allHabits.dart';
import 'package:habito/pages/profile.dart';
import 'package:habito/pages/signup.dart';
import 'package:habito/widgets/newCategoryModal.dart';
import 'package:habito/widgets/text.dart';

class Home extends StatefulWidget {
  final Function updateUserState;
  Home(this.updateUserState);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  static PageController controller = PageController(
    initialPage: 0,
  );

  void changeScreen(int pageNo) {
    setState(() {
      currentPage = pageNo;
    });
    controller.animateToPage(pageNo,
        duration: Duration(milliseconds: 400), curve: Curves.easeOutCirc);
  }

  Widget _buildAddButton(IconData symbol, String name, Function function) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: HabitoColors.buttonBlueBackground,
          ),
          child: IconButton(
            //TODO: Link progress function
            onPressed: () {
              function();
            },
            icon: Icon(
              symbol,
              size: 30,
              color: HabitoColors.perfectBlue,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        CustomText(
          name,
          fontSize: 15,
          color: HabitoColors.black,
          letterSpacing: 0.2,
        ),
      ],
    );
  }

  void addNewCategory(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext _context) {
        return NewCategoryModal();
      },
    );
  }

  void showMyBottomModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext _context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 0),
            height: 360,
            width: double.infinity,
            decoration: BoxDecoration(
              color: HabitoColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(42),
                topRight: Radius.circular(42),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildAddButton(Icons.lightbulb_outline, "Habit", null),
                    _buildAddButton(Icons.label_outline, "Category",
                        () => addNewCategory(context)),
                    _buildAddButton(Icons.share, "Share", null),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: HabitoColors.perfectBlue,
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: HabitoColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: HabitoColors.black,
      //Suggestion: If you want to make notch transparent
      //extendBody: true,
      body: PageView(
        controller: controller,
        onPageChanged: (int pageNo) {
          setState(() {
            currentPage = pageNo;
          });
        },
        scrollDirection: Axis.horizontal,
        //TODO: Change pages here
        children: <Widget>[
          AllHabits(),
          AllCategories(),
          Signup(),
          Profile(widget.updateUserState),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyBottomModal(context);
        },
        backgroundColor: HabitoColors.white,
        child: Icon(
          Icons.add,
          color: HabitoColors.perfectBlue,
          size: 39,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: HabitoColors.midnight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                color: HabitoColors.placeholderGrey,
                icon: Icon(
                  Icons.home,
                  color: currentPage == 0 ? HabitoColors.perfectBlue : null,
                  size: 27,
                ),
                onPressed: () {
                  changeScreen(0);
                },
              ),
              IconButton(
                color: HabitoColors.placeholderGrey,
                icon: Icon(
                  Icons.apps,
                  color: currentPage == 1 ? HabitoColors.perfectBlue : null,
                  size: 27,
                ),
                onPressed: () {
                  changeScreen(1);
                },
              ),
              SizedBox(
                width: 60,
              ),
              IconButton(
                color: HabitoColors.placeholderGrey,
                icon: Icon(
                  Icons.assignment_turned_in,
                  color: currentPage == 2 ? HabitoColors.perfectBlue : null,
                  size: 27,
                ),
                onPressed: () {
                  changeScreen(2);
                },
              ),
              IconButton(
                color: HabitoColors.placeholderGrey,
                icon: Icon(
                  currentPage == 3 ? Icons.person : Icons.perm_identity,
                  color: currentPage == 3 ? HabitoColors.perfectBlue : null,
                  size: 27,
                ),
                onPressed: () {
                  changeScreen(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
