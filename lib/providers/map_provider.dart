import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class MapProvider extends ChangeNotifier {
  final Location location = Location();
  LocationData? userLocation;

  getUserCurrentLocation() async {
    try {
      userLocation = await location.getLocation();
    } catch (err) {
      print(err);
    }

    notifyListeners();
  }

  onLocationChange() {
    notifyListeners();
  }
}
