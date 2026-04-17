import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/patient_models/Mood_info_models/treatment_history_model.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

class HealthController extends GetxController {
  var questions = <String>[].obs;
  var answers = <Map<String, String>>[].obs;
  var reasons = <String>[].obs;
  var currentQuestionIndex = 0.obs;
  var selectedAnswers = <String>[].obs;
  var reason = ''.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  final reasonController = TextEditingController();

  @override
  void onInit() {
    fetchHealthHistory();
    super.onInit();
  }

  Future<void> fetchHealthHistory() async {
    const url = '${Constants.baseUrl}/patients/history';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = TreatmentHistoryModel.fromJson(data);

        // Extract questions from treatment history
        questions.value = model.body?.socialInformation ?? [];
        answers.value = List.generate(
            questions.length,
            (index) => {
                  'question': questions[index],
                  'answer': '',
                  'reason': '',
                });
        reasons.value = List.filled(questions.length, '');
        selectedAnswers.value =
            List.filled(questions.length, ''); // Initialize selected answers
        hasError.value = false;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void updateCurrentQuestion() {
    final currentIndex = currentQuestionIndex.value;
    // Store the current question, selected answer, and reason in the answers map
    answers[currentIndex] = {
      'question': questions[currentIndex], // Store the question itself
      'answer': selectedAnswers[currentIndex], // Store the selected answer
      'reason': reasonController.text, // Store the reason (if any)
    };
    update();
  }

  void nextQuestion(context) {
    if (selectedAnswers[currentQuestionIndex.value].isNotEmpty) {
      // Save the current answer and reason
      updateCurrentQuestion();

      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
      } else {
        // Show review dialog at the end
        showReviewDialog(context);
      }
    } else {
       TTSService().speak("Please select any one");
      MyToast.showGetToast(
        title: "Error",
        message: "Please select an answer",
        backgroundColor: Colors.red,
        color: Colors.white,
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      // Save the current question's answer and reason
      updateCurrentQuestion();

      // Decrement index
      currentQuestionIndex.value--;

      // Load previous question's answer and reason
      final prevAnswer = answers[currentQuestionIndex.value];
      selectedAnswers[currentQuestionIndex.value] = prevAnswer['answer'] ?? '';
      reasonController.text = prevAnswer['reason'] ?? '';
    }
  }

  void showReviewDialog(context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Review Answers'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(questions.length, (index) {
              final answer = answers[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Speakable(
                       text: "${answer['question']}",
                    child: Text(
                      '${answer['question']}',
                      style: Get.textTheme.titleSmall,
                    ),
                  ),
                  Speakable(
                    text:  'Answer: ${answer['answer']}',
                    child: Text(
                      'Answer: ${answer['answer']}',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                   answer['reason'] != null || answer['reason']!.isEmpty
                      ? SizedBox()
                      : Text(
                          'Reason: ${answer['reason']}',
                    style: Get.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
        ),
        actions: [
          Speakable(
            text: "Click this to go back the form and check",
            child: TextButton(
              onPressed: () {
                Get.back(); // Go back to the questionnaire
              },
              child: const Text('Go back'),
            ),
          ),
          Speakable(
             text:"Click this to submit the form" ,
            child: TextButton(
              onPressed: () {
                // Post data to the server
                submitAnswers(context);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitAnswers(context) async {
    const url =
        '${Constants.baseUrl}/${Constants.updateHistory}'; // API endpoint

    // Creating the payload in the specified format
    final payload = {
      'socialInformation': answers.map((answer) {
        return {
          'question': answer['question'],
          'answer': answer['answer'],
          'description': answer['description'],
        };
      }).toList(),
    };

    try {
      LoaderHelper.showLoader(context);
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
        body: json.encode(payload),
      );
      LoaderHelper.hideLoader(context);
      if (kDebugMode) {
        print(response.body);
      }
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        UserInfo userinfo = Get.put(UserInfo());

        userinfo.addSocialHealthHistory = true;

        userinfo.refreshData();

        Get.snackbar('Success', 'Answers submitted successfully',
            backgroundColor: greenColor, colorText: Colors.white);
        TTSService().speak("Answers submitted successfully");
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        TTSService().speak("Failed to submit answers");
        Get.snackbar('Error', 'Failed to submit answers',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      TTSService().speak("Failed to submit answers");
      Get.snackbar('Error', 'Failed to submit answers',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
