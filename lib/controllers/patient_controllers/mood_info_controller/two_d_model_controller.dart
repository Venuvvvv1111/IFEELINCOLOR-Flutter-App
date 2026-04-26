import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/widgets/nested_question_dailog.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import '../../../models/patient_models/Mood_info_models/body_questions_model.dart';

class TwoDModelController extends GetxController {
  RxList<bool> isSelected = List.generate(6, (index) => false).obs;
  RxList<int> selectedCircles = <int>[].obs;
  RxList<Body> questions = <Body>[].obs; // List to hold fetched questions
  RxInt currentQuestionIndex = 0.obs; // Index for current question
  RxMap<String, String> selectedAnswers =
      <String, String>{}.obs; // Map to hold selected answers
  Rx<String> mood = 'Stress'.obs;
  Rx<String> description = ''.obs;
  Rx<bool> moodResult = false.obs;
  // API URLs
  final String fetchQuestionsUrl =
      '${Constants.baseUrl}/body-part-questionnaires';
  final String submitAnswersUrl =
      '${Constants.baseUrl}/submit-body-part-questionnaires';
        final String getBodyAssesmentResult =
      '${Constants.baseUrl}/final-result';
  Rx<String> colorTitle = ''.obs;
  Rx<String> colorSubtitle = ''.obs;
  Rx<String> colorCategory = ''.obs;
  Rx<String> mainColor = ''.obs;
  Rx<Color> colorCircle = Colors.transparent.obs;

  Rx<int> colorValue = 0.obs;
  final userInfo = Get.find<UserInfo>();
  bool get isTtsOn => userInfo.isTtsEnabled.value;
  Future<void> selectCircle(int index) async {
    if (isSelected[index]) {
      selectedCircles.remove(index);
      isSelected[index] = false;
      await fetchQuestions(selectedCircles);
    } else {
      selectedCircles.add(index);
      isSelected[index] = true;

      await fetchQuestions(selectedCircles);
    }
  }

