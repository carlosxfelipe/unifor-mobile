import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _scaffoldColor = const Color(0xFFE4F2FD);

  ThemeMode get themeMode => _themeMode;
  Color get scaffoldColor => _scaffoldColor;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setScaffoldColor(Color color) {
    _scaffoldColor = color;
    notifyListeners();
  }
}
