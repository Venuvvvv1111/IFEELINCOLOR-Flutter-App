import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/patient_models/Mood_info_models/treatment_history_model.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';

class TreatmentHistoryController extends GetxController {
  var questions = <String>[].obs;
  var answers = <Map<String, String>>[].obs;
  var reasons = <String>[].obs;
  var currentQuestionIndex = 0.obs;
  var selectedAnswer = ''.obs;
  var reason = ''.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  final reasonController = TextEditingController();

  @override
  void onInit() {
    fetchTreatmentHistory();
    super.onInit();
  }

  Future<void> fetchTreatmentHistory() async {
    const url = '${Constants.baseUrl}/patients/history';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = TreatmentHistoryModel.fromJson(data);

        // Extract questions from treatment history
        questions.value = model.body?.treatmentHistory ?? [];
        answers.value = List.generate(
            questions.length,
            (index) => {
                  'question': questions[index],
                  'answer': '',
                  'reason': '',
                });
        reasons.value = List.filled(questions.length, '');

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
    answers[currentIndex] = {
      'question': questions[currentIndex],
      'answer': selectedAnswer.value,
      'reason': reasonController.text,
    };
  }

  void nextQuestion(context) async{
    if (selectedAnswer.isNotEmpty) {
      updateCurrentQuestion();
      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
        selectedAnswer.value =
            answers[currentQuestionIndex.value]['answer'] ?? '';
        reasonController.text =
            answers[currentQuestionIndex.value]['reason'] ?? '';
       await TTSService().speak("${questions[currentQuestionIndex.value]}");
                    await Future.delayed(const Duration(seconds: 1));
          await  TTSService().speak("Please select any one");
      } else {
        showReviewDialog(context);
      }
    } else {
      TTSService().speak("Please select any one");
      Get.snackbar('Error', 'Please select any one',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void previousQuestion(context) {
    if (currentQuestionIndex.value > 0) {
      updateCurrentQuestion();
      currentQuestionIndex.value--;
      final prevAnswer = answers[currentQuestionIndex.value];
      selectedAnswer.value = prevAnswer['answer'] ?? '';
      reasonController.text = prevAnswer['reason'] ?? '';
    } else {
      Navigator.pop(context);
    }
  }

  void showReviewDialog(context) {
    TTSService().speak("Please review the answers and submit");
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
                    text: 'Answer: ${answer['answer']}',
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
                // Post data to the server

                Get.back();
              },
              child: const Text(
                'Go Back',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Speakable(
            text: "Click this to submit the form",
            child: TextButton(
              onPressed: () {
                // Post data to the server
                submitAnswers(context);
              },
              child: const Text(
                'Submit',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitAnswers(context) async {
    const url = '${Constants.baseUrl}/patients/update-history'; // API endpoint

    // Creating the payload in the specified format
    final payload = {
      'treatmentHistory': answers.map((answer) {
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
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        UserInfo userinfo = Get.put(UserInfo());

        userinfo.addTreatmentHistory = true;

        userinfo.refreshData();
        TTSService().speak("Answers submitted successfully");
        Get.snackbar('Success', 'Answers submitted successfully',
            backgroundColor: greenColor, colorText: whiteColor);

        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        TTSService().speak("Failed to submit answers");
        Get.snackbar('Error', 'Failed to submit answers',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      TTSService().speak("Failed to submit answers");
      Get.snackbar('Error', 'Failed to submit answers',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }
}
