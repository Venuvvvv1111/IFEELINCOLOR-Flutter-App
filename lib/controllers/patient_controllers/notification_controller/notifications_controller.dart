import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../models/patient_models/notification_model/notifications_model.dart';

class NotificationsController extends GetxController {
  var notificationsList = <Body>[].obs;
  var isLoading = true.obs;
  NotificationsModel? notificationsModel;
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    isLoading(true);
    var userInfo = Get.put(UserInfo());
    try {
      final response = await http.get(
        Uri.parse(userInfo.getUserLogin
            ? '${Constants.baseUrl}/${Constants.patientNotifications}'
            : '${Constants.baseUrl}/${Constants.doctorAppNotifications}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        notificationsModel = notificationsModelFromJson(response.body);
        if (kDebugMode) {
          print(notificationsModel?.body);
        }
        if (notificationsModel?.body != null) {
          notificationsList.value = notificationsModel!.body!;
        }
        if (kDebugMode) {
          print(notificationsList);
        }
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: 'Failed to load notifications',
            backgroundColor: Colors.red,
            color: whiteColor);
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
}
