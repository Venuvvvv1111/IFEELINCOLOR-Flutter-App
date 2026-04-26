import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/two_d_model_controller.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/Route/app_Routes.dart';

import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';
import 'package:lottie/lottie.dart';

class TwoDModelScreen extends StatefulWidget {
  const TwoDModelScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TwoDModelScreenState createState() => _TwoDModelScreenState();
}

class _TwoDModelScreenState extends State<TwoDModelScreen> {
  final TwoDModelController controller = Get.put(TwoDModelController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TTSService().speak("Please select a black circle to get assesment form");
  }

// @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//    controller. resetAll();
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Body Assessment',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor: primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: whiteColor,
            )),
        actions: [
          CircleAvatar(
            backgroundColor: whiteColor,
            child: IconButton(
              icon: Image(image: AssetImage(AppIcons.notificationIcon)),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.allNotificationsScreen);
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          // Wrapping the Stack with a container to provide constraints
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppImages.dModelImage,
                    fit: BoxFit.fill,
                  ),
                ),
                ..._buildCircles(context),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.questions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Speakable(
                  text: 'Please select a circle to get assessment.',
                  child: Column(
                    children: [
                      Text(
                        'Please select a circle to get assessment.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Image(
                          image: AssetImage("assets/images/no_data_found.avif"))
                    ],
                  ),
                ),
              );
            } else {
              final currentQuestion =
                  controller.questions[controller.currentQuestionIndex.value];
              final currentIndex = controller.currentQuestionIndex.value + 1;
              final totalQuestions = controller.questions.length;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$currentIndex/$totalQuestions',
                              // style: Theme.of(context).textTheme.,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Speakable(
                          text: currentQuestion.question ?? '',
                          child: Text(
                            currentQuestion.question ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              isExpanded: true,
                              hint: const Text('Please select any one'),
                              style: Theme.of(context).textTheme.labelLarge,
                              value: controller.selectedAnswer.isEmpty
                                  ? null
                                  : controller.selectedAnswer,
                              items: currentQuestion.mcqOptions
                                  ?.map<DropdownMenuItem<String>>(
                                      (option) => DropdownMenuItem<String>(
                                            value: option.text ?? '',
                                            child: Text(option.text ?? ''),
                                          ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                controller.selectAnswer(
                                    currentQuestion.sId ?? '', newValue ?? '',context);
                                // if (aewValue != null && newValue.isNotEmpty) {
                                //   TTSService().speak(newValue);
                                // }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Speakable(
                              text: "Click here to go back",
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.previousQuestion();
                                },
                                child: const Text('Back'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Speakable(
                              text:
                                  "This is for ${controller.currentQuestionIndex.value < controller.questions.length - 1 ? 'Go to next question' : 'Review the form and submit'}",
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.nextQuestion(
                                      context); // Pass context here
                                },
                                child: Text(
                                  controller.currentQuestionIndex.value <
                                          controller.questions.length - 1
                                      ? 'Next'
                                      : 'Submit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      )),
    );
  }

  // Build circle widgets
  List<Widget> _buildCircles(BuildContext context) {
    return List.generate(6, (index) {
      final List<String> tooltips = [
        'Leg',
        'Heart',
        'Eye',
        'hand',
        'Foot',
        'lungs',
      ];
      return Positioned(
        top: _getCirclePosition(index, context).dy,
        left: _getCirclePosition(index, context).dx,
        child: Tooltip(
          message: tooltips[index],
          child: GestureDetector(
            onTap: () => controller.selectCircle(index),
            child: Obx(() => controller.isSelected[index]
                ? Lottie.asset('assets/animations/red_dot1.json', width: 30)
                : Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  )),
          ),
        ),
      );
    });
  }

  // Function to return position of each circle
  Offset _getCirclePosition(int index, BuildContext context) {
    switch (index) {
      //legs
      case 0:
        return Offset(MediaQuery.of(context).size.width * 0.12,
            MediaQuery.of(context).size.height * 0.33);
      case 1:
        //heart
        return Offset(MediaQuery.of(context).size.width * 0.25,
            MediaQuery.of(context).size.height * 0.1);
      case 2:
        //eye
        return Offset(MediaQuery.of(context).size.width * 0.18,
            MediaQuery.of(context).size.height * 0.020);
      case 3:
        //hand
        return Offset(MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.17);
      case 4:
        //foot
        return Offset(MediaQuery.of(context).size.width * 0.26,
            MediaQuery.of(context).size.height * 0.46);
      case 5:
        //lungs
        return Offset(MediaQuery.of(context).size.width * 0.16,
            MediaQuery.of(context).size.height * 0.12);
      default:
        return const Offset(0, 0);
    }
  }

}
