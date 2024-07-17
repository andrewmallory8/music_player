import 'package:musicplayer/themes/dark_mode.dart';
import 'package:musicplayer/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { light, dark }

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightmode;

  ThemeProvider() {
    // Default to light theme mode
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = themeData == lightmode ? darkMode : lightmode;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('theme_mode');
    if (savedThemeMode != null) {
      _themeData = savedThemeMode == "darkmode" ? darkMode : lightmode;
    } else {
      _themeData = lightmode;
    }
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', isDarkMode ? "darkmode" : "lightmode");
  }
}
