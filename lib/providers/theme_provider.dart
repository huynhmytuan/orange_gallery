import 'package:flutter/material.dart';
import '../constants.dart';

class ThemeProvider extends ChangeNotifier {
  static final List<Map<String, ThemeMode>> themeModes = [
    {
      'System': ThemeMode.system,
    },
    {
      'Light': ThemeMode.light,
    },
    {
      'Dark': ThemeMode.dark,
    },
  ];

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get getThemeMode {
    return _themeMode;
  }

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
