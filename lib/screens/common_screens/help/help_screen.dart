// views/help_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/doctor_controllers/help_controllers/faq_controller.dart';
import '../../../utils/constants/user_data.dart';
import '../../../utils/helpers/custom_colors.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final FAQController faqController = Get.put(FAQController());

  final UserInfo _userInfo = Get.put(UserInfo());
  bool isDoctor = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final userData = GetStorage('user_data');

    isDoctor = userData.read('isDoctorLogin') ?? false;

    if (userData.read('isDoctorLogin') == null) {
      isDoctor = userData.read('isDoctorLogin') ?? false;

      setState(() {});
    } else {
      isDoctor = userData.read('isDoctorLogin') ?? false;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(_userInfo.getDoctorLogin);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: whiteColor,
        backgroundColor:
            UserInfo().getUserLogin ? primaryColor : doctorPrimaryColor,
      ),
      body: Obx(() {
        if (faqController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (faqController.faqList.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: faqController.faqList.length,
              itemBuilder: (context, index) {
                final faq = faqController.faqList[index];
                return FAQCard(
                  question: faq.question,
                  answer: faq.answer,
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('No FAQs'),
          );
        }
      }),
    );
  }
}

class FAQCard extends StatefulWidget {
  final String question;
  final String answer;

  const FAQCard({super.key, required this.question, required this.answer});

  @override
  // ignore: library_private_types_in_public_api
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.teal,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
