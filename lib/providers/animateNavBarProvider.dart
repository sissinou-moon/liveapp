import 'package:flutter/material.dart';

class AnimationProvider with ChangeNotifier {
  late AnimationController animationController;
  bool show = true;

  void initializeController(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );
  }

  void triggerAnimation() {
    if(show) {
      animationController.forward();
      Future.delayed(Duration(milliseconds: 200), () {
        show = false;
      });
    }else {
      show = true;
      animationController.reverse();
    }
    notifyListeners(); // Notify listeners about the state change
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}