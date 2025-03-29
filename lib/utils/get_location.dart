import 'package:location/location.dart';

Future<({double? lat, double? lon})?> getLocation({bool justPermission = false}) async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  if (justPermission) {
    return null;
  }

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return (lat:_locationData.latitude, lon:_locationData.longitude);
}
