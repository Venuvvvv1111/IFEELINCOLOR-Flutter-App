import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/doctor_models/my_recomendation_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class MyRecommendedPatientsController extends GetxController {
  var isLoading = true.obs;
  var recommendedPatients = <MyRecomendations>[].obs;
  var filteredPatients = <MyRecomendations>[].obs;
  var searchController = TextEditingController();
  var selectedCategory = <int, String>{}.obs;
  var items = <int, List<String>>{}.obs;
  Rx<Color> selectedColor = doctorPrimaryColor.obs;
  Rx<Color> unselectedColor = whiteColor.obs;
  Rx<Color> selectedTextColor = whiteColor.obs;
  Rx<Color> unselectedTextColor = doctorPrimaryColor.obs;
  @override
  void onInit() {
    fetchRecommendedPatients();
    searchController.addListener(filterPatients);
    super.onInit();
  }

  void fetchRecommendedPatients() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.allRecomendedPatientsURL}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      if (response.statusCode == 200) {
        var data = myRecomendedPatientsModelFromJson(response.body);
        if (data.body != null) {
          recommendedPatients.value = data.body!;
          filteredPatients.value = data.body!;
        }
      } else {
        if (kDebugMode) {
          print("Failed to load recommended patients");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching recommended patients: $e");
      }
    } finally {
      isLoading(false);
    }
  }

  void filterPatients() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredPatients.value =
          recommendedPatients; // Show all if search is empty
    } else {
      filteredPatients.value = recommendedPatients
          .where((patient) =>
              patient.patient?.userName?.toLowerCase().contains(query) ?? false)
          .toList();
    }
  }

  void updateCategory(int index, String category) {
    selectedCategory[index] = category;
    updateItems(index, category);
  }

  void updateItems([int? index, String? category]) {
    if (index != null && category != null) {
      switch (category) {
        case 'images':
          items[index] = filteredPatients[index]
                  .recommendations![0]
                  .relatedMedia
                  ?.images
                  ?.map((image) => image.url ?? 'No Image URL')
                  .toList() ??
              [];

          break;
        case 'documents':
          items[index] = filteredPatients[index]
                  .recommendations![0]
                  .relatedMedia
                  ?.documents
                  ?.map((doc) => doc.url ?? 'No Document URL')
                  .toList() ??
              [];
          break;
        case 'links':
          items[index] = filteredPatients[index]
                  .recommendations![0]
                  .relatedMedia
                  ?.videos
                  ?.map((video) => video.url ?? 'No Video URL')
                  .toList() ??
              [];
          break;
        default:
          items[index] = <String>[];
      }
    }
  }
}
