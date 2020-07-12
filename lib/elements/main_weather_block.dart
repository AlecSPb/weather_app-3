import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/elements/term_element.dart';
import 'package:weather_app/elements/hourly_element.dart';
import 'package:weather_app/services/provider.dart';

class MainWeatherBlock extends StatelessWidget {
  MainWeatherBlock({Key key}) : super(key: key);

  String getText(WeatherProvider providerType) {
    String text, tmp;
    text = providerType.fullPosition.country;
    tmp = providerType.fullPosition.administrativeArea;
    if (tmp != '') {
      text += ', ' + tmp;
    }
    tmp = providerType.fullPosition.subAdministrativeArea;
    if (tmp != '') {
      text += ', ' + tmp;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider providerType =
        Provider.of<WeatherProvider>(context, listen: false);
    ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FadeIn(
            child: providerType.fullPosition != null
                ? Text(
                    getText(providerType),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: theme.accentColor),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )
                : null),
        Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              flex: 5,
                              child: Image.asset(
                                'assets/${providerType.forecast.icon}.png',
                              )),
                          Expanded(
                            flex: 5,
                            child: FittedBox(
                                child: Text(
                              !providerType.isLoading
                                  ? '${providerType.getTemp(providerType.forecast.temperature)}°'
                                  : '~°',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.rajdhani(
                                  fontWeight: FontWeight.w600,
                                  color: theme.accentColor),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, bottom: 8.0, right: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: theme.primaryColor.withOpacity(0.3)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TermElement(
                                  text: !providerType.isLoading
                                      ? '${providerType.getTemp(providerType.forecast.feelsLike)}'
                                      : '~',
                                  sign: '°',
                                  icon: 'feels_like'),
                              TermElement(
                                  text: !providerType.isLoading
                                      ? providerType.forecast.pressure
                                      : '~',
                                  sign: 'мм.рт.ст',
                                  icon: 'pressure'),
                              TermElement(
                                  text: !providerType.isLoading
                                      ? providerType.forecast.humidity
                                      : '~',
                                  sign: '%',
                                  icon: 'humidity'),
                              TermElement(
                                  text: !providerType.isLoading
                                      ? providerType.forecast.windSpeed
                                      : '~',
                                  sign: 'м/c',
                                  icon: 'wind_speed'),
                              TermElement(
                                text: !providerType.isLoading
                                    ? providerType.forecast.windDirecton
                                    : '~',
                                icon: 'wind_dir',
                                windDirection:
                                    providerType.forecast.windDirecton,
                              ),
                              TermElement(
                                  text: !providerType.isLoading
                                      ? providerType.forecast.clouds
                                      : '~',
                                  sign: '%',
                                  icon: 'clouds'),
                              TermElement(
                                  text: !providerType.isLoading
                                      ? providerType.forecast.uvi
                                      : '~',
                                  sign: '',
                                  icon: 'uvi'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FittedBox(
                child: Text(
                  providerType.forecast.nowCloudness,
                  style: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.w600, color: theme.accentColor),
                ),
              ),
            )),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListView.builder(
                  itemCount: 24,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Consumer<WeatherProvider>(
                          builder: (context, weather, child) {
                        return ForecastElement(
                          data: weather.isLoading
                              ? null
                              : weather.forecast.hourlyForecast[index],
                          index: index,
                        );
                      })),
            ),
          ),
        )
      ],
    );
  }
}
