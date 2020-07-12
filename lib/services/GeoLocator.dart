import 'package:geolocator/geolocator.dart';

class GeoLocator {
  Position _position;
  double _lat;
  double _lon;

  double get lat => _lat;
  double get lon => _lon;

  Future<Placemark> getCurrentPosition({double lat, double lon}) async {
    Geolocator geolocator = Geolocator();

    if (lat != null && lon != null) {
      _lat = lat;
      _lon = lon;

      List<Placemark> placemark =
          await geolocator.placemarkFromCoordinates(_lat, _lon);

      return placemark[0];
    }

    _position = await geolocator
        .getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.locationWhenInUse,
            desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 5), onTimeout: () async {
      return geolocator.getLastKnownPosition(
          locationPermissionLevel: GeolocationPermission.locationWhenInUse,
          desiredAccuracy: LocationAccuracy.medium);
    });

    if (_position == null) {
      //координаты москвы
      _lat = 55.7522;
      _lon = 37.6156;
      List<Placemark> placemark =
          await geolocator.placemarkFromCoordinates(_lat, _lon);
      return placemark[0];
    } else {
      _lat = _position.latitude;
      _lon = _position.longitude;
      List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
          _position.latitude, _position.longitude);

      return placemark[0];
    }
  }
}
