import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/two_d_model_controller.dart';

import 'package:ifeelin_color/models/patient_models/Mood_info_models/nested_question_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class QA {
  String? question;
  String? answerKey;
  String? answerLabel;

  QA({this.question, this.answerKey, this.answerLabel});

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer_key": answerKey,
      "answer_label": answerLabel,
    };
  }
}

class QuestionController extends GetxController {
  var isLoading = false.obs;

  QuestionNode? rootQuestion;
  var currentQuestion = Rxn<QuestionNode>();

  /// Selected option for current step
  var selectedOption = Rxn<QuestionNode>();

  /// Navigation stack
  List<QuestionNode> history = [];

  /// Answers list
  var answers = <QA>[].obs;

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  // ✅ FETCH API
  void fetchQuestions() async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse('https://feelincolor.projexino.com/api/questions-by-parts'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
        body: json.encode({"partIds": ["Happy", "sad"]}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = QuestionResponse.fromJson(json);

        if (data.body != null && data.body!.isNotEmpty) {
          rootQuestion = data.body!.first;
          currentQuestion.value = rootQuestion;
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ SELECT OPTION (ONLY SELECT)
  void selectOption(QuestionNode option) {
    selectedOption.value = option;
  }

  // ✅ NEXT BUTTON
  void goNext(context) {
  final option = selectedOption.value;
  if (option == null) return;

  final stepIndex = history.length;

  final newAnswer = QA(
    question: currentQuestion.value?.question,
    answerKey: option.key,
    answerLabel: option.label,
  );

  // ✅ UPDATE instead of always ADD
  if (answers.length > stepIndex) {
    answers[stepIndex] = newAnswer;
  } else {
    answers.add(newAnswer);
  }

  // Navigate or submit
  if (option.options != null && option.options!.isNotEmpty) {
    if (history.length > stepIndex) {
      history[stepIndex] = option;
    } else {
      history.add(option);
    }

    currentQuestion.value = option;
    selectedOption.value = null;
  } else {
    submitAnswers(context);
  }
}

  // ✅ SUBMIT API
  void submitAnswers(context) async {
    try {
     isLoading(true);
     final userInfo = Get.find<UserInfo>();
    final payload = {
      "answers": answers.map((e) => {
            "key": e.answerKey,
            "answer": e.answerLabel,
          }).toList(),
    };

    print("FINAL PAYLOAD: ${jsonEncode(payload)}");

    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/${Constants.submitFeelingAnsers}/${userInfo.getPatientId}"), // ⚠️ fix double //
      headers: {
        'Content-Type': 'application/json',
        // 'authorization': 'Bearer ${UserInfo().getUserToken}'
      },
      body: jsonEncode(payload),
    );

    print("Submit Response: ${response.body}");

  Get.snackbar('Success', 'Answers submitted successfully',
            colorText: Colors.white,
            backgroundColor: Colors.green.withValues(alpha: 0.7));

        // Handle success, show result, etc.
        if (kDebugMode) {
          print("Answers submitted successfully");
        }
             final TwoDModelController twoDcontroller = Get.put(TwoDModelController());
          twoDcontroller.getFinalResult(context);
        Navigator.pop(context);
      Get.back();
     
        
      if(Navigator.canPop(context)){
  Navigator.pop(context);
      }
    } catch (e) {
      print("Submit Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ BACK BUTTON (FIXED WITH SELECTION RESTORE)
 void goBack() {
  if (history.isNotEmpty) {
    history.removeLast();

    if (history.isEmpty) {
      currentQuestion.value = rootQuestion;
    } else {
      currentQuestion.value = history.last;
    }

    final stepIndex = history.length;

    // ✅ Restore correct selection for that step
    if (answers.length > stepIndex) {
      final prevAnswer = answers[stepIndex];

      final options = currentQuestion.value?.options ?? [];

      selectedOption.value = options.firstWhereOrNull(
        (opt) => opt.key == prevAnswer.answerKey,
      );
    } else {
      selectedOption.value = null;
    }
  }
}
}