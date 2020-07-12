import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/const.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  ThemeProvider(this._themeData, this._isDark);

  bool _isDark;

  ThemeData get themeData => _themeData;

  void _setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  changeTheme() async {
    if (!_isDark) {
      _setThemeData(darkTheme);
    } else {
      _setThemeData(lightTheme);
    }

    _isDark = !_isDark;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', _isDark);
  }
}
