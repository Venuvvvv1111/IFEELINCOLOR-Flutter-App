import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/doctor_models/intake_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class IntakeDetailsController extends GetxController {
  var patientInfo = Rxn<IntakeDetailsModel>();
  var assessmentInfos = <AssessmentInfo>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  Future<void> fetchPatientData(String patientId) async {
    try {
      isLoading.value = true;
      String url =
          '${Constants.baseUrl}/${Constants.intakeDetailsUrl}/$patientId';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${UserInfo().getUserToken}'
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      final json = jsonDecode(response.body);
      if (kDebugMode) {
        print(json);
      }
      isLoading.value = false;
      if (response.statusCode == 200 && json['status'] == 'success') {
        final data = json['data'];
        patientInfo.value = IntakeDetailsModel.fromJson(data['patientInfo']);
        assessmentInfos.value = (data['assessmentInfos'] as List)
            .map((item) => AssessmentInfo.fromJson(item))
            .toList();
      } else {
        error.value = 'error';
        MyToast.showGetToast(
            title: 'Error', message: 'Failed to fetch assesment');
      }
    } catch (e) {
      error.value = 'error';
      isLoading.value = false;
      MyToast.showGetToast(title: 'Error', message: e.toString());
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
