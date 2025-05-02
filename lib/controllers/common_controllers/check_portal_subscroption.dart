import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class CheckPortalController extends GetxController {
  RxBool hasActiveSubscription = false.obs;

  Future<void> checkPatientPortalSubscription() async {
    UserInfo userInfo = Get.put(UserInfo());
    final url =
        Uri.parse('${Constants.baseUrl}/${Constants.patientSubscriptionCheck}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        hasActiveSubscription.value =
            data['body']['hasActiveSubscription'] ?? false;
      } else {
        hasActiveSubscription.value = false;
        Get.snackbar('Error', 'Failed to check subscription status.');
      }
    } catch (e) {
      hasActiveSubscription.value = false;
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    }
  }

  Future<void> checkDoctorPortalSubscription() async {
    UserInfo userInfo = Get.put(UserInfo());
    final url =
        Uri.parse('${Constants.baseUrl}/${Constants.doctorSubscriptionCheck}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );

      if (kDebugMode) {
        print(response.body);
      }
      if (kDebugMode) {
        print(response.statusCode);
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        hasActiveSubscription.value =
            data['body']['hasActiveSubscription'] ?? false;
      } else {
        hasActiveSubscription.value = false;
        Get.snackbar('Error', 'Failed to check subscription status.');
      }
    } catch (e) {
      hasActiveSubscription.value = false;
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    }
  }
}
