import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/services/const.dart';
import 'package:weather_app/elements/left_drawer.dart';
import 'package:weather_app/services/provider.dart';
import 'package:weather_app/elements/main_weather_block.dart';
import 'package:weather_app/elements/second_weather_block.dart';
import 'package:weather_app/services/themeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkTheme = prefs.getBool('theme') ?? false;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<WeatherProvider>(create: (_) => WeatherProvider()),
      ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(
              !isDarkTheme ? lightTheme : darkTheme, isDarkTheme)),
    ],
    child: WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.themeData.copyWith(
          appBarTheme: AppBarTheme(elevation: 0, brightness: Brightness.dark),
          splashFactory: InkRipple.splashFactory,
          iconTheme: IconThemeData(color: Colors.white),
          primaryIconTheme: IconThemeData(color: Colors.white),
          textSelectionHandleColor:
              Provider.of<WeatherProvider>(context).secondAccent),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          Provider.of<WeatherProvider>(context, listen: false).error = false;
        } else {
          Provider.of<WeatherProvider>(context, listen: false).error = true;
        }
      });
      Provider.of<WeatherProvider>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    WeatherProvider provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Consumer<WeatherProvider>(
          builder: (context, weather, child) {
            Placemark pos = weather.fullPosition;
            return pos == null
                ? Container()
                : FadeIn(
                    duration: Duration(seconds: 1),
                    child: Text(
                      '${pos.locality != '' ? pos.locality : weather.subDisplayName}',
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  );
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              if (!provider.isLoading) {
                double lat = provider.lat;
                double lon = provider.lon;
                Provider.of<WeatherProvider>(context, listen: false)
                    .getWeatherCall(lat, lon);
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(
                      gradient: Provider.of<WeatherProvider>(context).gradient,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      )),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(),
              )
            ],
          ),
          SafeArea(
              child: !provider.error
                  ? Column(
                      children: [
                        Expanded(flex: 6, child: MainWeatherBlock()),
                        Expanded(flex: 4, child: BottomWeatherBlock())
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Image.asset('assets/icons/error.png'),
                            )),
                        Expanded(flex: 4, child: Container())
                      ],
                    )),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: Consumer<WeatherProvider>(
                  builder: (context, weather, child) {
                    return weather.isLoading
                        ? CircularProgressIndicator()
                        : Container();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      drawerEdgeDragWidth: 100,
      drawerEnableOpenDragGesture: true,
      drawer: WeatherDrawer(),
      resizeToAvoidBottomInset: false,
    );
  }
}
