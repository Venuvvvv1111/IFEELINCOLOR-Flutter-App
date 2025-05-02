import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/patient_models/AccountModels/my_subscribed_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'dart:convert';

class MySubscriptionController extends GetxController {
  var isLoading = true.obs;
  MySubscriptionsModel? mySubscriptionsModel;
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
        Uri.parse('${Constants.baseUrl}/${Constants.mySubscriptions}'),
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
        mySubscriptionsModel = mySubscriptionsModelFromJson(response.body);
        if (kDebugMode) {
          print(json);
        }
        // NotificationsModel notificationsModel =
        //     notificationsModelFromJson(response.body);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: response.reasonPhrase.toString(),
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      error('value');
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
