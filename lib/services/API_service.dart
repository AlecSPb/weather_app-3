import 'package:dio/dio.dart';

class ApiService {
  final _openWeatherMapToken = '82b97b2530478bd05776df4c57d5b051';
  final _openWeatherMapBaseURL =
      'https://api.openweathermap.org/data/2.5/onecall?';

  final _openCageToken = '8e3cbe1b921948ec9cb98f8ab6b23f8f';
  final _openCageBaseURL = 'https://api.opencagedata.com/geocode/v1/json?';

  String get weatherToken => _openWeatherMapToken;

  Future<Map<String, dynamic>> weatherRequest(
      Map<String, dynamic> headers) async {
    Dio dio = new Dio();
    headers.addAll(
        {'lang': 'ru', 'units': 'metric', 'appid': _openWeatherMapToken});

    Map<String, dynamic> map;
    try {
      Response response =
          await dio.get(_openWeatherMapBaseURL, queryParameters: headers);
      map = response.data as Map<String, dynamic>;
      print(map);
    } catch (e) {
      print(e.toString());
      print('HTTP REQUEST ERROR');
    }
    dio.close();
    return map;
  }

  Future<List> openCageRequest(Map<String, dynamic> headers) async {
    Dio dio = new Dio();
    headers.addAll(
        {'language': 'ru', 'key': _openCageToken, 'limit': 30, 'abbrv': 1});

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
