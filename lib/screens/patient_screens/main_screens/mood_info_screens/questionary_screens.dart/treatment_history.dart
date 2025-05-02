import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/treatment_hostory_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class TreatmentHistory extends StatefulWidget {
  const TreatmentHistory({super.key});

  @override
  State<TreatmentHistory> createState() => _TreatmentHistoryState();
}

class _TreatmentHistoryState extends State<TreatmentHistory> {
  final controller = Get.put(TreatmentHistoryController());

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
                              Text(
                                controller.questions[
                                    controller.currentQuestionIndex.value],
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    isExpanded: true,
                                    hint: const Text('Please select any one'),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                    value:
                                        controller.selectedAnswer.value.isEmpty
                                            ? null
                                            : controller.selectedAnswer.value,
                                    items: <String>[
                                      'Yes',
                                      'No',
                                    ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (String? newValue) {
                                      controller.selectedAnswer.value =
                                          newValue!;
                                    },
                                  ),
                                ),
                              ),
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
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.previousQuestion(context);
                                    },
                                    child: const Text('Back'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
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
