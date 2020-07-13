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

//РЕАЛИЗАЦИЯ ЛОГИКИ

class WeatherProvider extends ChangeNotifier {
  //доступ к запросам
  ApiService _apiService = new ApiService();
  //доступ к прогнозу
  Forecast _forecast = new Forecast();
  //доступ к геолокации
  GeoLocator _locator = new GeoLocator();
  
  //позиция
  Placemark _fullPosition;
  
  //в процессе загрузки
  bool _loading = true;

  //геттеры
  Placemark get fullPosition => _fullPosition;
  Forecast get forecast => _forecast;
  bool get isLoading => _loading;
  
  //сеттеры
  set loading(bool load) => _loading = load;

  //ширина и долгота, получаеные из геолокации или сохраненные 
  //из прошлого входа
  double _lat = 0;
  double _lon = 0;

  double get lat => _lat;
  double get lon => _lon;

  //вспомогательная строка, содержит название населенного пункта если
  //не определил геолокатор
  String subDisplayName;
  
  //текущая временная зона, откуда запущено приложение
  // (в моем случае UTC+5)
  int initTimeOffset;
  
  //ошибка сети или запроса
  bool error = true;
  
  //единицы измерения (true если в цельсиях, по ум. в цельсиях)
  bool isCelsius;
  
  //градиаент или основая цветовая тема приложения
  //меняется в зависимости от температуры
  //при загрузке серый
  LinearGradient gradient = LinearGradient(
      colors: [Colors.grey, Colors.grey],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
  
  //НЕградиентный цвет этой же темы
  //при загрузке серый
  Color secondAccent = Colors.grey;

  //функция смены темы в зав. от темп.
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
  
  //функция инициализации позиции при запуске приложения
  _initPos() async {
    //установка загрузки на true
    _setLoading();
    //получение зоны
    initTimeOffset = DateTime.now().timeZoneOffset.inSeconds;
    //получение доступа к памяти устройства
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //и получение оттуда ширины и долготы с прошлого входа
    //если их нет - то оба null
    double latMemory = prefs.getDouble('lat');
    double lonMemory = prefs.getDouble('lon');
    //получение ед. измерения, если null то установка на true
    isCelsius = prefs.getBool('isCelsius') ?? true;
    //получение местопложения
    _fullPosition =
        await _locator.getCurrentPosition(lat: latMemory, lon: lonMemory);
    _lat = _locator.lat;
    _lon = _locator.lon;
    //функция из класса ChangeNotifier
    //сообщеяет всем слушателям, что переменные изменились
    //из-за чего виджеты перестраиваются и данные в них меняются
    notifyListeners();
  }

  //получение текущей позиции по GPS
  _currentPos() async {
    _setLoading();
    _fullPosition = await _locator.getCurrentPosition();
    _lat = _locator.lat;
    _lon = _locator.lon;
    notifyListeners();
  }
  
  //запрос к OPW во время инициализации
  _initCall() async {
    //параметры запроса, исключаем поминутный прогноз
    Map<String, dynamic> headers = {
      'lat': _locator.lat,
      'lon': _locator.lon,
      'exclude': 'minutely'
    };
    //результат
    Map<String, dynamic> result = await _apiService.weatherRequest(headers);
    //если нет ошибки, то строим заполняем объект класса Forecast
   //и меняем цвет
    if (!error) {
      _forecast = Forecast.fromJson(result, initTimeOffset);
      changeColor(_forecast.temperature.round());
    }
    _loading = false;
    notifyListeners();
  }
  
  //получить местоположение по ширине и долготе
  _getPos(double lat, double lon) async {
    _lat = lat;
    _lon = lon;
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, lon);
    _fullPosition = placemark[0];
    save();
  }
  
  //запрос к OWN не во время инициализации (по ширине и долготе)
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
  
  //изменение ед. измерения температуры
  changeTempUnits(bool val) async {
    this.isCelsius = val;
    notifyListeners();
    //и запись их в память устройства
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCelsius', isCelsius);
  }
  
  //получение температуры в заданных ед. измерения
  int getTemp(double temp) {
    return isCelsius ? temp.round() : ((temp * (9 / 5)) + 32).round();
  }

  //запрос к OCD для получения списка местоположений по адресы (геокодинг)
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
  
  //установка загрузки
  _setLoading() {
    _loading = true;
    notifyListeners();
  }
  
  //функция, вызываемая при инициализации приложения
  init() async {
    _getSubDisplayName();
    await _initPos();
    await _initCall();
    save();
  }

  //получение текущий позиции по GPS (в левой панели меню)
  currentPos(BuildContext c) async {
    await _currentPos();
    await _initCall();
    save();
  }
  
  //сохранение данных в память устройкства
  save() async {
    print('saved');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', _lat);
    prefs.setDouble('lon', _lon);
    prefs.setString('subDisplayName', subDisplayName);
  }

  //получение вспомогательного названия
  _getSubDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subDisplayName = prefs.getString('subDisplayName') ?? '...';
  }
}
