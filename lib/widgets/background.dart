import 'package:flutter/material.dart';

class Background extends StatelessWidget{
  final Color color;
  Background(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: color,
    );
  }
}