// controllers/faq_controller.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/doctor_models/faq_model.dart';
import '../../../utils/constants/string_constants.dart';
import '../../../utils/constants/user_data.dart';

class FAQController extends GetxController {
  var faqList = <FAQModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFAQs();
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<FAQController>();
  }

  Future<void> fetchFAQs() async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.faqURL}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['body'] as List;
        if (kDebugMode) {
          print(data);
        }
        faqList.value = data.map((json) => FAQModel.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to load FAQs: $e");
      }
    } finally {
      isLoading(false);
    }
  }
}
