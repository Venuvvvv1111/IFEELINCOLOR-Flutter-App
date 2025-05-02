import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:lottie/lottie.dart';

class PaymenStatusDailog extends StatefulWidget {
  final bool? status;
  final bool? isUserLogin;
  const PaymenStatusDailog({
    super.key,
    this.status,
    this.isUserLogin,
  });

  @override
  State<PaymenStatusDailog> createState() => _PaymenStatusDailogState();
}

class _PaymenStatusDailogState extends State<PaymenStatusDailog> {
  @override
  Widget build(context) {
    return Dialog(
      backgroundColor: Colors.white.withValues(alpha: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Container(
            height: 300,
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                          widget.status == true
                              ? 'assets/animations/payment_success.json'
                              : 'assets/animations/payment_failure.json',
                          height: 150.0,
                          width: widget.status == true ? 150.0 : 250.0,
                          fit: BoxFit.fill),
                      widget.status == true
                          ? const Center(
                              child: Text(
                              'Successfully Subscribed',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ))
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.isUserLogin!) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.mainScreenTabs, (route) => false);
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.doctorMainTabsScreen,
                                  (Route<dynamic> route) =>
                                      false, // This removes all previous routes
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: primaryColor),
                            child: const Text(
                              'Okay',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
