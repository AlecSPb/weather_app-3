import 'package:geolocator/geolocator.dart';

//класс для доступа к геолокации
class GeoLocator {
  //позиция (класс содержит множество нужных полей)
  Position _position;
  //ширина и долгота
  double _lat;
  double _lon;
  
  //геттеры
  double get lat => _lat;
  double get lon => _lon;
  
  //синхронная фунция, возвращаются позицию (либо текущую, если не заданы ширина и долгота, 
  //либо по широте и долготе, либо, если не ВКЛ GPS, то по ум. ставится Москва)
  
  //Placemark - место (страна, город, деревня, улица и тп)
  Future<Placemark> getCurrentPosition({double lat, double lon}) async {
    Geolocator geolocator = Geolocator();
    
    //если заданы ширина и долгота
    if (lat != null && lon != null) {
      _lat = lat;
      _lon = lon;

      List<Placemark> placemark =
          await geolocator.placemarkFromCoordinates(_lat, _lon);

      return placemark[0];
    }
    
    //если не заданы, то пробуем получить текущие координаты через GPS
    
    //если разрешение не выдано (хотя бы ТОЛЬКО ВО ВРЕМЯ ИСПОЛЬЗОВАНИЯ ПРИЛОЖЕНИЯ, то каждый раз при запуске 
    //будет требовать разрешение
    _position = await geolocator
        .getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.locationWhenInUse,
            desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 5), onTimeout: () async {
      return geolocator.getLastKnownPosition(
          locationPermissionLevel: GeolocationPermission.locationWhenInUse,
          desiredAccuracy: LocationAccuracy.medium);
    });
    
    //если GPS не сработал
    //то ставим местопложение - Москва
    if (_position == null) {
      //ширина и долгота москвы
      _lat = 55.7522;
      _lon = 37.6156;
      List<Placemark> placemark =
          await geolocator.placemarkFromCoordinates(_lat, _lon);
      return placemark[0];
      //если GPS сработал
      //то устанавливаем найденные ширину и долготу
    } else {
      _lat = _position.latitude;
      _lon = _position.longitude;
      List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
          _position.latitude, _position.longitude);

      return placemark[0];
    }
  }
}
