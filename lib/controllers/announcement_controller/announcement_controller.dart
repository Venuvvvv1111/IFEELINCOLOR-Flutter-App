import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ifeelin_color/models/announcement_models/announcement_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';

class AnnouncementController extends GetxController {
  var announcements = <Announcement>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();

    fetchAnnouncements(); // Fetch announcements when the controller is initialized
  }

  // Fetch announcement data from API
  void fetchAnnouncements() async {
    try {
      isLoading.value = true;
      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.announcementUrl}');
      }

      var response = await http
          .get(Uri.parse('${Constants.baseUrl}/${Constants.announcementUrl}'));

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          announcements.value = (data['body'] as List)
              .map((item) => Announcement.fromJson(item))
              .toList();
        } else {
          Get.snackbar("Error", "Failed to load announcements");
        }
      } else {
        // Handle other response codes
        Get.snackbar("Error", "Failed to load data");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading image URLs: $e');
      }
    } finally {
      // Set loading to false once the data is fetched
      isLoading.value = false;
    }
  }
}
