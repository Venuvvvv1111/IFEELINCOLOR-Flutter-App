import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/widgets/nested_question_dailog.dart';

class FeelingDialog extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
  {
    'key': 'happy',
    'emoji': '😊',
    'title': 'Happy',
    'color': const Color(0xFFFFD700),
  },
  {
    'key': 'sad',
    'emoji': '😢',
    'title': 'Sad',
    'color': const Color(0xFF1E90FF),
  },
  {
    'key': 'disgusted',
    'emoji': '🤢',
    'title': 'Disgusted',
    'color': const Color(0xFF808080),
  },
  {
    'key': 'angry',
    'emoji': '😡',
    'title': 'Angry',
    'color': const Color(0xFFFF0000),
  },
  {
    'key': 'fear',
    'emoji': '😨',
    'title': 'Fearful',
    'color': const Color(0xFFFF8C00),
  },
  {
    'key': 'bad',
    'emoji': '😖',
    'title': 'Bad',
    'color': const Color(0xFF00A36C),
  },
  {
    'key': 'surprise',
    'emoji': '😲',
    'title': 'Surprised',
    'color': const Color(0xFF8A2BE2),
  },
];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How are you feeling?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            /// 🔥 Better UI instead of ListTile
            ...items.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  Get.dialog(
                    QuestionDialog(partId: item["key"]),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: item['color']),
                  ),
                  child: Row(
                    children: [
                      Text(
                        item['emoji'],
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
