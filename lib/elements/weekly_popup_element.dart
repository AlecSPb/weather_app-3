import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/forecast_models.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

class WeeklyMoreElement extends StatelessWidget {
  const WeeklyMoreElement({Key key, this.index, this.date}) : super(key: key);

  final int index;
  final String date;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    WeeklyForecast forecast =
        Provider.of<WeatherProvider>(context, listen: false)
            .forecast
            .weeklyForecast[index];
    WeatherProvider provider =
        Provider.of<WeatherProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: provider.gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(padding: EdgeInsets.zero, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      date,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  buildPanel(
                      theme: theme,
                      label: 'ПОГОДА',
                      icon: 'cloud',
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height: 75,
                              child:
                                  Image.asset('assets/${forecast.icon}.png')),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Ожидается:',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              forecast.weatherType.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                  buildPanel(
                      theme: theme,
                      label: 'ТЕМПЕРАТУРА',
                      icon: 'temp',
                      child: Column(
                        children: <Widget>[
                          buildRow(stringList: [
                            'Утром',
                            'Днем',
                            'Вечером',
                            'Ночью',
                          ], isBold: true),
                          buildRow(stringList: [
                            '${provider.getTemp(forecast.tempMorning)}°',
                            '${provider.getTemp(forecast.tempDay)}°',
                            '${provider.getTemp(forecast.tempEvening)}°',
                            '${provider.getTemp(forecast.tempNight)}°',
                          ], isBold: false, fontSize: 20),
                          customDividerText(text: 'Ощущается как'),
                          buildRow(stringList: [
                            '${provider.getTemp(forecast.feelsLikeMorning)}°',
                            '${provider.getTemp(forecast.feelsLikeDay)}°',
                            '${provider.getTemp(forecast.feelsLikeDay)}°',
                            '${provider.getTemp(forecast.feelsLikeNight)}°',
                          ], isBold: false, fontSize: 20),
                        ],
                      )),
                  buildPanel(
                      theme: theme,
                      label: 'ПРОЧЕЕ',
                      icon: 'other',
                      child: Column(
                        children: <Widget>[
                          buildRow(
                              stringList: ['Влажность', 'Давление', 'Облака'],
                              isBold: true),
                          buildRowSecondary(stringList: [
                            forecast.humidity,
                            forecast.pressure,
                            forecast.clouds,
                          ], signList: [
                            '%',
                            'мм.рт.\nст',
                            '%'
                          ], isBold: false, fontSize: 20),
                          customDividerText(),
                          buildRow(
                              stringList: ['Ветер', 'Направление', 'УФ-индекс'],
                              isBold: true),
                          buildRowSecondary(stringList: [
                            forecast.windSpeed,
                            forecast.windDirection,
                            forecast.uvi
                          ], signList: [
                            'м/c',
                            'wind',
                            ' '
                          ], isBold: false, fontSize: 20),
                        ],
                      )),
                  buildPanel(
                      theme: theme,
                      label: "ПРОДОЛЖИТЕЛЬНОСТЬ ДНЯ",
                      icon: 'sun_blur',
                      child: buildDayLenBlock(forecast)),
                ]),
              ),
            ),
          ),
        )
      ],
    );
  }

  Column buildDayLenBlock(WeeklyForecast forecast) {
    return Column(
      children: <Widget>[
        buildDayLenRow(
            childLeft: Image.asset('assets/icons/sunrise.png', height: 50),
            childMiddle: Image.asset('assets/icons/sun_line.png'),
            childRight: Image.asset(
              'assets/icons/sunset.png',
              height: 50,
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildDayLenRow(
              childLeft: Text(
                'Восход',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              childMiddle: Text(
                'Продолжительнось',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              childRight: Text(
                'Закат',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        buildDayLenRow(
            childLeft: Text(
              forecast.sunrise,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            childMiddle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                forecast.dayLength,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            childRight: Text(
              forecast.sunset,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            )),
        customDividerText(text: 'Местное время'),
        buildDayLenRow(
            childLeft: Text(
              forecast.localSunrise,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ),
            childMiddle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            childRight: Text(
              forecast.localSunset,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            )),
      ],
    );
  }

  Row buildDayLenRow({Widget childLeft, Widget childMiddle, childRight}) {
    return Row(
      children: <Widget>[
        Flexible(fit: FlexFit.tight, flex: 1, child: childLeft),
        Flexible(fit: FlexFit.tight, flex: 3, child: childMiddle),
        Flexible(fit: FlexFit.tight, flex: 1, child: childRight)
      ],
    );
  }

  Widget buildRowSecondary({
    List<String> stringList,
    List<String> signList,
    bool isBold,
    double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: stringList.map(
          (data) {
            String sign = signList[stringList.indexOf(data)];
            return Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize != null ? fontSize : null,
                            fontWeight:
                                isBold ? FontWeight.bold : FontWeight.normal),
                      ),
                      if (sign == 'wind')
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset(
                            'assets/wd/$data.png',
                            height: 35,
                          ),
                        )
                      else
                        Text(
                          ' ' + sign,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        )
                    ],
                  ),
                ));
          },
        ).toList(),
      ),
    );
  }

  Widget buildRow({List<String> stringList, bool isBold, double fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: stringList
            .map(
              (data) => Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      data,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: fontSize != null ? fontSize : null,
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal),
                    ),
                  )),
            )
            .toList(),
      ),
    );
  }

  Widget customDividerText({String text}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: text != null
                  ? const EdgeInsets.symmetric(horizontal: 8.0)
                  : EdgeInsets.zero,
              child: Container(
                height: 1,
                color: Colors.white54,
              ),
            ),
          ),
          if (text != null) Text(text),
          Expanded(
            child: Padding(
              padding: text != null
                  ? const EdgeInsets.symmetric(horizontal: 8.0)
                  : EdgeInsets.zero,
              child: Container(
                height: 1,
                color: Colors.white54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPanel(
      {@required ThemeData theme,
      @required String label,
      @required String icon,
      @required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.primaryColor.withOpacity(0.3)),
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Image.asset(
                      'assets/icons/$icon.png',
                      height: 25,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 0.0),
                  child: Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: child)
        ]),
      ),
    );
  }
}
