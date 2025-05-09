import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/models/patient_models/get_profile_model.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../utils/constants/string_constants.dart';
import '../../utils/constants/my_toast.dart';
import '../../utils/constants/user_data.dart';
import 'package:http/http.dart' as http;

class GetProfileController extends GetxController {
  GetProfileModel? getProfileModel;
  var selectedIndex = 0.obs;

  RxBool isLoading = false.obs;
  var emailEditController = TextEditingController().obs;
  var addressEditController = TextEditingController().obs;
  var nameEditController = TextEditingController().obs;
  var mobileEditController = TextEditingController().obs;
  var dobEditController = TextEditingController().obs;
  var dobDisplayController = TextEditingController();
  RxString userDob = ''.obs;
  RxString updatedLatitude = ''.obs;
  RxString updatedLongitude = ''.obs;
  var guardianNameEditController = TextEditingController().obs;
  RxString? profileImage = ''.obs;
  final emailEditFocusNode = FocusNode();
  final addressEditFocusNode = FocusNode();

  final nameEditFocusNode = FocusNode();
  final mobileEditFocusNode = FocusNode();
  final dobEditFocusNode = FocusNode();
  final guardianNameEditFocusNode = FocusNode();

  var isGuardianFieldVisible = false.obs;
  var isChecked1 = false.obs;

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
    if (!RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value)) {
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

  void calculateAge(DateTime dob) {
    final currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    isGuardianFieldVisible.value = age < 18;
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
    if (validateName(nameEditController.value.text) != null) {
      MyToast.showGetToast(
          title: 'Error',
          message: validateName(nameEditController.value.text)!,
          color: whiteColor,
          backgroundColor: Colors.red);

      return;
    }
    if (validateEmail(emailEditController.value.text) != null) {
      MyToast.showGetToast(
          title: 'Error',
          message: validateEmail(emailEditController.value.text)!,
          color: whiteColor,
          backgroundColor: Colors.red);

      return;
    }
    if (validateMobile(mobileEditController.value.text) != null) {
      MyToast.showGetToast(
          title: 'Error',
          message: validateMobile(mobileEditController.value.text)!,
          color: whiteColor,
          backgroundColor: Colors.red);

      return;
    }

    try {
      isLoading(true);
      LoaderHelper.showLoader(context);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
        print(dobEditController.value.text);
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
        print('${Constants.baseUrl}/${Constants.updateProfile}');
      }

      final res = await http.put(
        Uri.parse('${Constants.baseUrl}/${Constants.updateProfile}'),
        body: jsonEncode({
          "guardian": guardianNameEditController.value.text,
          "userName": nameEditController.value.text,
          "email": emailEditController.value.text,
          "mobile": mobileEditController.value.text,
          "dateOfBirth": dobEditController.value.text,
          "location": addressEditController.value.text,
          "address": {
            "latitude": updatedLatitude.value,
            "longitude": updatedLongitude.value
          },
        }),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      LoaderHelper.hideLoader(context);
      isLoading(false);

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        // getProfileModel = getProfileModelFromJson(res.body);
        // emailEditController.value.text = json['body']['email'];

        // nameEditController.value.text = json['body']['userName'];
        // mobileEditController.value.text = json['body']['mobile'];

        // guardianNameEditController.value.text = json['body']['guardian'];
        // dobEditController.value.text = json['body']['dateOfBirth'] ?? '';
        // dobDisplayController.text = json['body']['dateOfBirth'] ?? '';

        // profileImage?.value = json['body']['image'].toString();

        UserInfo().addUserName = json['body']['userName'] ?? '';
        UserInfo().addUserEmail = json['body']['email'] ?? '';
        UserInfo().addUserMobileNumber = json['body']['mobile'] ?? '';
        UserInfo().addUserProfileUrl = json['body']['image'] ?? '';
        UserInfo().addUserAdress = json['body']['location'] ?? '';
        UserInfo().addUserLatitude = "${json['body']['address']['latitude']}";
        UserInfo().addUserLatitude = "${json['body']['address']['longitude']}";

        update();

        fetchGetProfile();
        MyToast.showGetToast(
            title: "Success",
            message: "updated successfully!",
            backgroundColor: Colors.green,
            color: Colors.white);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.mainScreenTabs, (route) => false);

        if (kDebugMode) {
          print(json);
        }
      } else {
        if (kDebugMode) {
          print(res.statusCode);
        }
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      isLoading(false);
      MyToast.showGetToast(
          title: "Error",
          message: "Something went wrong! try again",
          backgroundColor: Colors.red,
          color: Colors.white);
      if (kDebugMode) {
        print(e);
        print('update profile error');
      }
    }

    // Perform registration logic
  }

  Future<void> fetchGetProfile() async {
    try {
      isLoading(true);
      if (kDebugMode) {
        print(UserInfo().getUserToken);
        print('${Constants.baseUrl}/${Constants.getProfile}');
      }

      final res = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.getProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      isLoading(false);
      if (kDebugMode) {
        print(res.statusCode);
        print(res.body);
      }

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (kDebugMode) {
          print(json);
        }
        getProfileModel = getProfileModelFromJson(res.body);
        emailEditController.value.text = json['body']['email'] ?? '';
        nameEditController.value.text = json['body']['userName'] ?? '';
        mobileEditController.value.text = json['body']['mobile'] ?? '';
        guardianNameEditController.value.text = json['body']['guardian'] ?? '';
        dobEditController.value.text = json['body']['dateOfBirth'] ?? '';
        // dobDisplayController.text = json['body']['dateOfBirth'] ?? '';
        addressEditController.value.text = json['body']['location'] ?? '';

        dobDisplayController.text = MediaQueryUtil.formatDateWithSuffix(
            DateTime.parse(json['body']['dateOfBirth']));
        profileImage?.value = json['body']['image'].toString();
        UserInfo().addUserProfileUrl = json['body']['image'].toString();
        UserInfo().addUserLatitude = "${json['body']['address']['latitude']}";
        UserInfo().addUserLatitude = "${json['body']['address']['longitude']}";
        updatedLatitude.value = "${json['body']['address']['latitude']}";
        updatedLongitude.value = "${json['body']['address']['longitude']}";
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
      var url = '${Constants.baseUrl}/${Constants.updateProfileImage}';
      if (kDebugMode) {
        print('Upload URL: $url');
      }
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
          '${Constants.baseUrl}/${Constants.updateProfileImage}',
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
      }
      if (kDebugMode) {
        print(response.body);
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        UserInfo().addUserProfileUrl = json['imageUrl'];
        // Fetch the updated profile to get the new image URL
        await fetchGetProfile();
        MyToast.showGetToast(
            title: "Success",
            message: json['message'],
            backgroundColor: Colors.green,
            color: Colors.white);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
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
