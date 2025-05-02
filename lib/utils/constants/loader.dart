import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderHelper {
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Lottie.asset(
              'assets/animations/loader.json',
              height: 150.0,
              width: 150.0,
            ),
          ),
        );
      },
    );
  }

  static Widget lottiWidget() {
    return Lottie.asset(
      'assets/animations/loader.json',
      height: 200.0,
      width: 200.0,
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}
