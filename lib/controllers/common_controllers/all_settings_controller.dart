import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:http/http.dart' as http;

class AllSettingsController extends GetxController {
  RxBool notificationsEnabled = true.obs;

  void toggleNotification(bool value) {
    notificationsEnabled.value = value;
    String status = value ? "on" : "off";
    sendNotificationStatusToAPI(status);
  }

  Future<void> sendNotificationStatusToAPI(String status) async {
    UserInfo userInfo = Get.put(UserInfo());
    final url =
        Uri.parse('${Constants.baseUrl}/${Constants.notificationStatusChange}');

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${userInfo.getUserToken}'
      }, body: {
        'status': status
      });

      if (kDebugMode) {
        print(response.body);
        print(response.statusCode);
      }

      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: 'Something went wrong. Please try again.',
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    }
  }
}
