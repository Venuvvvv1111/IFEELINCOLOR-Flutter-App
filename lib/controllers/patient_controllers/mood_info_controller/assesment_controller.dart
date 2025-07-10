import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/patient_models/Mood_info_models/assesemnt_level2_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:http/http.dart' as http;
import '../../../models/patient_models/Mood_info_models/get_assesment_questions_model.dart';

class AssesmentController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var selectedAnswer = ''.obs;
  var reasons = <String, String>{}.obs;
  var answers = <String, String>{}.obs;
  var isLoading = true.obs;
  var questions = <Body>[].obs;
  Rx<String> colorTitle = ''.obs;
  Rx<String> colorSubtitle = ''.obs;
  Rx<String> colorCategory = ''.obs;
  Rx<String> mainColor = ''.obs;
  Rx<String> moodLevel = ''.obs;
  Rx<int> colorValue = 0.obs;
  Rx<Color> colorCircle = Colors.transparent.obs;
  var level2Questions = <Level2Body>[].obs;
  var level2Answers = <String, String>{}.obs;

  var level2AnswersIds = <String, String>{}.obs;
  var level2selectedAnswer = ''.obs;
  var level2currentQuestionIndex = 0.obs;
  RxBool isLevel2 = false.obs;
  var isLevel2Loading = false.obs;
  RxBool level1Completed = false.obs;
  // TextEditingController for text input
  final textEditingController = TextEditingController();
  RxInt currentStep = 0.obs;
  RxBool isLevel1Completed = false.obs;

  void setLoading(bool value) => isLoading.value = value;

  Future<void> fetchQuestions() async {
    try {
      setLoading(true);
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.assesmentTestQuestions}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      ); // Replace with your API endpoint
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        // Parse response and update questions
        final data = jsonDecode(response.body);
        final GetAssesmentQuestionsModel model =
            GetAssesmentQuestionsModel.fromJson(data);
        setQuestions(model.body ?? []);
      } else {
        Get.snackbar('Error', 'Failed to load questions',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'An error occurred: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red.withValues(alpha: 0.7));
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchLevel2Questions() async {
    try {
      setLoading(true);
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/patients/mood-assessment/66dd4691a4e8cd7938475fe9'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      ); // Replace with your API endpoint
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        // Parse response and update questions
        final data = jsonDecode(response.body);
        final Level2QuestionModel model = Level2QuestionModel.fromJson(data);
        setLevel2Questions(model.body ?? []);
      } else {
        Get.snackbar('Error', 'Failed to load questions',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'An error occurred: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red.withValues(alpha: 0.7));
    } finally {
      setLoading(false);
    }
  }

  Future<void> submitLevel2Answers() async {
    final answersList = level2Questions.map((question) {
      return {
        'questionId': question.sId,
        'optionId': question.answer,
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/patients/mood-assessment'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'answers': answersList}),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Level 2 answers submitted');
        // Navigate to next screen or show results
      } else {
        Get.snackbar('Error', 'Failed to submit level 2 answers');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void setQuestions(List<Body> questionList) {
    questions.value = questionList;
    setLoading(false);
  }

  void setLevel2Questions(List<Level2Body> questionList) {
    level2Questions.value = questionList;
    setLoading(false);
  }

  void updateAnswer(
    String questionId,
    String answer,
  ) {
    answers[questionId] = answer;
  }

  void updateLevel2Answer(String questionId, String selectedOptionText) {
    final question = level2Questions.firstWhere(
      (q) => q.sId == questionId,
      orElse: () => Level2Body(),
    );

    final option = question.answer?.firstWhere(
      (ans) => ans.option == selectedOptionText,
      orElse: () => Answer(),
    );

    if (option?.sId != null) {
      // Store the option text for review purposes
      level2Answers[questionId] = selectedOptionText;
    } else {
      Get.snackbar(
        'Error',
        'Invalid option selected',
        colorText: Colors.white,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
      );
    }
  }

  void _restoreAnswerForCurrentQuestion() {
    var currentQuestion = questions[currentQuestionIndex.value];

    if (currentQuestion.type == 'blanks') {
      textEditingController.text = answers[currentQuestion.sId!] ?? '';
    } else if (currentQuestion.type == 'mcq') {
      selectedAnswer.value = answers[currentQuestion.sId!] ?? '';
    }
  }

  void _level2RestoreAnswerForCurrentQuestion() {
    var currentQuestion = level2Questions[level2currentQuestionIndex.value];

    level2selectedAnswer.value = level2Answers[currentQuestion.sId!] ?? '';
  }

  void nextQuestion(BuildContext context) {
    var currentQuestion = questions[currentQuestionIndex.value];

    if (currentQuestion.type == 'blanks') {
      if (textEditingController.text.isNotEmpty) {
        updateAnswer(currentQuestion.sId!, textEditingController.text);
      } else {
        Get.snackbar('Error', 'Please enter your answer',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
        return;
      }
    } else if (currentQuestion.type == 'mcq') {
      if (selectedAnswer.isNotEmpty) {
        updateAnswer(currentQuestion.sId!, selectedAnswer.value);
      } else {
        Get.snackbar('Error', 'Please select an option',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
        return;
      }
    }

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      _restoreAnswerForCurrentQuestion();
    } else {
      Get.dialog(showResult(context));
    }
  }

  void level2nextQuestion(BuildContext context) {
    var currentQuestion = level2Questions[level2currentQuestionIndex.value];

    if (level2selectedAnswer.isNotEmpty) {
      updateLevel2Answer(currentQuestion.sId!, level2selectedAnswer.value);
    } else {
      Get.snackbar('Error', 'Please select an option',
          colorText: Colors.white,
          backgroundColor: Colors.red.withValues(alpha: 0.7));
      return;
    }

    if (level2currentQuestionIndex.value < level2Questions.length - 1) {
      level2currentQuestionIndex.value++;
      _level2RestoreAnswerForCurrentQuestion();
    } else {
      Get.dialog(level2ShowResult(context));
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      _restoreAnswerForCurrentQuestion();
    }
  }

  void level2PreviousQuestion() {
    if (level2currentQuestionIndex.value > 0) {
      level2currentQuestionIndex.value--;
      _level2RestoreAnswerForCurrentQuestion();
    }
  }

  AlertDialog showResult(context) {
    return AlertDialog(
      title: const Text('Review Answers'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: questions.map((question) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Question ID: ${question.sId}'),
                Text(
                  'Question: ${question.question}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Answer: ${answers[question.sId] ?? ''}'),
                // Text('Reason: ${reasons[question.sId] ?? 'N/A'}'),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Post answers to the API
            Navigator.pop(context);
          },
          child: Text(
            'Review',
            style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
          ),
        ),
        TextButton(
          onPressed: () {
            // Post answers to the API
            postAnswers(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  AlertDialog level2ShowResult(context) {
    return AlertDialog(
      title: const Text('Review Answers'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: level2Questions.map((question) {
            String selectedAnswerText = level2Answers[question.sId!] ?? 'Not Answered';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Question ID: ${question.sId}'),
                Text(
                  'Question: ${question.question}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Answer: $selectedAnswerText'),
                // Text('Reason: ${reasons[question.sId] ?? 'N/A'}'),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Post answers to the API
            Navigator.pop(context);
          },
          child: Text(
            'Review',
            style: TextStyle(color: Colors.grey.withValues(alpha: 0.8)),
          ),
        ),
        TextButton(
          onPressed: () {
            // Post answers to the API
            level2PostAnswers(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> level2PostAnswers(context) async {
    var answersForSubmission = <Map<String, String>>[];

    level2Answers.forEach((questionId, selectedOptionText) {
      final question = level2Questions.firstWhere(
        (q) => q.sId == questionId,
        orElse: () => Level2Body(),
      );

      final option = question.answer?.firstWhere(
        (ans) => ans.option == selectedOptionText,
        orElse: () => Answer(),
      );

      if (option?.sId != null) {
        // Add the answer to the list in the required format
        answersForSubmission.add({
          'questionId': questionId,
          'optionId': option!.sId!,
        });
      }
    });

    if (kDebugMode) {
      print(answersForSubmission);
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.level2Assesmentsubmit}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
        body: jsonEncode({'answers': answersForSubmission}),
      );
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);

        UserInfo userinfo = Get.put(UserInfo());

        userinfo.addAssesment = true;
        userinfo.addBodyAssesment = false;
        userinfo.refreshData();
        Get.snackbar('Success', 'Answers submitted successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green.withValues(alpha: 0.7));

        moodLevel.value = json['body']?['moodLevel'] ?? '';
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Get.snackbar('Error', 'Failed to submit answers',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'An error occurred: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red.withValues(alpha: 0.7));
    } finally {}
  }

  Future<void> postAnswers(context) async {
    final List<Map<String, String>> answerList = answers.entries.map((entry) {
      return {
        'questionId': entry.key,
        'answer': entry.value,
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.assesmentsubmit}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'answers': answerList}),
      );
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // if (json['body']['mood'] != null) {
        UserInfo userinfo = Get.put(UserInfo());

        // userinfo.addAssesment = true;
        // userinfo.addBodyAssesment = false;
        userinfo.refreshData();
        Get.snackbar('Success', 'Level 1 Completed Successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green.withValues(alpha: 0.7));

        colorTitle.value = json['body']?['mood']?['hexColor'] ?? '';
        updateColorValue();
        colorSubtitle.value = json['body']?['mood']?['description'] ?? '';
        colorCategory.value = json['body']?['mood']?['mood'] ?? '';
        isLevel1Completed.value = true;
        Navigator.pop(context);
        fetchLevel2Questions();
        currentStep.value = 1;

        // Navigator.pop(context);
        // } else {
        //   Get.snackbar('Error', 'please check your answers',
        //       colorText: Colors.white,
        //       backgroundColor: Colors.red.withValues(alpha:0.7));
        // }
      } else {
        Get.snackbar('Error', 'Failed to submit answers',
            colorText: Colors.white,
            backgroundColor: Colors.red.withValues(alpha: 0.7));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'An error occurred: $e',
          colorText: Colors.white,
          backgroundColor: Colors.red.withValues(alpha: 0.7));
    } finally {}
  }

  void updateColorValue() {
    if (kDebugMode) {
      print(colorTitle.value);
    }
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
      default:
        colorValue.value = 6;
        break;
    }
  }

  @override
  void onClose() {
    // questions.clear();
    // answers.clear();
    // textEditingController.clear();
    currentQuestionIndex.value = 0;
    level2currentQuestionIndex.value = 0;
    // Dispose of the TextEditingController when the controller is disposed
    textEditingController.dispose();

    super.onClose();
  }
}
