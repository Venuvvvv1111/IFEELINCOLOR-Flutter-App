import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelin_color/models/patient_models/recomendation_models/cliniciest_recomendation_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:http/http.dart' as http;

class ClinicistRecomendationController extends GetxController {
  var selectedCategory = <int, String>{}.obs;
  var items = <int, List<String>>{}.obs;
  Rx<Color> selectedColor = primaryColor.obs;
  Rx<Color> unselectedColor = whiteColor.obs;
  Rx<Color> selectedTextColor = whiteColor.obs;
  Rx<Color> unselectedTextColor = primaryColor.obs;
  DoctorRecomendationsModel? doctorRecomendationsModel;

  var totaldoctorRecomendations = Rxn<int>().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchRecommendations();
    super.onInit();
  }

  void updateCategory(int index, String category) {
    selectedCategory[index] = category;
    updateItems(index, category);
  }

  Future<void> fetchRecommendations() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.doctorRecommendations}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      isLoading.value = false;
      if (kDebugMode) {
        print("venu doctorRecommendations ${response.body}");
      }
      if (response.statusCode == 200) {
        doctorRecomendationsModel =
            doctorRecomendationsModelFromJson(response.body);
        totaldoctorRecomendations
            .value(doctorRecomendationsModel?.body?.length);

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
          items[index] = doctorRecomendationsModel
                  ?.body?[index].relatedMedia?.images
                  ?.map((image) => image.url ?? 'No Image URL')
                  .toList() ??
              [];
          break;
        case 'documents':
          items[index] = doctorRecomendationsModel
                  ?.body?[index].relatedMedia?.documents
                  ?.map((doc) => doc.url ?? 'No Document URL')
                  .toList() ??
              [];

          break;
        case 'links':
          items[index] = doctorRecomendationsModel
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
