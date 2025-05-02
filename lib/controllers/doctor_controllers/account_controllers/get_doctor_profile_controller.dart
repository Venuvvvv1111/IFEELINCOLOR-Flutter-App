import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/doctor_models/doctor_profile_model.dart';

import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import 'package:http/http.dart' as http;

class GetDoctorProfileController extends GetxController {
  GetDoctorProfileModel? getProfileModel;
  var selectedIndex = 0.obs;
  DateTime? start;
  DateTime? end;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> existingExperiences =
      <Map<String, dynamic>>[].obs;

  //profile data
  var emailEditController = TextEditingController().obs;
  var addressEditController = TextEditingController().obs;
  var nameEditController = TextEditingController().obs;
  var mobileEditController = TextEditingController().obs;
  var dobEditController = TextEditingController().obs;
  var dobDisplayController = TextEditingController().obs;
  RxString updatedLatitude = ''.obs;
  RxString updatedLongitude = ''.obs;
  RxString userDob = ''.obs;

  RxString? profileImage = ''.obs;
  final emailEditFocusNode = FocusNode();
  final addressEditFocusNode = FocusNode();

  final nameEditFocusNode = FocusNode();
  final mobileEditFocusNode = FocusNode();
  final dobEditFocusNode = FocusNode();

  var isChecked1 = false.obs;
//experince data
  var currentRoleEditController = TextEditingController().obs;
  var spetialityEditController = TextEditingController().obs;
  var oreganizationEditController = TextEditingController().obs;
  var aboutEditController = TextEditingController().obs;

  //spetiality

  @override
  void onInit() {
    fetchGetProfile();

    //
    super.onInit();
  }

  @override
  void onClose() {
    emailEditController.value.dispose();

    nameEditController.value.dispose();
    mobileEditController.value.dispose();

    emailEditFocusNode.dispose();

    nameEditFocusNode.dispose();
    mobileEditFocusNode.dispose();
    dobEditFocusNode.dispose();
    super.onClose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide a valid email";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? validateMobile(String value) {
    if (!GetUtils.isPhoneNumber(value)) {
      return "Provide a valid mobile number";
    }
    return null;
  }

  String? validateDob(String value) {
    if (value.isEmpty) {
      return "Date of Birth cannot be empty";
    }
    return null;
  }

  String? validateGuardianName(String value) {
    if (value.isEmpty) {
      return 'Guardian Name is required';
    }
    return null;
  }

  void onTermsAndConditionsChanged(bool? value) {
    isChecked1.value = value ?? false;
  }

  Future<void> updateProfile(context) async {
    try {
      isLoading(true);
      LoaderHelper.showLoader(context);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
      }

      // String inputDate = "${dobDisplayController.text}";
      // print(inputDate);
      // inputDate = inputDate.replaceAll(RegExp(r'(st|nd|rd|th)'), '');

      // DateFormat inputFormat = DateFormat("d MMM yyyy");

      // DateTime dateTime = inputFormat.parse(inputDate.trim());

      // DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      // String formattedDate = outputFormat.format(dateTime);

      // print(formattedDate);

      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.updateDoctorPrifileURL}');
      }
      Map<String, dynamic> newExperience = {
        "name": currentRoleEditController.value.text,
        "startDate": start?.toIso8601String(), // ISO-8601 format
        "endDate": end?.toIso8601String(), // ISO-8601 format
        "description": aboutEditController.value.text,
        "specialty": spetialityEditController.value.text,
        "organizationName": oreganizationEditController.value.text,
      };

