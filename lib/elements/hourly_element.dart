import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/elements/hourly_popup_element.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/forecast_models.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

//виджет ежечасного прогноза

class ForecastElement extends StatefulWidget {
  ForecastElement({Key key, this.data, this.index}) : super(key: key);

  //объект класса с данными
  final HourlyForecast data;
  //номер виджета
  final int index;

  @override
  _ForecastElementState createState() => _ForecastElementState();
}

class _ForecastElementState extends State<ForecastElement> {
  //если нажата, проигрывается простая анимация
  bool isActivated = false;

  //вызов диалога с более подробной информацией
  void showHourlyDialog(BuildContext context, int index, String time) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        //вилдет с более подробной информацией
        return HourlyMoreElement(
          time: time,
          index: index,
        );
      },
      //builder перехода
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
              .chain(CurveTween(curve: Curves.decelerate))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //доступ к настройкам темы
    ThemeData theme = Theme.of(context);
    //доступ в логике
    WeatherProvider provider =
        Provider.of<WeatherProvider>(context, listen: false);
    //сам виджет
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.primaryColor.withOpacity(0.3)),
            child: widget.data != null
              //если данных нет, возвращается загрузочный элемент (shimmer)
                ? FadeIn(
                    child: FlatButton(
                      splashColor: provider.secondAccent,
                      //вызов подробной информации и анимации
                      onPressed: () {
                        setState(() {
                          isActivated = true;
                        });
                        showHourlyDialog(
                            context, widget.index, widget.data.time);
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            isActivated = false;
                          });
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                              flex: 1,
                              child: Text(
                                widget.data.time,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: theme.accentColor),
                              )),
                          Flexible(
                              flex: 1,
                              child: Text(
                                  '${provider.getTemp(widget.data.temp)}°',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, color: theme.accentColor))),
                          Flexible(
                              flex: 1,
                              child: Image.asset(
                                'assets/${widget.data.icon}.png',
                                color: theme.accentColor,
                              )),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: 5,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isActivated
                                    ? provider.secondAccent
                                    : theme.accentColor.withOpacity(0.2)),
                          ),
                        ],
                      ),
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: theme.primaryColor,
                    highlightColor: provider.secondAccent.withOpacity(0.5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: theme.primaryColor.withOpacity(0.3)),
                    ))),
      ),
    );
  }
}
