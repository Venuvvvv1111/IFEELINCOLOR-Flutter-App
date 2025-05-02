import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:lottie/lottie.dart';

class EmailVerifyDailog extends StatefulWidget {
  const EmailVerifyDailog({
    super.key,
  });

  @override
  State<EmailVerifyDailog> createState() => _SuccesDialogState();
}

class _SuccesDialogState extends State<EmailVerifyDailog> {
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
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/verifyEmail.json',
                        height: 150.0,
                        width: 150.0,
                      ),
                      const Center(
                          child: Text(
                        'Success! Email Sent',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        'Please check your registered email and verify',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                              // Navigator.pushNamed(
                              //     context, AppRoutes.subscriptionTypeScreen);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: primaryColor),
                            child: const Text(
                              'done',
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
          Positioned(
              right: 0,
              top: 15,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.close_sharp,
                    color: Colors.red,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
