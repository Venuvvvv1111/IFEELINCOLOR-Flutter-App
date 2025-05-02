// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

// class PortalRecomendationController extends GetxController {
//   var selectedCategory = <int, String>{}.obs;
//   var items = <int, List<String>>{}.obs;
//   Rx<Color> selectedColor = primaryColor.obs;
//   Rx<Color> unselectedColor = whiteColor.obs;
//   Rx<Color> selectedTextColor = whiteColor.obs;
//   Rx<Color> unselectedTextColor = primaryColor.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     for (int i = 0; i < 7; i++) {
//       items[i] = <String>[];
//       // selectedCategory[i] = '';
//     }
//   }

//   void updateCategory(int index, String category) {
//     selectedCategory[index] = category;
//     updateItems(index, category);
//   }

//   void updateItems([int? index, String? category]) {
//     if (index != null && category != null) {
//       switch (category) {
//         case 'images':
//           items[index] =
//               ['Image1', 'Image2', 'Image3', 'Image4', 'Image5', 'Image6'].obs;
//           break;
//         case 'documents':
//           items[index] = ['Doc1', 'Doc2', 'Doc3'].obs;
//           break;
//         case 'links':
//           items[index] = ['Link1', 'Link2', 'Link3'].obs;
//           break;
//         default:
//           items[index] = <String>[];
//       }
//     }
//   }
// }
