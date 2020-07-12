import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/services/forecast.dart';
import 'package:weather_app/services/API_service.dart';
import 'package:weather_app/services/GeoLocator.dart';
import 'package:weather_app/services/themeProvider.dart';

class WeatherProvider extends ChangeNotifier {
  ApiService _apiService = new ApiService();
  Forecast _forecast = new Forecast();
  GeoLocator _locator = new GeoLocator();

  Placemark _fullPosition;

  bool _loading = true;

  Placemark get fullPosition => _fullPosition;
  Forecast get forecast => _forecast;

  bool get isLoading => _loading;
  set loading(bool load) => _loading = load;

  double _lat = 0;
  double _lon = 0;

  double get lat => _lat;
  double get lon => _lon;

  String subDisplayName;
  int initTimeOffset;
  bool error = true;

  bool isCelsius;

  LinearGradient gradient = LinearGradient(
      colors: [Colors.grey, Colors.grey],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  Color secondAccent = Colors.grey;

  changeColor(int temp) {
    if (temp > 35) {
      gradient = LinearGradient(
          colors: [Color(0xffff6a14), Color(0xfff73c16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xfff74f11);
    } else if (temp > 20) {
      gradient = LinearGradient(
          colors: [Color(0xffffcb52), Color(0xffff7b02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xffffa114);
    } else if (temp > 10) {
      gradient = LinearGradient(
          colors: [Color(0xff83ff4a), Color(0xffb7ff4a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xff83ff4a);
    } else if (temp > 0) {
      gradient = LinearGradient(
          colors: [Color(0xff00ff84), Color(0xff00ffbb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xff00ff8c);
    } else if (temp > -10) {
      gradient = LinearGradient(
          colors: [Color(0xff00b4e6), Color(0xff00e6e6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xff00c4e6);
    } else if (temp > -20) {
      gradient = LinearGradient(
          colors: [Color(0xff0084e3), Color(0xff3690ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xff36abff);
    } else {
      gradient = LinearGradient(
          colors: [Color(0xffa857ff), Color(0xff8457ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      secondAccent = Color(0xff9557ff);
    }
  }

  _initPos() async {
    _setLoading();
    initTimeOffset = DateTime.now().timeZoneOffset.inSeconds;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latMemory = prefs.getDouble('lat');
    double lonMemory = prefs.getDouble('lon');
    isCelsius = prefs.getBool('isCelsius') ?? true;
    _fullPosition =
        await _locator.getCurrentPosition(lat: latMemory, lon: lonMemory);
    _lat = _locator.lat;
    _lon = _locator.lon;
    notifyListeners();
  }

  _currentPos() async {
    _setLoading();
    _fullPosition = await _locator.getCurrentPosition();
    _lat = _locator.lat;
    _lon = _locator.lon;
    notifyListeners();
  }

  _initCall() async {
    Map<String, dynamic> headers = {
      'lat': _locator.lat,
      'lon': _locator.lon,
      'exclude': 'minutely'
    };
    Map<String, dynamic> result = await _apiService.weatherRequest(headers);
    if (!error) {
      _forecast = Forecast.fromJson(result, initTimeOffset);
      changeColor(_forecast.temperature.round());
    }
    _loading = false;
    notifyListeners();
  }

  _getPos(double lat, double lon) async {
    _lat = lat;
    _lon = lon;
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, lon);
    _fullPosition = placemark[0];
    save();
  }

  Future<void> getWeatherCall(double lat, double lon) async {
    _setLoading();
    _getPos(lat, lon);
    Map<String, dynamic> headers = {
      'lat': lat,
      'lon': lon,
      'exclude': 'minutely'
    };
    Map<String, dynamic> result = await _apiService.weatherRequest(headers);
    if (!error) {
      _forecast = Forecast.fromJson(result, initTimeOffset);
      changeColor(_forecast.temperature.round());
    }
    _loading = false;
    notifyListeners();
  }

  changeTempUnits(bool val) async {
    this.isCelsius = val;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCelsius', isCelsius);
  }

  int getTemp(double temp) {
    return isCelsius ? temp.round() : ((temp * (9 / 5)) + 32).round();
  }

  Future<List> openCageCall(String address) async {
    if (address != ' ') {
      Map<String, dynamic> headers = {'q': address};
      List result = await _apiService.openCageRequest(headers);
      if (!error) {
        return result;
      }
    }
    return null;
  }

  _setLoading() {
    _loading = true;
    notifyListeners();
  }

  init() async {
    _getSubDisplayName();
    await _initPos();
    await _initCall();
    save();
  }

  currentPos(BuildContext c) async {
    await _currentPos();
    await _initCall();
    save();
  }

  save() async {
    print('saved');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', _lat);
    prefs.setDouble('lon', _lon);
    prefs.setString('subDisplayName', subDisplayName);
  }

  _getSubDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subDisplayName = prefs.getString('subDisplayName') ?? '...';
  }
}
