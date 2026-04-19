import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/health_information_controller.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

class HealthSocialInformation extends StatefulWidget {
  const HealthSocialInformation({super.key});

  @override
  State<HealthSocialInformation> createState() =>
      _HealthSocialInformationState();
}

class _HealthSocialInformationState extends State<HealthSocialInformation> {
  final HealthController controller = Get.put(HealthController());
  final UserInfo userInfo = Get.put(UserInfo());
  bool isTtsOn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = Get.find<UserInfo>();
    isTtsOn = userInfo.isTtsEnabled.value;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isTtsOn) {
        ever(controller.questions, (_) async {
          if (isTtsOn && controller.questions.isNotEmpty) {
            await Future.delayed(const Duration(milliseconds: 300));

            TTSService().speak(
              controller.questions[controller.currentQuestionIndex.value],
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    Get.delete<HealthController>();
    super.dispose();
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
              child: CircleAvatar(
                backgroundColor: whiteColor,
                child: ClipOval(
                  child: LoadNetworkImage(
                    userInfo.getUserProfileUrl,
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
                Text('Hello! Welcome',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: whiteColor)),
                Text(userInfo.getUserName ?? 'Hi User',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: whiteColor)),
              ],
            )
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
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError.value) {
          return const Center(child: Text('Error loading data'));
        }

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // Purple Box
            Container(
              height: MediaQueryUtil.size(context).height * 0.13,
              color: primaryColor,
            ),
            // Main Content
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: MediaQuery.sizeOf(context).width * 0.9,
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
                              child:
                                  Image.asset(AppIcons.socialInformationIcon)),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Health & Social Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                text: controller.questions[
                                    controller.currentQuestionIndex.value],
                                child: Text(
                                  controller.questions[
                                      controller.currentQuestionIndex.value],
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...['Yes', 'No', 'I don\'t know']
                                  .map((String value) {
                                return Speakable(
                                  text: value,
                                  child: CheckboxListTile(
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: const EdgeInsets.all(0),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    dense: true,
                                    title: isTtsOn
                                        ? Text(
                                            value,
                                            style: TextStyle(
                                              color: value == 'Yes'
                                                  ? Colors.green
                                                  : value == 'No'
                                                      ? Colors.red
                                                      : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : Text(value),
                                    value: controller.selectedAnswers[controller
                                            .currentQuestionIndex.value] ==
                                        value, // Check current answer for each question
                                    onChanged: (bool? checked) async {
                                      controller.selectedAnswers[
                                          controller.currentQuestionIndex
                                              .value] = checked == true
                                          ? value
                                          : ''; // Update only the current question's answer

                                      if (isTtsOn) {
                                        await TTSService()
                                            .speak("You selected $value");

                                        // small pause (important for UX)
                                        await Future.delayed(
                                            const Duration(milliseconds: 500));

                                        controller.nextQuestion(context);
                                      }
                                    },
                                  ),
                                );
                                // ignore: unnecessary_to_list_in_spreads
                              }).toList(),
                              if (controller
                                      .selectedAnswers[
                                          controller.currentQuestionIndex.value]
                                      .isNotEmpty &&
                                  controller.selectedAnswers[controller
                                          .currentQuestionIndex.value] !=
                                      "I don't know")
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'If ${controller.selectedAnswers[controller.currentQuestionIndex.value]}, give me a reason: (optional)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: controller.reasonController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 13, horizontal: 10),
                                          filled: true,
                                          fillColor: whiteColor,
                                          hintText: 'Please enter reason',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                          border: const OutlineInputBorder(),
                                        ),
                                        style: const TextStyle(height: 1.2),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQueryUtil.size(context).width /
                                        3.5,
                                    child: Speakable(
                                      text: "Click here to go back",
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: isTtsOn
                                                ? Colors.red
                                                : primaryColor),
                                        onPressed: controller
                                                    .currentQuestionIndex
                                                    .value >
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
                                    width: MediaQueryUtil.size(context).width /
                                        3.5,
                                    child: Speakable(
                                      text:
                                          "This is for ${controller.currentQuestionIndex.value < controller.questions.length - 1 ? 'Go to next question' : 'Review the form and submit'}",
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: isTtsOn
                                                ? Colors.green
                                                : primaryColor),
                                        onPressed: () {
                                          // Check if the selected answer is not empty for the current question
                                          if (controller
                                              .selectedAnswers[controller
                                                  .currentQuestionIndex.value]
                                              .isNotEmpty) {
                                            controller.nextQuestion(context);
                                          } else {
                                            Get.snackbar('Error',
                                                'Please select an option',
                                                colorText: whiteColor,
                                                backgroundColor: Colors.red
                                                    .withValues(alpha: 0.7));
                                          }
                                        },
                                        child: Text(controller
                                                    .currentQuestionIndex
                                                    .value <
                                                controller.questions.length - 1
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
            )
          ],
        );
      }),
    );
  }
}
