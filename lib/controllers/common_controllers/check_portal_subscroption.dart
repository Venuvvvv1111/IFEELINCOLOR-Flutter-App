import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class CheckPortalController extends GetxController {


  // Future<void> checkPatientPortalSubscription() async {
  //   UserInfo userInfo = Get.put(UserInfo());
  //   final url =
  //       Uri.parse('${Constants.baseUrl}/${Constants.patientSubscriptionCheck}');

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': 'Bearer ${userInfo.getUserToken}'
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       hasActiveSubscription.value =
  //           data['body']['hasActiveSubscription'] ?? false;
  //     } else {
  //       hasActiveSubscription.value = false;
  //       Get.snackbar('Error', 'Failed to check subscription status.');
  //     }
  //   } catch (e) {
  //     hasActiveSubscription.value = false;
  //     MyToast.showGetToast(
  //         title: 'Error',
  //         message: 'Something went wrong. Please try again.',
  //         backgroundColor: Colors.red,
  //         color: Colors.white);
  //   }
  // }

  // Future<void> checkDoctorPortalSubscription() async {
  //   UserInfo userInfo = Get.put(UserInfo());
  //   final url =
  //       Uri.parse('${Constants.baseUrl}/${Constants.doctorSubscriptionCheck}');

  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': 'Bearer ${userInfo.getUserToken}'
  //       },
  //     );

  //     if (kDebugMode) {
  //       print(response.body);
  //     }
  //     if (kDebugMode) {
  //       print(response.statusCode);
  //     }

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       hasActiveSubscription.value =
  //           data['body']['hasActiveSubscription'] ?? false;
  //     } else {
  //       hasActiveSubscription.value = false;
  //       Get.snackbar('Error', 'Failed to check subscription status.');
  //     }
  //   } catch (e) {
  //     hasActiveSubscription.value = false;
  //     MyToast.showGetToast(
  //         title: 'Error',
  //         message: 'Something went wrong. Please try again.',
  //         backgroundColor: Colors.red,
  //         color: Colors.white);
  //   }
  // }

  Future<bool> checkFreeTrailActive() async {
    UserInfo userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print('is user loged in ');
      print(userInfo.getUserLogin);
    }

    try {
      if (kDebugMode) {
        print(
            '${Constants.baseUrl}/${Constants.chekPreviusSubscriptionPatient}/${userInfo.getUserToken}');
      }
      
      final response = await http.get(
        Uri.parse(userInfo.getUserLogin?
            '${Constants.baseUrl}/${Constants.chekPreviusSubscriptionPatient}':'${Constants.baseUrl}/${Constants.chekPreviusSubscriptionDoctor}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );
      print("check previus${response.body}");
     
        if (response.statusCode == 200) {
        // Parse the response JSON
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print(data['body']['hasPreviousSubscription']);
        }
        bool hasActiveSubscription = data['body']['hasPreviousSubscription']??false;

        return hasActiveSubscription;
      } else {
        // Handle API error
        if (kDebugMode) {
          print('Error: Unable to fetch subscription status');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
  Future<bool> checkPremiumActiveSubscription() async {
    UserInfo userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print('is user loged in ');
      print(userInfo.getUserLogin);
    }

    try {
      // isloading.value = true;
      final response = await http.get(
        Uri.parse(userInfo.getUserLogin
            ? '${Constants.baseUrl}/${Constants.patientSubscriptionCheck}'
            : '${Constants.baseUrl}/${Constants.doctorSubscriptionCheck}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print(data['body']['hasActiveSubscription']);
        }
        bool hasActiveSubscription = data['body']['hasActiveSubscription']??false;

        return hasActiveSubscription;
      } else {
        // Handle API error
        if (kDebugMode) {
          print('Error: Unable to fetch subscription status');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // Handle any errors during the API request
      MyToast.showGetToast(
        title: "Payment Failed",
        message: "Unable to fetch subscription status",
        backgroundColor: Colors.red,
        color: whiteColor,
      );
      return false;
    } finally {
      // isloading.value = false;
    }
  }
}