  Future<void> speakCurrentQuestion() async {
    if (questions.isEmpty) return;

    final q = questions[currentQuestionIndex.value];

    // 🔴 Stop previous speech (VERY IMPORTANT)
    await TTSService().stop();

    // 🟢 Speak question
    await TTSService().speak(q.question ?? '');

    await Future.delayed(const Duration(milliseconds: 400));

    // 🟢 Speak options
    if (q.mcqOptions != null) {
      for (var opt in q.mcqOptions!) {
        await TTSService().speak(opt.text ?? '');
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }

    // 🟢 Guide user
    await TTSService().speak("Please select your answer");
  }

  // Fetch questions based on selected part IDs
  Future<void> fetchQuestions(List<int> selectedCircles) async {
    questions.clear();
    currentQuestionIndex.value = 0;

    if (kDebugMode) {
      print(
        selectedCircles.map((id) {
          switch (id) {
            case 1:
              //heart
              return '66e039b8d696d7e3b3effc86';
            case 2:
              //eye
              return '66e039b1d696d7e3b3effc83';
            case 3:
              //hand
              return '66e039a1d696d7e3b3effc7d';
            case 4:
              //foot
              return '66e039a9d696d7e3b3effc80';
            case 5:
              //lung
              return '66e039bfd696d7e3b3effc89';
            default:
              //legs
              return '6717da2e77b89ab195346b43';
          }
        }).toList(),
      );
    }

    try {
      //hand
      //66e039a1d696d7e3b3effc7d
      //"_id": "66e039a9d696d7e3b3effc80",
      //  "partName": "Foot",
      //"_id": "66e039b1d696d7e3b3effc83",
      //      "partName": "Eye",
      //     "_id": "66e039b8d696d7e3b3effc86",
      //      "partName": "Heart",

      // "_id": "66e039bfd696d7e3b3effc89",
      //      "partName": "Lung",

      //  "_id": "6717da2e77b89ab195346b43",
      //     "partName": "Legs",
      final response = await http.post(
        Uri.parse(fetchQuestionsUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "bodyPartIds": selectedCircles.map((id) {
            switch (id) {
              case 1:
                //heart
                return '66e039b8d696d7e3b3effc86';
              case 2:
                //eye
                return '66e039b1d696d7e3b3effc83';
              case 3:
                //hand
                return '66e039a1d696d7e3b3effc7d';
              case 4:
                //foot
                return '66e039a9d696d7e3b3effc80';
              case 5:
                //lung
                return '66e039bfd696d7e3b3effc89';
              default:
                //legs
                return '6717da2e77b89ab195346b43';
            }
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        moodResult.value = false;
        var data = json.decode(response.body);
        List<Body> tempQuestions = [];

        List questionnaires = data['data']['questions'];

        for (var qSet in questionnaires) {
          List innerQuestions = qSet['questions'];

          for (var q in innerQuestions) {
            if (q['options'] != null && q['options'].isNotEmpty) {
              tempQuestions.add(Body.fromNewApiJson(q));
            }
          }
        }

        questions.value = tempQuestions;
        currentQuestionIndex.value = 0; // Start from the first question
        await speakCurrentQuestion();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching questions: $e");
      }
    }
  }

  // Select an answer for the current question
  void selectAnswer(
      String questionId, String answer, BuildContext context) async {
    selectedAnswers[questionId] = answer;
    if (isTtsOn) {
      // 🔊 Speak selected answer
      await TTSService().speak("You selected $answer");

      // ⏱ Small delay for UX
      await Future.delayed(const Duration(milliseconds: 500));
      if (!context.mounted) {
        return;
      }
      // 🚀 Auto move to next
      nextQuestion(context);
    }
  }

  String get selectedAnswer {
    final currentQuestion = questions[currentQuestionIndex.value];
    return selectedAnswers[currentQuestion.sId] ?? '';
  }

  // Handle next question or submit
  void nextQuestion(BuildContext context) async {
    final currentQuestionId = questions[currentQuestionIndex.value].sId;
    if (selectedAnswers[currentQuestionId] == null ||
        selectedAnswers[currentQuestionId]!.isEmpty) {
      // Show an error message if no answer is selected
      Get.snackbar(
        'Error',
        'Please select an answer before proceeding.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
        await speakCurrentQuestion();
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return showResult(context);
            });
      }
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  AlertDialog showResult(context) {
    return AlertDialog(
      title: const Text('Review Answers'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedAnswers.entries.map((entry) {
            // Find the matching question by question ID
            final question = questions.firstWhere((q) => q.sId == entry.key);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question: ${question.question}', // Display question text
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Answer: ${entry.value}'), // Display selected answer
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Proceed to submit answers
            Navigator.pop(context);
          },
          child: Text(
            'Go Back',
            style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
          ),
        ),
        TextButton(
          onPressed: () {
            // Proceed to submit answers
            submitAnswers(context);
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<void> submitAnswers(context) async {
    final userInfo = Get.find<UserInfo>();
    if (kDebugMode) {
      print(
        json.encode({
          "answers": selectedAnswers.entries
              .map((entry) => {
                    "questionId": entry.key,
                    "answer": entry.value,
                  })
              .toList(),
        }),
      );
    }
    try {
      LoaderHelper.showLoader(context);
      final response = await http.post(
        Uri.parse(submitAnswersUrl + "/" + "${userInfo.getPatientId}"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "answers": selectedAnswers.entries
              .map((entry) => {
                    "questionId": entry.key,
                    "answer": entry.value,
                  })
              .toList(),
        }),
      );
      LoaderHelper.hideLoader(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // final json = jsonDecode(response.body);

        UserInfo userinfo = Get.put(UserInfo());
        userinfo.addAssesment = false;
        userinfo.addBodyAssesment = true;
        userinfo.refreshData();
        update();

        moodResult.value = true;
        // colorTitle.value = json['body']['maxCategoryDetails']['hexColor'];
        // updateColorValue(colorTitle.value);
        // colorSubtitle.value =
        //     json['body']['maxCategoryDetails']['description'] ?? "";
        // colorCategory.value = json['body']['maxCategoryDetails']['mood'] ?? "";
        // mood.value =
        //     json["body"]["maxCategoryDetails"]["mood"].toString() ?? "Stress";
        // description.value =
        //     json['body']['maxCategoryDetails']['description'] ?? 'desc';
        Get.snackbar('Success', 'Answers submitted successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green.withValues(alpha: 0.7));
        if (isTtsOn) {
          TTSService().speak("Answers submitted successfully");
        }

        // Handle success, show result, etc.
        if (kDebugMode) {
          print("Answers submitted successfully");
        }
        Navigator.pop(context);
        Get.dialog(QuestionDialog());
        // Navigator.pop(context);
      } else {
        if (isTtsOn) {
          TTSService().speak("Failed to submit answers");
        }

        Navigator.pop(context);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      if (isTtsOn) {
        TTSService().speak("Failed to submit answers");
      }
      if (kDebugMode) {
        print("Error submitting answers: $e");
      }
    }
  }

  Future<void> getFinalResult(context) async {
    final userInfo = Get.find<UserInfo>();

    
      // LoaderHelper.showLoader(context);
      final response = await http.get(
        Uri.parse("${getBodyAssesmentResult}/${userInfo.getPatientId}"),
        headers: {'Content-Type': 'application/json'},
   
      );
      // LoaderHelper.hideLoader(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        colorTitle.value = json['result']['colorCode'];
        updateColorValue(colorTitle.value);
        colorSubtitle.value =
            json['result']['aboutCondition'] ?? "";
        colorCategory.value = json['result']['patientCondition'] ?? "";
        mood.value =
            json["result"]["patientCondition"].toString() ?? "Stress";
        description.value =
            json['result']['aboutCondition'] ?? 'desc';



        // Handle success, show result, etc.
        // Navigator.pop(context);
      }
  }

  void updateColorValue(String getColorValue) {
    switch (colorTitle.value) {
      case '#000000':
        colorValue.value = 0;
        mainColor.value = 'Black';
        colorCircle.value = const Color(0xFF000000);
        break;
      case '#081844':
        colorValue.value = 1;
        mainColor.value = 'Blue';
        colorCircle.value = const Color(0xFF081844);
        break;
      case '#ba2f24':
        colorValue.value = 2;
        mainColor.value = 'Red';
        colorCircle.value = const Color(0xFFba2f24);
        break;
      case '#961cca':
        colorValue.value = 3;
        mainColor.value = 'Pink';
        colorCircle.value = const Color(0xFF961cca);
        break;
      case '#8c4622':
        colorValue.value = 4;
        mainColor.value = 'Brown';
        colorCircle.value = const Color(0xFF8c4622);
        break;
      case '#6f0fe3':
        colorValue.value = 5;
        mainColor.value = 'Indigo';
        colorCircle.value = const Color(0xFF6f0fe3);
        break;
      case '#F59E0B':
        colorValue.value = 6;
        mainColor.value = 'Amber';
        colorCircle.value = const Color(0xFFF59E0B);
        break;
        
      default:
        colorValue.value = 7;
        break;
    }
  }
//     void resetAll() {
      
//   selectedCircles.clear();
//   questions.clear();
//   selectedAnswers.clear();
//   currentQuestionIndex.value = 0;
//   isSelected.value = List.generate(6, (index) => false);
//   TTSService().stop(); // 🔥 stop any running speech
// }
}
