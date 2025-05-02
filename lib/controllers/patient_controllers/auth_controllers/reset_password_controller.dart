import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class ResetPasswordController extends GetxController {
  // Controllers for TextFields
  var currentPasswordController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  var isLoading = true.obs;
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    // if (value.length < 6) {
    //   return "Password must be at least 6 characters long";
    // }
    return null;
  }

  Future<void> resetPassword(context, bool isDoctor) async {
    try {
      LoaderHelper.showLoader(context);
      if (kDebugMode) {
        print(
            '${Constants.baseUrl}/${isDoctor ? Constants.doctorChangePassword : Constants.changePassword}');
      }
      if (kDebugMode) {
        print(jsonEncode({
          "oldPassword": currentPasswordController.value.text,
          "newPassword": newPasswordController.value.text
        }));
      }
      final response = await http.put(
        Uri.parse(
            '${Constants.baseUrl}/${isDoctor ? Constants.doctorChangePassword : Constants.changePassword}'),
        body: jsonEncode({
          "currentPassword": currentPasswordController.value.text,
          "newPassword": newPasswordController.value.text
        }),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        MyToast.showGetToast(
            title: 'Success',
            message: 'Password changed successfully',
            backgroundColor: Colors.green,
            color: Colors.white);
        Navigator.pop(context);
        // Navigator.pushNamed(context, AppRoutes.passwordResetSuccessScreen);
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: json['message'],
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      LoaderHelper.hideLoader(context);
    }
  }

  // Add your password reset logic here
}
