import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/doctor_models/doctor_portal_recomendation_model.dart';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:http/http.dart' as http;

class DoctorPortalRecomendationController extends GetxController {
  var selectedCategory = <int, String>{}.obs;
  var items = <int, List<String>>{}.obs;
  Rx<Color> selectedColor = primaryColor.obs;
  Rx<Color> unselectedColor = whiteColor.obs;
  Rx<Color> selectedTextColor = whiteColor.obs;
  Rx<Color> unselectedTextColor = primaryColor.obs;
  DoctorPortalRecomendationsModel? doctorPortalRecomendationsModel;

  var totalportalRecomendations = Rxn<int>();
  var isLoading = true.obs;

  void updateCategory(int index, String category) {
    selectedCategory[index] = category;
    updateItems(index, category);
  }

  Future<void> fetchRecommendations(String? id) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${Constants.doctorPortalRecommendations}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        doctorPortalRecomendationsModel =
            doctorPortalRecomendationsModelFromJson(response.body);
        totalportalRecomendations(
            doctorPortalRecomendationsModel?.body?.length);

        // Initialize categories and items
      } else {
        // Handle error
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateItems([int? index, String? category]) {
    if (index != null && category != null) {
      switch (category) {
        case 'images':
          items[index] = doctorPortalRecomendationsModel
                  ?.body?[index].relatedMedia?.images
                  ?.map((image) => image.url ?? 'No Image URL')
                  .toList() ??
              [];

          break;
        case 'documents':
          items[index] = doctorPortalRecomendationsModel
                  ?.body?[index].relatedMedia?.documents
                  ?.map((doc) => doc.url ?? 'No Document URL')
                  .toList() ??
              [];
          break;
        case 'links':
          items[index] = doctorPortalRecomendationsModel
                  ?.body?[index].relatedMedia?.videos
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
