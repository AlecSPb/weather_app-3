import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/elements/weekly_popup_element.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';

class BottomWeatherBlock extends StatefulWidget {
  BottomWeatherBlock({Key key}) : super(key: key);

  @override
  _BottomWeatherBlockState createState() => _BottomWeatherBlockState();
}

class _BottomWeatherBlockState extends State<BottomWeatherBlock> {
  @override
  void initState() {
    super.initState();
  }

  Color getColor(String day) {
    if (day == 'Суббота' || day == 'Воскресенье') {
      return Colors.redAccent;
    }
    return Theme.of(context).textTheme.headline1.color;
  }

  void showHourlyDialog(BuildContext context, int index, String date) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WeeklyMoreElement(
          index: index,
          date: date,
        );
      },
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
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    WeatherProvider provider =
        Provider.of<WeatherProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scrollbar(
        child: ListView.separated(
          itemCount: 8,
          itemBuilder: (context, index) {
            String day;

            if (!provider.isLoading) {
              day = provider.forecast.weeklyForecast[index].weekday;
            }
            return !provider.isLoading
                ? FadeIn(
                    child: ListTile(
                        onTap: () {
                          showHourlyDialog(
                              context,
                              index,
                              provider.forecast.weeklyForecast[index].time +
                                  ', ' +
                                  day);
                        },
                        contentPadding: const EdgeInsets.all(0.0),
                        leading: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 4.0, bottom: 4.0),
                          child: Image.asset(
                            'assets/${provider.forecast.weeklyForecast[index].icon}.png',
                            color: theme.textTheme.headline1.color,
                          ),
                        ),
                        title: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: provider
                                        .forecast.weeklyForecast[index].time +
                                    ', ',
                                style: TextStyle(
                                    color: theme.textTheme.headline1.color,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: day,
                                style: TextStyle(
                                    color: getColor(day),
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                        trailing: Container(
                          child: FittedBox(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: provider.gradient),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              '${provider.getTemp(provider.forecast.weeklyForecast[index].tempDay)}°  ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              '${provider.getTemp(provider.forecast.weeklyForecast[index].tempNight)}° ',
                                          style: TextStyle(
                                              color: theme.accentColor))
                                    ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: theme.textTheme.headline1.color),
                                ),
                              ],
                            ),
                          ),
                        )),
                  )
                : ListTile(
                    title: Shimmer.fromColors(
                    period: Duration(seconds: 2),
                    baseColor: theme.primaryColor,
                    highlightColor: provider.secondAccent.withOpacity(0.5),
                    child: Container(
                      height: 50,
                      width: size.width * 0.80,
                      color: theme.primaryColor,
                    ),
                  ));
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}
