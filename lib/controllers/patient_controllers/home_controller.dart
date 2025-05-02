import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:ifeelin_color/models/patient_models/home_models/subscribed_doctor_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:latlong2/latlong.dart';

import '../../models/patient_models/nearby_doctor_model.dart';

class HomeController extends GetxController {
  NearbyDoctorsModel? nearbyDoctorsModel;
  SubscribedDoctorsModel? subscribedDoctorsModel;
  var selectedIndex = 0.obs;
  var searchController = TextEditingController();
  RxBool isLoading = false.obs;
  var totalNearbyDoctors = Rxn<int>();
  RxList<Body> filteredDoctors = RxList<Body>();
  var subscribedSearchController = TextEditingController();
  Rx<PageController> pageController = PageController().obs;
  var totalSubscribedDoctors = Rxn<int>();
  RxList<SubscribedList> filterSubscribedDoctors = RxList<SubscribedList>();
  var currentLocation = Rx<Position?>(null);
  var center = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    checkAndRequestLocationPermission();
    fetchNearbyDoctors();
    fetchSubscribeDoctors();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  getUserLocation() async {
    try {
      // Get current user location
      currentLocation.value = await locateUser();

      // Update center with the new location
      if (currentLocation.value != null) {
        center.value = LatLng(
            currentLocation.value!.latitude, currentLocation.value!.longitude);
        if (kDebugMode) {
          print('Center updated: $center');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
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

  Future<void> fetchNearbyDoctors() async {
    getUserLocation();
    try {
      isLoading(true);
      // currentLocation.value = await locateUser();
      if (kDebugMode) {
        print(currentLocation.value);
      }
      // Update center with the new location
      if (currentLocation.value != null) {
        center.value = LatLng(
            currentLocation.value!.latitude, currentLocation.value!.longitude);
        if (kDebugMode) {
          print('Center updated: $center');
        }
      }
      update();
      if (kDebugMode) {
        print(UserInfo().getUserToken);
        print(center.value?.longitude);
      }

      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.getNearestDoctors}'),
        body: jsonEncode({
          // "latitude": 14.604428,
          // "longitude": 79.432308
          "latitude": center.value?.latitude,
          "longitude": center.value?.longitude,
          // "latitude": 37.77,
          // "longitude": -122.465665565676,
        }),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}',
        },
      );
      isLoading(false);
      if (kDebugMode) {
        print(res.statusCode);
        print(res.body);
      }

      if (res.statusCode == 200) {
        nearbyDoctorsModel = nearbyDoctorsModelFromJson(res.body);
        totalNearbyDoctors(nearbyDoctorsModel?.body?.length);
        if (nearbyDoctorsModel?.body != null) {
          filteredDoctors.assignAll(nearbyDoctorsModel!.body!);
        } else {
          if (kDebugMode) {
            print('No nearby doctors found');
          }
        }
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print(e);
      }
      if (kDebugMode) {
        print('fetchNearbyDoctors error');
      }
    } finally {
      isLoading(false);
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.assignAll(nearbyDoctorsModel?.body ?? []);
    } else {
      filteredDoctors.assignAll(nearbyDoctorsModel?.body?.where((doctor) {
            final nameLower = doctor.name?.toLowerCase() ?? '';
            final specializedInLower =
                doctor.specializedIn?.toLowerCase() ?? '';
            final locationInLower = doctor.location?.toLowerCase() ?? '';
            final queryLower = query.toLowerCase();

            return nameLower.contains(queryLower) ||
                specializedInLower.contains(queryLower) ||
                locationInLower.contains(queryLower);
          }).toList() ??
          []);
    }
  }

  Future<void> fetchSubscribeDoctors() async {
    getUserLocation();
    try {
      isLoading(true);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
      }
      final res = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.getsubscribeDoctors}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}',
        },
      );
      isLoading(false);
      if (kDebugMode) {
        print(res.statusCode);
        print(res.body);
      }

      if (res.statusCode == 200) {
        subscribedDoctorsModel = subscribedDoctorsModelFromJson(res.body);
        totalSubscribedDoctors(subscribedDoctorsModel?.body?.length);
        filterSubscribedDoctors.assignAll(subscribedDoctorsModel?.body ?? []);
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print(e);
        print('fetchNearbyDoctors error');
      }
    }
  }

  void filterSubscribeDoctors(String query) {
    if (query.isEmpty) {
      filterSubscribedDoctors.assignAll(subscribedDoctorsModel?.body ?? []);
    } else {
      filterSubscribedDoctors
          .assignAll(subscribedDoctorsModel?.body?.where((doctor) {
                final nameLower = doctor.clinician?.name?.toLowerCase() ?? '';
                final specializedInLower =
                    doctor.clinician?.specializedIn?.toLowerCase() ?? '';
                final locationInLower =
                    doctor.clinician?.location?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();

                return nameLower.contains(queryLower) ||
                    specializedInLower.contains(queryLower) ||
                    locationInLower.contains(queryLower);
              }).toList() ??
              []);
    }
  }
}
