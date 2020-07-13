import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/const.dart';

//СМЕНА ТЕМЫ на светлую или темную

class ThemeProvider extends ChangeNotifier {
  //настройки темы
  ThemeData _themeData;
  //коструктор
  ThemeProvider(this._themeData, this._isDark);

  //булевая переменная, true - тем., false - светл.
  bool _isDark;
  
  //геттер темы
  ThemeData get themeData => _themeData;

  //установка темы
  void _setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //смена темы
  changeTheme() async {
    if (!_isDark) {
      _setThemeData(darkTheme);
    } else {
      _setThemeData(lightTheme);
    }

    _isDark = !_isDark;
    //запись настройки в память
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', _isDark);
  }
}
