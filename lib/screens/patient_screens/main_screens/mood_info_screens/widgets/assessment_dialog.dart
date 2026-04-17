import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

import 'package:lottie/lottie.dart';

class AssessmentDialog extends StatefulWidget {
  const AssessmentDialog({
    super.key,
  });

  @override
  State<AssessmentDialog> createState() => _AssessmentDialogState();
}

class _AssessmentDialogState extends State<AssessmentDialog> {
  UserInfo userInfo = Get.put(UserInfo());
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
                        'assets/animations/assesment_icon.json',
                        height: 150.0,
                        width: 150.0,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Speakable(
                        text: "Choose Any One to continew",
                        child: const Center(
                            child: Text(
                          'Choose Any One',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Speakable(
                        text: 'Please Select anyone to submit form',
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Please Select anyone to submit form',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: Speakable(
                            text: "This is Question Model",
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                  //  TTSService().speak("You selected Question Model");
                                Navigator.pushNamed(
                                    context, AppRoutes.familyMentalHealth);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: primaryColor),
                              child: const Text(
                                'Question Model',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: Speakable(
                            text:  'This is 2D Body Model',
                            child: ElevatedButton(
                              onPressed: () {
                                // TTSService().speak("You selected 2D Body Model");
                                      Navigator.pop(context);
                                Navigator.pushNamed(context, AppRoutes.twodModel);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: primaryColor),
                              child: const Text(
                                '2D Body Model',
                                style: TextStyle(color: Colors.white),
                              ),
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
                  userInfo.refreshData();
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
