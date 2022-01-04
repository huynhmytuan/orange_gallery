import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static final List<Map<String, ThemeMode>> themeModes = [
    {
      "settings.theme.system": ThemeMode.system,
    },
    {
      "settings.theme.light": ThemeMode.light,
    },
    {
      "settings.theme.dark": ThemeMode.dark,
    },
  ];

  late ThemeMode _themeMode;

  final box = Hive.box('Settings');

  Map get getThemeMode {
    var mode = box.get('theme');

    if (mode == null) {
      _themeMode = ThemeMode.system;
      String themeModeTitle = themeModes
          .firstWhere((mode) => mode.values.first == _themeMode)
          .keys
          .first;
      box.put('theme', themeModeTitle);
      return {'title': themeModeTitle, 'value': _themeMode};
    } else {
      var modeValues = box.get('theme');
      _themeMode = themeModes
          .firstWhere((mode) => mode.containsKey(modeValues))
          .values
          .first;
      return {'title': modeValues.toString(), 'value': _themeMode};
    }
  }

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    String themeModeTitle = themeModes
        .firstWhere((mode) => mode.values.first == _themeMode)
        .keys
        .first;
    box.put('theme', themeModeTitle);
    notifyListeners();
  }
}
