import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class MyToast {
  static showToast({required String message}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: greenColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showGetToast({
    required String title,
    required String message,
    Color? color,
    Color? backgroundColor,
  }) {
    return Get.snackbar(title, message,
        backgroundColor: backgroundColor, colorText: color);
  }
}
