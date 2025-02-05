import 'package:flutter/material.dart';

class ThemeLogic extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  void changeToDark() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }

  void changeToLight() {
    _mode = ThemeMode.light;
    notifyListeners();
  }

  void changeSystem() {
    _mode = ThemeMode.system;
    notifyListeners();
  }
}
