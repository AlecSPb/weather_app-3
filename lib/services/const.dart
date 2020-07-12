import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    canvasColor: Colors.blueGrey[900],
    primaryColor: Colors.blueGrey[900],
    brightness: Brightness.dark,
    accentColor: Colors.white,
    dividerColor: Colors.white30,
    textTheme: TextTheme(headline1: TextStyle(color: Colors.white)));

final lightTheme = ThemeData(
    canvasColor: Colors.white,
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    accentColor: Colors.white,
    dividerColor: Colors.black12,
    textTheme: TextTheme(headline1: TextStyle(color: Colors.black)));

final String infoText1 =
    'Для исправной работы приложения требуется включить сервис GPS для получения геопозиции пользователя и доступ в Интернет. Задать свою геопозицию можно с помощью поиска. Для этого зайдите в меню и введите местоположение (требуется доступ в Интернет), выберите нужный пункт. Есть возмжность смены темы приложения.';
final String infoText2 =
    'Данное приложение не используется в коммерческих целях и представляет собой ознокомительный вариант.';
final String infoText3 =
    'Данные предоставлены\nopenweathermap.org | opencagedata.com';
