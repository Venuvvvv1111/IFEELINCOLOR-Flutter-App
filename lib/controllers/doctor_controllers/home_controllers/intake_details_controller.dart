// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:ifeelin_color/utils/constants/my_toast.dart';
// import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
// import '../../../utils/constants/StringConstants.dart';
// import '../../../utils/constants/user_data.dart';

// class PatientIntakeController extends GetxController {
//   // Existing properties
//   final patientData = {}.obs;
//   final subscriptionData = {}.obs;
//   final assessmentData = {}.obs;
//   final treatmentHistory = [].obs;
//   final socialInformation = [].obs;
//   final medicalHistory = [].obs;
//   final RxBool isLoading = false.obs;

//   // New currentStep property for stepper
//   var currentStep = 0.obs;

//   Future<void> fetchPatientIntakeDetails(String? patientId) async {
//     try {
//       isLoading.value = true;
//       final response = await http.get(
//         Uri.parse(
//             '${Constants.baseUrl}/${Constants.intakeDetailsURL}/${patientId}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'authorization': 'Bearer ${UserInfo().getUserToken}',
//         },
//       );
//       isLoading.value = false;
//       print('${Constants.baseUrl}/${Constants.intakeDetailsURL}/${patientId}');
//       print(response.body);
//       final responseBody = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         if (responseBody['status'] == 'success') {
//           final data = responseBody['data'];
//           patientData.value = data['patientInfo'];
//           subscriptionData.value = data['patientInfo']['subscription'] ?? {};
//           assessmentData.value = data['assessmentInfos'].isNotEmpty
//               ? data['assessmentInfos'].last
//               : {};
//           treatmentHistory
//               .assignAll(data['patientInfo']['treatmentHistory'] ?? []);
//           socialInformation
//               .assignAll(data['patientInfo']['socialInformation'] ?? []);
//           medicalHistory.assignAll(data['patientInfo']['medicalHistory'] ?? []);
//         } else {
//           MyToast.showGetToast(
//               title: 'Error',
//               message:
//                   responseBody['message'] ?? "Failed to fetch patient details.",
//               backgroundColor: Colors.red,
//               color: whiteColor);
//         }
//       } else {
//         MyToast.showGetToast(
//             title: 'Error',
//             message: responseBody['message'],
//             backgroundColor: Colors.red,
//             color: whiteColor);
//       }
//     } catch (e) {
//       isLoading.value = false;
//       MyToast.showGetToast(
//           title: 'Error',
//           message: "Could not fetch data: $e",
//           backgroundColor: Colors.red,
//           color: whiteColor);
//     }
//   }
// }
