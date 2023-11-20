import 'package:flutter/material.dart';
import 'package:mini_social/utils/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lighTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lighTheme) {
      themeData = darkTheme;
    } else {
      themeData = lighTheme;
    }
  }
}
