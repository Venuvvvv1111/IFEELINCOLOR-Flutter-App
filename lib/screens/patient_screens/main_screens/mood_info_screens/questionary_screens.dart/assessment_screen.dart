import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/assesment_controller.dart';
import 'package:ifeelin_color/models/patient_models/Mood_info_models/assesemnt_level2_model.dart';
import 'package:ifeelin_color/models/patient_models/Mood_info_models/get_assesment_questions_model.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

class AssesmentScreen extends StatefulWidget {
  const AssesmentScreen({super.key});

  @override
  State<AssesmentScreen> createState() => _AssesmentScreenState();
}

class _AssesmentScreenState extends State<AssesmentScreen> {
  final AssesmentController controller = Get.put(AssesmentController());

  @override
  void initState() {
    super.initState();
    controller.fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profileDetailScreen);
              },
              child: ClipOval(
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  child: LoadNetworkImage(
                    UserInfo().getUserProfileUrl,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello! Welcome',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: whiteColor),
                ),
                Text(
                  UserInfo().getUserName ?? 'Hi User',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ],
        ),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoaderHelper.lottiWidget());
        }

        final question = controller.questions.isNotEmpty
            ? controller.questions[controller.currentQuestionIndex.value]
            : null;
        final level2question = controller.level2Questions.isNotEmpty
            ? controller
                .level2Questions[controller.level2currentQuestionIndex.value]
            : null;

        if (question == null) {
          return const Center(child: Text('No questions available'));
        }

        return Stepper(
          type: StepperType.horizontal,
          currentStep: controller.currentStep.value,
          onStepTapped: (step) {
            if (kDebugMode) {
              print(step);
            } // Move to the tapped step, but only if it's the next level
            if (step > controller.currentStep.value) {
              if (controller.isLevel1Completed.value) {
                setState(() {
                  controller.currentStep.value = step;
                });
              } else {
                Get.snackbar('Error', 'Please complete level 1 first',
                    colorText: Colors.white,
                    backgroundColor: Colors.red.withValues(alpha: 0.7));
              }
            } else {
              setState(() {
                controller.currentStep.value = 0;
              });
            }
          },
          controlsBuilder: (context, controller) {
            return const SizedBox.shrink();
          },
          steps: [
            Step(
              title: const Text('Level1'),
              content: levelOneForm(controller: controller, question: question),
              isActive: controller.currentStep.value >= 0,
            ),
            Step(
              title: const Text('Level2'),
              content:
                  level2Form(controller: controller, question: level2question),
              isActive: controller.currentStep.value >= 1,
            ),
          ],
        );
      }),
    );
  }
}

// ignore: camel_case_types
class levelOneForm extends StatelessWidget {
  const levelOneForm({
    super.key,
    required this.controller,
    required this.question,
  });

  final AssesmentController controller;
  final Body? question;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Purple Box
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.13,
          //   width: MediaQuery.of(context).size.width,
          //   color: primaryColor,
          // ),
          // Main Content
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width * 0.9,
            // height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Heading
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset(
                                AppIcons.familyMentalHealthHistoryIcon)),
                        const SizedBox(height: 12),
                        const Text(
                          "Assessment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Speakable(
                              text:  question?.question??'',
                              child: Text(
                                question?.question??'',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (question!.type == 'blanks')
                              Column(
                                children: [
                                  question?.media == null ||
                                          question?.media == ''
                                      ? const SizedBox(): LoadNetworkImage(
                                          question?.media??'',
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller:
                                        controller.textEditingController,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        hintText: 'Please enter your answer',
                                        hintStyle: TextStyle(fontSize: 13),
                                        border: OutlineInputBorder()),
                                  ),
                                ],
                              ),
                            if (question!.type == 'mcq')
                              Column(
                                children: question!.mcqOptions!.map((option) {
                                  return RadioListTile<String>(
                                    title: Text(option.text!),
                                    value: option.text!,
                                    groupValue: controller.selectedAnswer.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        TTSService().speak(value);
                                        controller.selectedAnswer.value = value;
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Speakable(
                                    text: "Click here to go back",
                                    child: ElevatedButton(
                                      onPressed:
                                          controller.currentQuestionIndex.value >
                                                  0
                                              ? () {
                                                  controller.previousQuestion();
                                                }
                                              : () {
                                                  Navigator.pop(context);
                                                },
                                      child: const Text('Back'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (question!.type == 'blanks' &&
                                              controller.textEditingController
                                                  .text.isNotEmpty ||
                                          question!.type == 'mcq' &&
                                              controller.selectedAnswer.value
                                                  .isNotEmpty) {
                                        controller.nextQuestion(context);
                                      } else {
                                        Get.snackbar('Error',
                                            'Please answer the question',
                                            colorText: whiteColor,
                                            backgroundColor: Colors.red
                                                .withValues(alpha: 0.7));
                                      }
                                    },
                                    child: Text(
                                        controller.currentQuestionIndex.value <
                                                controller.questions.length - 1
                                            ? 'Next'
                                            : 'Submit'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ignore: camel_case_types
class level2Form extends StatelessWidget {
  const level2Form({
    super.key,
    required this.controller,
    required this.question,
  });

  final AssesmentController controller;
  final Level2Body? question;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Purple Box
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.13,
          //   width: MediaQuery.of(context).size.width,
          //   color: primaryColor,
          // ),
          // Main Content
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width * 0.9,
            // height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Heading
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset(
                                AppIcons.familyMentalHealthHistoryIcon)),
                        const SizedBox(height: 12),
                        const Text(
                          "Assessment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${controller.level2currentQuestionIndex.value + 1}/${controller.level2Questions.length}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Speakable(
                              text: "${question?.question}",
                              child: Text(
                                "${question?.question}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                                  children: (question?.answer ?? []).map((option) {
                                    return Obx(
                                       () {
                                        return RadioListTile<String>(
                                          title: Text(option.option!),
                                          value: option.option!,
                                          groupValue:
                                              controller.level2selectedAnswer.value,
                                          onChanged: (value) {
                                            if (value != null) {
                                              controller.level2selectedAnswer.value =
                                                  value;
                                                   controller.updateLevel2Answer(question!.sId!, value); 
                                                       TTSService().speak(value);
                                            }
                                        
                                          },
                                        );
                                      }
                                    );
                                  }).toList(),
                                ),
                             
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Speakable(
                                    text: "Click here to go back",
                                    child: ElevatedButton(
                                      onPressed: controller
                                                  .currentQuestionIndex.value >
                                              0
                                          ? () {
                                              controller.level2PreviousQuestion();
                                            }
                                          : null,
                                      child: const Text('Back'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Speakable(
                                 text: "This is for ${controller
                                                  .level2currentQuestionIndex
                                                  .value <
                                              controller.level2Questions.length -
                                                  1
                                            ? 'Go to next question'
                                            : 'Review the form and submit'}",
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (controller.level2selectedAnswer.value
                                            .isNotEmpty) {
                                          controller.level2nextQuestion(context);
                                        } else {
                                          Get.snackbar('Error',
                                              'Please answer the question',
                                              colorText: whiteColor,
                                              backgroundColor: Colors.red
                                                  .withValues(alpha: 0.7));
                                        }
                                      },
                                      child: Text(controller
                                                  .level2currentQuestionIndex
                                                  .value <
                                              controller.level2Questions.length -
                                                  1
                                          ? 'Next'
                                          : 'Submit'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
