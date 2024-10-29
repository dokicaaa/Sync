import 'package:flutter/material.dart';
import 'package:portfolio_app/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  ThemeProvider() {
    loadTheme();
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
    saveTheme(isDarkMode);
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      setThemeData(darkMode);
    } else {
      setThemeData(lightMode);
    }
  }

  void saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? darkMode : lightMode;
    notifyListeners();
  }
}
