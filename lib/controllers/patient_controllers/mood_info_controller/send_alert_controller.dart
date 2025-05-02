import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifeelin_color/models/patient_models/Mood_info_models/send_alert_model.dart';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class SendAlertController extends GetxController {
  SendAlertModel? sendAlertModel;
  var isLoading = true.obs;
  Position? currentLocation;
  LatLng? _center;
  LatLng? patientLocation;
  LatLng? clinicLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void onInit() {
    super.onInit();
    checkAndRequestLocationPermission();
    fetchAlertMessage();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getUserLocation() async {
    currentLocation = await locateUser();
    _center = LatLng(currentLocation!.latitude, currentLocation!.longitude);
    if (kDebugMode) {
      print('center $_center');
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('Location permissions are denied');
        }
        return;
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await getUserLocation();
    }
  }

  Future<void> fetchAlertMessage() async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.sendAlert}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
        body: jsonEncode({"latitude": 37.77, "longitude": -122.465665565676}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        sendAlertModel = sendAlertModelFromJson(response.body);

        if (sendAlertModel?.body?.newAlert?.patientLocation != null) {
          patientLocation = LatLng(
            sendAlertModel!.body!.newAlert!.patientLocation!.latitude!,
            sendAlertModel!.body!.newAlert!.patientLocation!.longitude!,
          );
        }
        if (sendAlertModel?.body?.newAlert?.nearestClinisistLocation != null) {
          clinicLocation = LatLng(
            sendAlertModel!.body!.newAlert!.nearestClinisistLocation!.latitude!,
            sendAlertModel!
                .body!.newAlert!.nearestClinisistLocation!.longitude!,
          );
        }

        // Clear previous markers and polylines
        markers.clear();
        polylines.clear();

        // Add markers
        if (patientLocation != null) {
          markers.add(Marker(
            markerId: const MarkerId('patient'),
            position: patientLocation!,
            infoWindow:
                const InfoWindow(title: 'Patient Location', snippet: ''),
          ));
        }
        if (clinicLocation != null) {
          markers.add(Marker(
            markerId: const MarkerId('clinic'),
            position: clinicLocation!,
            infoWindow: const InfoWindow(title: 'Clinic Location', snippet: ''),
          ));
        }

        // Add polyline
        if (patientLocation != null && clinicLocation != null) {
          polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: [patientLocation!, clinicLocation!],
            color: primaryColor,
            width: 5,
          ));
        }

        update(); // Notify listeners
        // Navigator.pushNamed(Get.context!, AppRoutes.sendAlertscreen);
      } else {
        Get.snackbar('Error', 'Failed to load data',
            colorText: whiteColor, backgroundColor: Colors.red);
      }
    } catch (e) {
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  LatLng? get center => _center;
  Set<Marker> get mapMarkers => markers;
  Set<Polyline> get mapPolylines => polylines;
}