// Check if the newExperience has any meaningful data
      bool isNewExperienceValid = newExperience.values
          .any((value) => value != null && value.isNotEmpty);

      List<Map<String, dynamic>> combinedExperiences = [
        ...existingExperiences,
        if (isNewExperienceValid) newExperience
      ];
      if (kDebugMode) {
        print(combinedExperiences);
      }
      Map<String, dynamic> payload = {
        "name": nameEditController.value.text,
        "email": emailEditController.value.text,
        "mobileNum": mobileEditController.value.text,
        "dob": dobEditController.value.text,
        "location": addressEditController.value.text,
        if (updatedLatitude.value.isNotEmpty)
          "address": {
            "latitude": updatedLatitude.value,
            "longitude": updatedLongitude.value
          },
        if (combinedExperiences.isNotEmpty) "careerpath": combinedExperiences,
      };
      final res = await http.put(
        Uri.parse('${Constants.baseUrl}/${Constants.updateDoctorPrifileURL}'),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      LoaderHelper.hideLoader(context);
      isLoading(false);
      if (kDebugMode) {
        print(res.statusCode);
        print(res.body);
      }

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        getProfileModel = getDoctorProfileModelFromJson(res.body);
        emailEditController.value.text = json['body']['email'] ?? '';

        nameEditController.value.text = json['body']['name'] ?? '';
        mobileEditController.value.text = json['body']['mobileNum'];

        dobEditController.value.text = json['body']['dob'] ?? '';
        dobDisplayController.value.text = json['body']['dob'] ?? '';

        profileImage?.value = json['body']['image'] ?? '';

        UserInfo().addUserName = json['body']['name'] ?? '';
        UserInfo().addUserEmail = json['body']['email'] ?? "";
        UserInfo().addUserMobileNumber = json['body']['mobileNum'] ?? "";
        UserInfo().addUserProfileUrl = json['body']['image'] ?? "";
        UserInfo().addUserAdress = json['body']['location'] ?? "";
        UserInfo().addUserLatitude = "${json['body']['address']['latitude']}";
        UserInfo().addUserLatitude = "${json['body']['address']['longitude']}";

        update();
        if (kDebugMode) {
          print('profile edit screen');
          print(UserInfo().getUserName);
        }

        // fetchGetProfile();
        MyToast.showGetToast(
            title: "Success",
            message: "updated successfully!",
            backgroundColor: Colors.green,
            color: Colors.white);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.doctorMainTabsScreen, (route) => false);

        if (kDebugMode) {
          print(json);
        }
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
        if (kDebugMode) {
          print(res.body);
        }
        MyToast.showGetToast(
            title: "Error",
            message: res.reasonPhrase.toString(),
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      isLoading(false);
      if (kDebugMode) {
        print(e);
      }
    }

    // Perform registration logic
  }

  Future<void> fetchGetProfile() async {
    try {
      isLoading(true);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
      }

      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.getProfile}');
      }
      final res = await http.get(
        Uri.parse(
            '${Constants.baseUrl.trim()}/${Constants.getDoctorProfileURL.trim()}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      isLoading(false);
      if (kDebugMode) {
        print(res.statusCode);
      }
      if (kDebugMode) {
        print(res.body);
      }

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (kDebugMode) {
          print(json);
        }
        getProfileModel = getDoctorProfileModelFromJson(res.body);
        emailEditController.value.text = json['body']['email'] ?? '';
        nameEditController.value.text = json['body']['name'] ?? '';
        mobileEditController.value.text = json['body']['mobileNum'] ?? '';

        dobEditController.value.text = json['body']['dob'] ?? '';
        // dobDisplayController.text = json['body']['dateOfBirth'] ?? '';
        addressEditController.value.text = json['body']['location'] ?? '';
        dobDisplayController.value.text = MediaQueryUtil.formatDateWithSuffix(
            DateTime.parse(json['body']['dob']));
        profileImage?.value = json['body']['image'] ?? '';
        UserInfo().addUserProfileUrl = json['body']['image'] ?? '';
        existingExperiences.value =
            List<Map<String, dynamic>>.from(json['body']['careerpath'] ?? []);

        // Navigator.pushNamed(context, AppRoutes.mainScreenTabs);
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      isLoading(false);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> uploadImage(context, File? image) async {
    if (image == null) {
      MyToast.showGetToast(
          title: 'Error',
          message: "No image selected.",
          color: whiteColor,
          backgroundColor: Colors.red);
      return;
    }
    try {
      LoaderHelper.showLoader(context);
      var url =
          '${Constants.baseUrl}/${Constants.updateDoctorProfileImage}/${UserInfo().getPatientId}';
      if (kDebugMode) {
        print('Upload URL: $url');
      }
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
          '${Constants.baseUrl}/${Constants.updateDoctorProfileImage}/${UserInfo().getPatientId}',
        ),
      );
      request.headers['authorization'] = 'Bearer ${UserInfo().getUserToken}';

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      LoaderHelper.hideLoader(context);
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        UserInfo().addUserProfileUrl = json['body']['imageUrl'];
        // Fetch the updated profile to get the new image URL
        await fetchGetProfile();
        MyToast.showGetToast(
            title: "Success",
            message: "Profile image updated successfully!",
            backgroundColor: Colors.green,
            color: Colors.white);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: "Failed to upload the image. Please try again.",
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      MyToast.showGetToast(
          title: "Error",
          message: "An error occurred while uploading the image.",
          backgroundColor: Colors.red,
          color: Colors.white);
    }
  }
}
