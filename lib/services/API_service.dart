import 'package:dio/dio.dart';

//класс для доступа к API
class ApiService {
  
  //ТОКЕНЫ УБРАНЫ ДЛЯ БЕЗОПАСНОСТИ
  
  //токен для запроса к OpenWeatherMap для получения прогноза
  final _openWeatherMapToken = 'txtfile';
  //основая ссылка
  final _openWeatherMapBaseURL =
      'https://api.openweathermap.org/data/2.5/onecall?';

  //токен для запроса к OpenCageData для получения списка населенных пунктом
  final _openCageToken = 'txtfile';
   //основая ссылка
  final _openCageBaseURL = 'https://api.opencagedata.com/geocode/v1/json?';
  
  //геттер для получение токена погоды
  String get weatherToken => _openWeatherMapToken;

  //функция запроса к OpenWeatherMap (асинхронная)
  //как параметры получает headerы (параметры запроса)
  Future<Map<String, dynamic>> weatherRequest(
      Map<String, dynamic> headers) async {
    //Dio - хороший http клиент для Dart
    Dio dio = new Dio();
    //добавление еще параметров
    headers.addAll(
        {'lang': 'ru', 'units': 'metric', 'appid': _openWeatherMapToken});
    
    //результат
    Map<String, dynamic> map;
    
    //try-catch блок
    try {
      //response - результат запроса, обычно json 
      
      Response response =
          await dio.get(_openWeatherMapBaseURL, queryParameters: headers);
      //перед выполнением этой операции нужно дождатся данных от OpenWeatherMap (await)
      //после записываем результат (json)
      map = response.data as Map<String, dynamic>;
      print(map);
    } catch (e) {
      print(e.toString());
      print('HTTP REQUEST ERROR');
    }
    //закрываем http клиент и возвращаем map
    dio.close();
    return map;
  }
  
  //функция запроса к OpenCageData (асинхронная)
  //как параметры получает headerы (параметры запроса)
  Future<List> openCageRequest(Map<String, dynamic> headers) async {
    Dio dio = new Dio();
    headers.addAll(
        {'language': 'ru', 'key': _openCageToken, 'limit': 30, 'abbrv': 1});
    
    //в данном случае, как результат возвращается список из Map(ключ-значение)
    List result;

    try {
      Response response =
          await dio.get(_openCageBaseURL, queryParameters: headers);
      result = response.data["results"];
      print(result);
    } catch (e) {
      print(e.toString());
      print('HTTP REQUEST ERROR');
    }
    dio.close();
    return result;
  }
}
