import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:ifeelin_color/models/doctor_models/nearby_subscribed_patients_model.dart';
import 'package:ifeelin_color/models/doctor_models/subscribed_patients_model.dart';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:latlong2/latlong.dart';

class DoctorHomeController extends GetxController {
  NearbySubscriptionDoctorsModel? nearbySubscriptionDoctorsModel;
  SubscribedPatientsModel? subscribedPatientsModel;
  var selectedIndex = 0.obs;
  var searchController = TextEditingController();
  RxBool isLoading = false.obs;
  var totalNearbyPateints = Rxn<int>();
  RxList<NearbyBody> filteredNearbyPatients = RxList<NearbyBody>();
  var subscribedSearchController = TextEditingController();
  Rx<PageController> pageController = PageController().obs;
  var totalSubscribedPatients = Rxn<int>();
  RxList<SubscribedBody> filterSubscribedPatients = RxList<SubscribedBody>();
  var currentLocation = Rx<Position?>(null);
  var center = Rx<LatLng?>(null);

  @override
  void onInit() {
    super.onInit();
    checkAndRequestLocationPermission();
    fetchNearbyPatients();
    fetchSubscribePatients();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    // Get current user location
    currentLocation.value = await locateUser();

    // Update center with the new location
    if (currentLocation.value != null) {
      center.value = LatLng(
          currentLocation.value!.latitude, currentLocation.value!.longitude);
      if (kDebugMode) {
        print('Center updated: $center');
      }
      update();
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

  Future<void> fetchNearbyPatients() async {
    try {
      getUserLocation();
      isLoading(true);
      // currentLocation.value = await locateUser();
      // print(']]]]');

      // Update center with the new location
      if (currentLocation.value != null) {
        center.value = LatLng(
            currentLocation.value!.latitude, currentLocation.value!.longitude);
        if (kDebugMode) {
          print('Center updated: $center');
        }
      }

      if (kDebugMode) {
        print(UserInfo().getUserToken);
      }

      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.getNearbyPatients}'),
        body: jsonEncode({
          "latitude": center.value?.latitude ?? "",
          "longitude": center.value?.longitude ?? "",
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
        nearbySubscriptionDoctorsModel =
            nearbySubscriptionDoctorsModelFromJson(res.body);

        totalNearbyPateints(nearbySubscriptionDoctorsModel?.body?.length);
                    if (kDebugMode) {
                      print("nearbySubscriptionDoctorsModel?.body?.length${nearbySubscriptionDoctorsModel?.body?.length}");
                    }
        if (nearbySubscriptionDoctorsModel?.body != null) {
          filteredNearbyPatients
              .assignAll(nearbySubscriptionDoctorsModel?.body ?? []);
        } else {
          if (kDebugMode) {
            print('No nearby Patients found');
          }
          filteredNearbyPatients
              .assignAll([]);
        }
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print('fetchNearbyDoctors error');
        print(e);
      }
    } finally {
      isLoading(false);
    }
  }

  void filterNearbyPatients(String query) {
    if (query.isEmpty) {
      filteredNearbyPatients
          .assignAll(nearbySubscriptionDoctorsModel?.body ?? []);
    } else {
      filteredNearbyPatients
          .assignAll(nearbySubscriptionDoctorsModel?.body?.where((patient) {
                final nameLower =
                    patient.patient?.userName?.toLowerCase() ?? '';

                // final locationInLower = patient.patient.location?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();

                return nameLower.contains(queryLower);
                // specializedInLower.contains(queryLower) ||
                // locationInLower.contains(queryLower);
              }).toList() ??
              []);
    }
  }

  Future<void> fetchSubscribePatients() async {
    getUserLocation();
    try {
      isLoading(true);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
      }
      final res = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.subscribedPatients}'),
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
        subscribedPatientsModel = subscribedPatientsModelFromJson(res.body);
        totalSubscribedPatients(subscribedPatientsModel?.body?.length);
        filterSubscribedPatients.assignAll(subscribedPatientsModel?.body ?? []);
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print('fetchNearbyDoctors error');
        print(e);
      }
    }
  }

  void filterSubscribePatients(String query) {
    if (query.isEmpty) {
      filterSubscribedPatients.assignAll(subscribedPatientsModel?.body ?? []);
    } else {
      filterSubscribedPatients
          .assignAll(subscribedPatientsModel?.body?.where((pateint) {
                final nameLower =
                    pateint.patient?.userName?.toLowerCase() ?? '';

                final locationInLower =
                    pateint.patient?.location?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();

                return nameLower.contains(queryLower) ||
                    locationInLower.contains(queryLower);
              }).toList() ??
              []);
    }
  }
}
