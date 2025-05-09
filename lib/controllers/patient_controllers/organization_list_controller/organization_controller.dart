import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/models/patient_models/organization_doctors_model.dart';
import 'package:ifeelin_color/models/patient_models/organization_model.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class OrganizationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isDoctorsLoading = false.obs;
  Rx<String?> title = Rx<String?>(null); // Nullable Rx<String?>
  Rx<String?> content = Rx<String?>(null); // Nullable Rx<String?>
  OrganizationModel? organizationModel;
  OrganizationDoctorsModel? organizationDoctorsModel;
  Rx<String> error = ''.obs;
  RxList<OrganizationDoctorsData> filteredOrganizationDoctors =
      RxList<OrganizationDoctorsData>();
  RxList<OrganizationsData> filteredOrganizations = RxList<OrganizationsData>();
  var searchOrganizationController = TextEditingController();
  var searchOrganizationDoctorsController = TextEditingController();

  Future<void> fetchOrganizationList() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.allOrganizationListUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        organizationModel = organizationModelFromJson(response.body);
        if (organizationModel?.body != null) {
          filteredOrganizations.assignAll(organizationModel!.body!);
        } else {
          if (kDebugMode) {
            print('No nearby doctors found');
          }
        }
      } else {
        error('error');
        Get.snackbar('Error', 'Failed to load Organizations');
      }
    } catch (e) {
      isLoading.value = false;
      error('error');
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrganizationDoctorsList(String? id) async {
    try {
      isDoctorsLoading.value = true;
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${Constants.getOrganizationDoctorsUrl}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );

      isDoctorsLoading.value = false;
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        organizationDoctorsModel =
            organizationDoctorsModelFromJson(response.body);
        if (organizationDoctorsModel?.body != null) {
          filteredOrganizationDoctors
              .assignAll(organizationDoctorsModel!.body!);
          if (kDebugMode) {
            print(filteredOrganizationDoctors[0]);
          }
        } else {
          if (kDebugMode) {
            print('No nearby doctors found');
          }
        }
      } else {
        isDoctorsLoading.value = false;
        error('error');
        Get.snackbar('Error', 'Failed to Doctors');
      }
    } catch (e) {
      isDoctorsLoading.value = false;

      error('error');
      if (kDebugMode) {
        print('error in $e');
      }
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isDoctorsLoading.value = false;
    }
  }

  Future<void> fetchIndividualDoctorsList() async {
    try {
      isDoctorsLoading.value = true;
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.getIndividualDoctorsUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );

      isDoctorsLoading.value = false;

      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        organizationDoctorsModel =
            organizationDoctorsModelFromJson(response.body);
        if (organizationDoctorsModel?.body != null) {
          filteredOrganizationDoctors
              .assignAll(organizationDoctorsModel!.body!);
          if (kDebugMode) {
            print(filteredOrganizationDoctors[0]);
          }
        } else {
          if (kDebugMode) {
            print('No nearby doctors found');
          }
        }
      } else {
        isDoctorsLoading.value = false;
        error('error');
        Get.snackbar('Error', 'Failed to Doctors');
      }
    } catch (e) {
      isDoctorsLoading.value = false;

      error('error');
      if (kDebugMode) {
        print('error in $e');
      }
      MyToast.showGetToast(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      isDoctorsLoading.value = false;
    }
  }

  void filterOrganizationDoctors(String query) {
    if (query.isEmpty) {
      filteredOrganizationDoctors
          .assignAll(organizationDoctorsModel?.body ?? []);
    } else {
      filteredOrganizationDoctors
          .assignAll(organizationDoctorsModel?.body?.where((doctor) {
                final nameLower = doctor.name?.toLowerCase() ?? '';
                final specializedInLower =
                    doctor.specializedIn?.toLowerCase() ?? '';
                final locationInLower = doctor.location?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();

                return nameLower.contains(queryLower) ||
                    specializedInLower.contains(queryLower) ||
                    locationInLower.contains(queryLower);
              }).toList() ??
              []);
    }
  }

  void filterOrganizations(String query) {
    if (query.isEmpty) {
      filteredOrganizations.assignAll(organizationModel?.body ?? []);
    } else {
      filteredOrganizations
          .assignAll(organizationModel?.body?.where((organization) {
                final nameLower = organization.name?.toLowerCase() ?? '';
                final companyNameInLower =
                    organization.companyName?.toLowerCase() ?? '';
                final locationInLower =
                    organization.address?.toLowerCase() ?? '';
                final queryLower = query.toLowerCase();

                return nameLower.contains(queryLower) ||
                    companyNameInLower.contains(queryLower) ||
                    locationInLower.contains(queryLower);
              }).toList() ??
              []);
    }
  }
}
