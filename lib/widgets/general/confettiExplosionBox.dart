import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:habito/models/universalValues.dart';
import 'dart:math' as Math;

class ConfettiExplosionBox extends StatelessWidget {
  final ConfettiController confettiController;
  ConfettiExplosionBox(this.confettiController);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConfettiWidget(
          confettiController: confettiController,
          blastDirection: -Math.pi / 2,
          blastDirectionality: BlastDirectionality.explosive,
          colors: MyColors.standardColorsList,
          emissionFrequency: 1,
          numberOfParticles: 40,
          particleDrag: 0.04,
          shouldLoop: false,
          maxBlastForce: 80,
          minBlastForce: 5,
          gravity: 0.1,
        ),
      ),
    );
  }
}
