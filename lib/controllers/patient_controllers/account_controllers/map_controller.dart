import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMapController extends GetxController {
  Position? currentLocation;
  var center = Rxn<LatLng>();
  StreamSubscription<Position>? _positionStreamSubscription;

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    _startListeningToLocation();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void _startListeningToLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        currentLocation = position;
        center.value = LatLng(position.latitude, position.longitude);
        update(); // Notify listeners
        if (kDebugMode) {
          print('center $center');
        }
      });
    } else {
      if (kDebugMode) {
        print('Location permissions are not granted');
      }
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getUserLocation() async {
    Position position = await locateUser();
    center.value = LatLng(position.latitude, position.longitude);
    if (kDebugMode) {
      print('center $center');
    }
  }
}
