import 'package:flutter/material.dart';

class ModeProvider with ChangeNotifier {
  bool _lightModeEnable = true;

  bool get lightModeEnable => _lightModeEnable;

  set lightModeEnable(bool value) {
    _lightModeEnable = value;
    notifyListeners();
  }

  void changeMode() {
    _lightModeEnable = !_lightModeEnable;
    notifyListeners();
  }
}