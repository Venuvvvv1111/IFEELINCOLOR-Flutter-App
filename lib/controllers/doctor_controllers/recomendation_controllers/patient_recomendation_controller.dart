import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/doctor_models/pateints_recomendations_model.dart';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:http/http.dart' as http;

class PatientRecomendationController extends GetxController {
  var selectedCategory = <int, String>{}.obs;
  var items = <int, List<String>>{}.obs;
  Rx<Color> selectedColor = primaryColor.obs;
  Rx<Color> unselectedColor = whiteColor.obs;
  Rx<Color> selectedTextColor = whiteColor.obs;
  Rx<Color> unselectedTextColor = primaryColor.obs;
  PatientsRecomendationsModel? patientsRecomendationsModel;

  var totalPatientRecomendations = Rxn<int>();
  var isLoading = true.obs;

  void updateCategory(int index, String category) {
    selectedCategory[index] = category;
    updateItems(index, category);
  }

  // void updateItems([int? index, String? category]) {
  //   if (index != null && category != null) {
  //     switch (category) {
  //       case 'images':
  //         items[index] =
  //             ['Image1', 'Image2', 'Image3', 'Image4', 'Image5', 'Image6'].obs;
  //         break;
  //       case 'documents':
  //         items[index] = ['Doc1', 'Doc2', 'Doc3'].obs;
  //         break;
  //       case 'links':
  //         items[index] = ['Link1', 'Link2', 'Link3'].obs;
  //         break;
  //       default:
  //         items[index] = <String>[];
  //     }
  //   }
  // }

  Future<void> fetchRecommendations(String? id) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${Constants.patientRecommendations}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );

      isLoading.value = false;
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        patientsRecomendationsModel =
            patientsRecomendationsModelFromJson(response.body);
        totalPatientRecomendations(patientsRecomendationsModel?.body?.length);

        // Initialize categories and items
      } else {
        totalPatientRecomendations(0);
        // Handle error
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Handle error
      // if (kDebugMode) {

      totalPatientRecomendations(0);

      // }
    } finally {
      isLoading.value = false;
    }
  }

  void updateItems([int? index, String? category]) {
    if (index != null && category != null) {
      switch (category) {
        case 'images':
          items[index] = patientsRecomendationsModel
                  ?.body?[index].relatedMedia?.images
                  ?.map((image) => image.url ?? 'No Image URL')
                  .toList() ??
              [];
          break;
        case 'documents':
          items[index] = patientsRecomendationsModel
                  ?.body?[index].relatedMedia?.documents
                  ?.map((doc) => doc.url ?? 'No Document URL')
                  .toList() ??
              [];

          break;
        case 'links':
          items[index] = patientsRecomendationsModel
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
