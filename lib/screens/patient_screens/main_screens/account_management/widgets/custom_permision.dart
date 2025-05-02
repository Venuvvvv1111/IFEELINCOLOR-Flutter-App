import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const Color kDarkGray = Color(0xFFA3A3A3);

class CustomPermissionDialog {
  static void show(context, String heading, String subHeading,
      String positiveButtonText, VoidCallback onPressedPositive,
      [String? negativeButtonText, VoidCallback? onPressedNegative]) {
    if (Platform.isIOS) {
      // iOS-specific code
      showCupertinoDialog(
        context: context,
        useRootNavigator: false,
        builder: (_) => CupertinoAlertDialog(
          title: Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            subHeading,
            style: const TextStyle(
              color: kDarkGray,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                negativeButtonText ?? 'Cancel',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: onPressedPositive,
              child: Text(positiveButtonText),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: Text(
            heading,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            subHeading,
            style: const TextStyle(
              color: kDarkGray,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (onPressedNegative != null) {
                  onPressedNegative();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                negativeButtonText ?? 'Cancel',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: onPressedPositive,
              child: Text(positiveButtonText),
            ),
          ],
        ),
      );
    }
  }
}
