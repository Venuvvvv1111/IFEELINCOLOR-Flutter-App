import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/intake_details_controllers/intake_details_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class PatientIntakeDetailsScreen extends StatefulWidget {
  final String patientId;

  const PatientIntakeDetailsScreen({super.key, required this.patientId});

  @override
  State<PatientIntakeDetailsScreen> createState() =>
      _PatientIntakeDetailsScreenState();
}

class _PatientIntakeDetailsScreenState
    extends State<PatientIntakeDetailsScreen> {
  final IntakeDetailsController controller = Get.put(IntakeDetailsController());
  final UserInfo _userInfo = Get.put(UserInfo());
  @override
  void initState() {
    super.initState();
    controller.fetchPatientData(widget.patientId);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<IntakeDetailsController>();
  }

  Color _getStepColor(int stepIndex) {
    return _currentStep == stepIndex ? doctorPrimaryColor : Colors.grey;
  }

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Intake Details',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor:
            _userInfo.getDoctorLogin ? doctorPrimaryColor : primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: whiteColor,
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value == true) {
          return Center(child: LoaderHelper.lottiWidget());
        } else if (controller.error.value == 'error' ||
            controller.patientInfo.value == null) {
          return const Center(
            child: Text('Sorry! Please try after sometime'),
          );
        } else {
          final patientInfo = controller.patientInfo.value!;
          final assessmentInfos = controller.assessmentInfos;

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: doctorPrimaryColor, // Active step number color
              ),
            ),
            child: Stepper(
              elevation: 10,
              steps: [
                Step(
                  title: Text(
                    'Treatment History',
                    style: TextStyle(
                      color: _getStepColor(0),
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  content: _buildCardContent(patientInfo.treatmentHistory),
                ),
                Step(
                  title: Text(
                    'Health & Social Information',
                    style: TextStyle(
                      color: _getStepColor(1),
                    ),
                  ),
                  isActive: _currentStep >= 1,
                  content: _buildCardContent(patientInfo.socialInformation),
                ),
                Step(
                  title: Text(
                    'Assessment Info',
                    style: TextStyle(
                      color: _getStepColor(2),
                    ),
                  ),
                  isActive: _currentStep >= 2,
                  content: _buildAssessmentContent(assessmentInfos),
                ),
              ],
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
            ),
          );
        }
      }),
    );
  }

  Widget _buildCardContent(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Question: ${item.question}",
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Text(
                        "Answer: ${item.answer}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAssessmentContent(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mood: ${item.mood}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Mood Level: ${item.moodLevel}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Last Updated: ${MediaQueryUtil.formatDoctorDateWithSuffix(DateTime.parse(item.updatedAt.toString()))} ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
