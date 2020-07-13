import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';
import 'package:weather_app/transition/fade.dart';
import 'package:weather_app/views/info_page.dart';
import 'package:weather_app/views/map_page.dart';
import 'package:weather_app/views/search_page.dart';

//виджет левой панели меню

class WeatherDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //настройки темы
    ThemeData theme = Theme.of(context);
    //доступ к размерам экрана (в пикселях)
    Size size = MediaQuery.of(context).size;
    //цвет текста
    Color color = theme.textTheme.headline1.color;
    //логика
    WeatherProvider themeProvider = Provider.of<WeatherProvider>(context);
    return Container(
      width: size.width * (2 / 3),
      color: theme.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: themeProvider.gradient,
            ),
            height: 100,
            width: size.width * (2 / 3),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: FittedBox(
                child: Text(
                  'Меню',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.accentColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Divider(),
          //переход к окну поиска
          ListTile(
            leading: Icon(
              Icons.search,
              color: themeProvider.secondAccent,
            ),
            title: Text(
              'Поиск',
              style: TextStyle(color: color),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new FadeRoute(page: SearchPage()));
            },
          ),
          //переход к окну карты
          ListTile(
            leading: Icon(
              Icons.map,
              color: themeProvider.secondAccent,
            ),
            title: Text(
              'На карте',
              style: TextStyle(color: color),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, new FadeRoute(page: MapPage()));
            },
          ),
          //определение текущей позиции
          ListTile(
            leading: Icon(
              Icons.gps_fixed,
              color: themeProvider.secondAccent,
            ),
            title: Text(
              'Определить позицию',
              style: TextStyle(color: color),
            ),
            subtitle: Text(
              'GPS MODE ONLY!',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Provider.of<WeatherProvider>(context, listen: false)
                  .currentPos(context);
            },
          ),
          Spacer(
            flex: 9,
          ),
          //переключатель для смены ед. измерения температуры
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '°F',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Switch(
                    activeColor: themeProvider.secondAccent,
                    inactiveThumbColor: themeProvider.secondAccent,
                    inactiveTrackColor:
                        themeProvider.secondAccent.withOpacity(0.5),
                    value: Provider.of<WeatherProvider>(context, listen: false)
                        .isCelsius,
                    onChanged: (value) {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .changeTempUnits(value);
                    }),
                Text(
                  '°C',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          //переход к окну инфо. о приложении
          ListTile(
            leading: Icon(
              Icons.info,
              color: themeProvider.secondAccent,
            ),
            title: Text(
              'О приложении',
              style: TextStyle(color: color),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, new FadeRoute(page: InfoPage()));
            },
          ),
          //смена темы
          ListTile(
            leading: Icon(
              Icons.wb_sunny,
              color: themeProvider.secondAccent,
            ),
            title: Text(
              'Сменить тему',
              style: TextStyle(color: color),
            ),
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
          ),
        ],
      ),
    );
  }
}
