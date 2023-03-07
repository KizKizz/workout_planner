import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  int _instructionPageIndex = 1;

  int get instructionPageIndex => _instructionPageIndex;

  void instructionPageSet(int i) {
    _instructionPageIndex = i;
    notifyListeners();
  }
  void instructionPageReset() {
    _instructionPageIndex = 1;
    notifyListeners();
  }
}
