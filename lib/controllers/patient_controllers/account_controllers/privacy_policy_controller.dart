import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'dart:convert';

class PrivacyPolicyController extends GetxController {
  var isLoading = true.obs;
  Rx<String?> title = Rx<String?>(null); // Nullable Rx<String?>
  Rx<String?> content = Rx<String?>(null); // Nullable Rx<String?>

  Future<void> fetchPrivacyPolicy() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/privacy/latest-new'),
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
        title.value = json['body']['title'] as String?; // Handle nullability
        content.value =
            json['body']['content'] as String?; // Handle nullability
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        Get.snackbar('Error', 'Failed to load privacy policy',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', '$e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
