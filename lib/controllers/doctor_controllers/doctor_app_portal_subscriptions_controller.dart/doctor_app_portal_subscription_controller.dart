import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/doctor_models/doctor_app_portal_subscribed_model.dart';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'dart:convert';

class DoctorAppPortalSubscriptionController extends GetxController {
  var isLoading = true.obs;
  DoctorAppSubscribedSubscriptionsModel? doctorAppSubscribedSubscriptionsModel;
  Rx<String> error = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  void fetchSubscriptions() async {
    var userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print('userInfo.getUserToken');
      print(userInfo.getUserToken);
    }

    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${Constants.doctorAppPortalSubscriptionsUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(
            '${Constants.baseUrl}/${Constants.doctorAppPortalSubscriptionsUrl}');
      }

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        doctorAppSubscribedSubscriptionsModel =
            doctorAppSubscribedSubscriptionsModelFromJson(response.body);

        update();
        // NotificationsModel notificationsModel =
        //     notificationsModelFromJson(response.body);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      error('value');
      MyToast.showGetToast(
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
