import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/elements/term_element.dart';
import 'package:weather_app/services/forecast.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

class HourlyMoreElement extends StatelessWidget {
  const HourlyMoreElement({Key key, this.time, this.index}) : super(key: key);

  final String time;
  final int index;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Forecast provider =
        Provider.of<WeatherProvider>(context, listen: false).forecast;
    return Column(
      children: <Widget>[
        Expanded(flex: 7, child: Container()),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              textStyle: TextStyle(color: theme.accentColor),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  decoration: BoxDecoration(
                    gradient:
                        Provider.of<WeatherProvider>(context, listen: false)
                            .gradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            buildLeftTopBlock(theme, provider),
                            buildLeftMiddleBlock(theme, provider),
                            buildLeftBottomBlock(theme, provider)
                          ],
                        ),
                      ),
                      buildRightBlock(theme, provider, context),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Flexible buildRightBlock(
      ThemeData theme, Forecast forecast, BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 4.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            height: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.primaryColor.withOpacity(0.3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TermElement(
                  text:
                      '${Provider.of<WeatherProvider>(context, listen: false).getTemp(forecast.hourlyForecast[index].temp)}',
                  icon: 'temp',
                  sign: '°',
                ),
                TermElement(
                  text:
                      '${Provider.of<WeatherProvider>(context, listen: false).getTemp(forecast.hourlyForecast[index].feelsLike)}',
                  icon: 'feels_like',
                  sign: '°',
                ),
                TermElement(
                  text: forecast.hourlyForecast[index].pressure,
                  icon: 'pressure',
                  sign: 'мм.рт.ст',
                ),
                TermElement(
                  text: forecast.hourlyForecast[index].humidity,
                  icon: 'humidity',
                  sign: '%',
                ),
                TermElement(
                  text: forecast.hourlyForecast[index].windSpeed,
                  icon: 'wind_speed',
                  sign: 'м/c',
                ),
                TermElement(
                    text: forecast.hourlyForecast[index].windDirection,
                    icon: 'wind_dir',
                    windDirection:
                        forecast.hourlyForecast[index].windDirection),
                TermElement(
                  text: forecast.hourlyForecast[index].clouds,
                  icon: 'clouds',
                  sign: '%',
                ),
              ],
            )),
      ),
    );
  }

  Flexible buildLeftBottomBlock(ThemeData theme, Forecast forecast) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 4,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 4.0, top: 4.0, bottom: 8.0),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.primaryColor.withOpacity(0.3)),
          child: Column(
            children: <Widget>[
              Flexible(
                  flex: 3,
                  child: Image.asset(
                      'assets/${forecast.hourlyForecast[index].icon}.png')),
              Flexible(
                  flex: 1,
                  child: Text(
                    forecast.hourlyForecast[index].weatherType,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Flexible buildLeftMiddleBlock(ThemeData theme, Forecast forecast) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 3,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 4.0, top: 4.0, bottom: 4.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.primaryColor.withOpacity(0.3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Местное время: ',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                forecast.hourlyForecast[index].localTime,
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Text(
                'Часовая зона: ',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                forecast.timezone,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flexible buildLeftTopBlock(ThemeData theme, Forecast forecast) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 4.0, top: 8.0, bottom: 4.0),
        child: Container(
          padding: EdgeInsets.all(4.0),
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.primaryColor.withOpacity(0.3)),
          child: Center(
            child: Text(
              time,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
