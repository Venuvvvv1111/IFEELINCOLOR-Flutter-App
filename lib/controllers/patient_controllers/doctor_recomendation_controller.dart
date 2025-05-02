// import 'package:get/get.dart';
// import 'package:ifeelin_color/models/patientModels/doctor_recomendation_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:ifeelin_color/utils/constants/StringConstants.dart';
// import 'package:ifeelin_color/utils/constants/user_data.dart';

// class DoctorRecomendationController extends GetxController {
//   var recommendations = <Body>[].obs;
//   var isLoading = true.obs;
//   var selectedCategory = <String?>[].obs;
//   var items = <List<String>>[].obs;

//   @override
//   void onInit() {
//     fetchRecommendations();
//     super.onInit();
//   }

//   Future<void> fetchRecommendations() async {
//     try {
//       final response = await http.get(
//         Uri.parse('${Constants.baseUrl}/rec/doctor_recommendations/stress'),
//         headers: {
//           'Content-Type': 'application/json',
//           'authorization': 'Bearer ${UserInfo().getUserToken}'
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = doctorRecomendationsModelFromJson(response.body);
//         recommendations.value = data.body ?? [];
//         isLoading.value = false;
//         // Initialize categories and items
//         selectedCategory.value =
//             List.generate(recommendations.length, (index) => null);
//         items.value = List.generate(recommendations.length, (index) => []);
//       } else {
//         // Handle error
//         isLoading.value = false;
//       }
//     } catch (e) {
//       // Handle error
//       isLoading.value = false;
//     }
//   }

//   void updateCategory(int index, String category) {
//     if (index < selectedCategory.length) {
//       selectedCategory[index] = category;
//       // Update items based on the selected category
//     }
//   }
// }
