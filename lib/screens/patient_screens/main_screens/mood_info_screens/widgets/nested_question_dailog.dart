import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/nested_questions_controller.dart';

class QuestionDialog extends StatefulWidget {
  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final controller = Get.put(QuestionController());

  Color getColor(String? hex) {
    if (hex == null) return Colors.green;
    return Color(int.parse(hex.replaceAll('#', '0xff')));
  }

  @override
  void initState() {
    super.initState();
    controller.fetchQuestions();
    
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final question = controller.currentQuestion.value;
        if (question == null) return const SizedBox();

        return Container(
          constraints: const BoxConstraints(maxHeight: 520),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// QUESTION
              Text(
                question.question ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// OPTIONS
              Expanded(
                child: ListView.builder(
                  itemCount: question.options?.length ?? 0,
                  itemBuilder: (context, index) {
                    final option = question.options![index];

                    final isSelected =
                        controller.selectedOption.value?.key == option.key;

                    return GestureDetector(
                      onTap: () {
                        controller.selectOption(option);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? getColor(option.hexCode?.inner)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? getColor(option.hexCode?.inner)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          option.label ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              /// ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// BACK
                  if (controller.history.isNotEmpty)
                    TextButton(
                      onPressed: controller.goBack,
                      child: const Text("Back"),
                    )
                  else
                    const SizedBox(),

                  /// NEXT / SUBMIT
                  ElevatedButton(
                    onPressed: () {
                      controller.selectedOption.value == null
                          ? null
                          : controller.goNext(context);
                    },
                    child: Text(
                      (controller.selectedOption.value?.options != null &&
                              controller.selectedOption.value!.options!.isNotEmpty)
                          ? "Next"
                          : "Submit",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}