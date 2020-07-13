import 'package:flutter/material.dart';

//расширение стандартного "перехода"
//в данном случае Fade (плавный переход)
class FadeRoute extends PageRouteBuilder {
  //получает как аргумент страницу, на которую нужно перейти
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
