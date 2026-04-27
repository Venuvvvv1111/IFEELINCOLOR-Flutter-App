import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/treatment_hostory_controller.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

class TreatmentHistory extends StatefulWidget {
  const TreatmentHistory({super.key});

  @override
  State<TreatmentHistory> createState() => _TreatmentHistoryState();
}

class _TreatmentHistoryState extends State<TreatmentHistory> {
  final controller = Get.put(TreatmentHistoryController());
  bool isTtsOn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = Get.find<UserInfo>();
    isTtsOn = userInfo.isTtsEnabled.value;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isTtsOn) {
        // ever(controller.questions, (_) async {
        //   if (isTtsOn && controller.questions.isNotEmpty) {
        //     await Future.delayed(const Duration(milliseconds: 300));

        //    await TTSService().speak(
        //       controller.questions[controller.currentQuestionIndex.value],
        //     );
        //                 await Future.delayed(const Duration(seconds: 2));

        //    await TTSService().speak(
        //       "Please select any one. Options are Yes or No.",
        //     );
        //   }
        // });

        ever(controller.questions, (_) async {
          if (isTtsOn && controller.questions.isNotEmpty) {
            await TTSService().speak(
              controller.questions[controller.currentQuestionIndex.value],
            );

            await Future.delayed(const Duration(seconds: 1));

            await TTSService().speak(
              "Please select any one. Options are Yes or No.",
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    Get.delete<TreatmentHistoryController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Adjust the body when the keyboard appears
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
                    UserInfo().getUserProfileUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
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
                Text(UserInfo().getUserName ?? 'Hi User',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: whiteColor)),
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
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return const Center(child: Text('Failed to load data'));
        }

        return SingleChildScrollView(
          // Add scroll view to handle keyboard overflow
          child: Stack(
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
                              child: Image.asset(AppIcons.treatmentHistory)),
                          const SizedBox(height: 12),
                          const Text(
                            "Treatment History",
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
                                text: controller.questions[
                                    controller.currentQuestionIndex.value],
                                child: Text(
                                  controller.questions[
                                      controller.currentQuestionIndex.value],
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Obx(() {
                                final userInfo = Get.find<UserInfo>();
                                final isTtsOn = userInfo.isTtsEnabled.value;
                                final selected =
                                    controller.selectedAnswer.value;

                                Color getColor(String value) {
                                  if (!isTtsOn) return Colors.black;

                                  if (value == "Yes") return Colors.green;
                                  if (value == "No") return Colors.red;

                                  return Colors.black;
                                }

                                return Speakable(
                                  text:
                                      "Please select any one. Options are Yes or No.",
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor, width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        isExpanded: true,
                                        hint:
                                            const Text('Please select any one'),
                                        value:
                                            selected.isEmpty ? null : selected,

                                        // 🔥 Selected item style
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: getColor(selected),
                                            ),

                                        items: ['Yes', 'No'].map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isTtsOn
                                                    ? (value == "Yes"
                                                        ? Colors.green
                                                        : Colors.red)
                                                    : Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),

                                        onChanged: (String? newValue) async {
                                          controller.selectedAnswer.value =
                                              newValue!;

                                          if (isTtsOn) {
                                            await TTSService().speak(
                                                "You selected $newValue");

                                            // small pause (important for UX)
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));

                                            controller.nextQuestion(context);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              Text('Reason (optional)',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controller.reasonController,
                                decoration: InputDecoration(
                                  hintText: 'Please Enter reason',
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10, 16, 0, 0), // Adjust padding

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        4), // Rounded corners
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.grey), // Border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors
                                            .blue), // Border color when focused
                                  ),
                                  // You may adjust these properties if needed
                                ),
                                maxLines: 3,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Speakable(
                                    text: "This is for Go Back",
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: isTtsOn
                                              ? Colors.red
                                              : primaryColor),
                                      onPressed: () {
                                        controller.previousQuestion(context);
                                      },
                                      child: const Text('Back'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Speakable(
                                    text:
                                        "This is for ${controller.currentQuestionIndex.value < controller.questions.length - 1 ? 'Go to next question' : 'Review the form'}",
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: isTtsOn
                                              ? Colors.green
                                              : primaryColor),
                                      onPressed: () {
                                        controller.nextQuestion(context);
                                      },
                                      child: Text(
                                        controller.currentQuestionIndex.value <
                                                controller.questions.length - 1
                                            ? 'Next'
                                            : 'Review',
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
            ],
          ),
        );
      }),
    );
  }
}
