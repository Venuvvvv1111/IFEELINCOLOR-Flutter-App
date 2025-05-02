import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'dart:convert';

import '../../../models/doctor_models/subscription_patients_model.dart';

class SubscriptionPatientsController extends GetxController {
  var isLoading = true.obs;
  SubscriptionPatientsModel? subscriptionPatientsModel;
  Rx<String> error = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  void fetchSubscriptions() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.allSubscribedPatientsURL}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        subscriptionPatientsModel =
            subscriptionPatientsModelFromJson(response.body);
        if (kDebugMode) {
          print(json);
        }
        // NotificationsModel notificationsModel =
        //     notificationsModelFromJson(response.body);
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: response.reasonPhrase.toString(),
            backgroundColor: Colors.red,
            color: whiteColor);
      }
    } catch (e) {
      error('value');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
