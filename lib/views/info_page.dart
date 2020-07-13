import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/const.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/services/themeProvider.dart';


//окно с информацией о приложении
class InfoPage extends StatelessWidget {
  const InfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //настройки текущей темы приложения
    ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                  gradient: Provider.of<WeatherProvider>(context).gradient),
              child: Center(
                child: ClipOval(
                    child: Container(
                  height: 150,
                  width: 150,
                  color: theme.primaryColor,
                  child: Image.asset('assets/icons/logo.png'),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Информация',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.russoOne(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: theme.textTheme.headline1.color)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                infoText1,
                softWrap: true,
                style: TextStyle(color: theme.textTheme.headline1.color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                infoText2,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.headline1.color),
                softWrap: true,
              ),
            ),
            Spacer(flex: 6),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                infoText3,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textTheme.headline1.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
