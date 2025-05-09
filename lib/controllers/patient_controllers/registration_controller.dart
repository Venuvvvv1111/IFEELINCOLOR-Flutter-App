import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/dailogs/email_verify_dailog.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var addressController = TextEditingController().obs;
  RxString updatedLatitude = ''.obs;
  RxString updatedLongitude = ''.obs;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final licenseController = TextEditingController();
  final dobController = TextEditingController();
  TextEditingController guardianNameController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();
  final dobFocusNode = FocusNode();
  final guardianNameFocusNode = FocusNode();
  RxString? selectedCard = ''.obs;
  RxBool? isSelected = false.obs;
  var isGuardianFieldVisible = false.obs;
  var isChecked1 = false.obs;
  var frontLicenseImage = Rx<File?>(null);
  var backLicenseImage = Rx<File?>(null);
  final picker = ImagePicker();
  @override
  void onClose() {
    // Dispose controllers and focus nodes here
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    mobileController.clear();
    dobController.clear();
    guardianNameController.clear();
    super.onClose();
  }

  // Method to pick an image (front/back of the license)
  Future<void> pickImage(bool isFront) async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Use camera if you prefer

    if (pickedFile != null) {
      if (isFront) {
        frontLicenseImage.value = File(pickedFile.path);
      } else {
        backLicenseImage.value = File(pickedFile.path);
      }
    }
  }

  String? validateEmail(String value) {
    if (!RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value)) {
      return "Provide a valid email";
    }
    return null;
  }

  void selectCard(String cardType) {
    selectedCard?.value = cardType;

    update();
    if (kDebugMode) {
      print('Selected: $cardType');
    }
  }

  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
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

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? validateLicence(String value) {
    if (value.isEmpty) {
      return 'License number is required';
    }
    return null;
  }

  void onTermsAndConditionsChanged(
    bool? value,
  ) async {
    isChecked1.value = value ?? false;
  }

  void doctorRegister(
      context,
      bool isGmail,
      String? gMail,
      String? gName,
      String? gPassword,
      File? frontLicenseImage,
      File? backLicenseImage) async {
    // Check if the registration is via Gmail
    if (isGmail) {
      Get.snackbar("Error", "Gmail will not support for this role",
          colorText: Colors.white, backgroundColor: Colors.red);
      return; // Exit early and don't proceed with registration
    }

    // If not Gmail, proceed with normal registration (your existing code)
    if (validateName(nameController.text) != null) {
      Get.snackbar("Error", validateName(nameController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateEmail(emailController.text) != null) {
      Get.snackbar("Error", validateEmail(emailController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateMobile(mobileController.text) != null) {
      Get.snackbar("Error", validateMobile(mobileController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateDob(dobController.text) != null) {
      Get.snackbar("Error", validateDob(dobController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validatePassword(passwordController.text) != null) {
      Get.snackbar("Error", validatePassword(passwordController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateConfirmPassword(confirmPasswordController.text) != null) {
      Get.snackbar(
          "Error", validateConfirmPassword(confirmPasswordController.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateAddress(addressController.value.text) != null) {
      Get.snackbar("Error", validateAddress(addressController.value.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (validateLicence(licenseController.value.text) != null) {
      Get.snackbar("Error", validateLicence(licenseController.value.text)!,
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (frontLicenseImage == null) {
      Get.snackbar("Error", 'Please upload valid documents',
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }

    if (backLicenseImage == null) {
      Get.snackbar("Error", 'Please upload valid documents',
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }
    if (!isChecked1.value) {
      Get.snackbar("Error", "You must agree to the terms and conditions",
          colorText: whiteColor, backgroundColor: Colors.red);
      return;
    }

    try {
      LoaderHelper.showLoader(context);

      var uri = Uri.parse('${Constants.baseUrl}/${Constants.doctorRegister}');
      var request = http.MultipartRequest('POST', uri);

      // Add registration form data to the request
      request.fields['userName'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['dateOfBirth'] = dobController.text;
      request.fields['mobile'] = mobileController.text;
      request.fields['address'] = jsonEncode({
        "latitude": updatedLatitude.value,
        "longitude": updatedLongitude.value,
        "location": addressController.value.text,
      });

      // Add license images to the request (if selected)
      // ignore: unnecessary_null_comparison
      if (frontLicenseImage != null) {
        var frontLicenseFile = await http.MultipartFile.fromPath(
            'front_license', frontLicenseImage.path);
        request.files.add(frontLicenseFile);
      }

      // ignore: unnecessary_null_comparison
      if (backLicenseImage != null) {
        var backLicenseFile = await http.MultipartFile.fromPath(
            'back_license', backLicenseImage.path);
        request.files.add(backLicenseFile);
      }

      // Send the request
      final res = await request.send();

      LoaderHelper.hideLoader(context);

      // Handle response

      if (res.statusCode == 201 || res.statusCode == 200) {
        if (kDebugMode) {
          print('Registration successful');
        }
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        nameController.clear();
        mobileController.clear();
        dobController.clear();
        guardianNameController.clear();

        showDialog(
          context: context,
          builder: (context) {
            return const EmailVerifyDailog();
          },
        );
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: res.reasonPhrase.toString(),
            backgroundColor: Colors.red,
            color: whiteColor);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      MyToast.showGetToast(
          title: 'Error',
          message: e.toString(),
          backgroundColor: Colors.red,
          color: whiteColor);
    }
  }

  void register(context, bool isGmail, String? gMail, String? gName,
      String? gPassword) async {
    if (isGmail) {
      if (kDebugMode) {
        print("this is mail");
      }
      try {
        LoaderHelper.showLoader(context);
        // ProgressDialogue.showw(context, 'logging in...');
        // isLoggedIn.value = true;

        if (kDebugMode) {
          print('${Constants.baseUrl}/${Constants.register}');
        }
        final res = await http.post(
          Uri.parse('${Constants.baseUrl}/${Constants.register}'),
          body: jsonEncode({
            "userName": "$gName",
            "email": "$gMail",
            "password": "$gPassword",
            "dateOfBirth": '2024-12-10',
            "mobile": "123456789",
            // "address": {
            //   "latitude": updatedLatitude.value,
            //   "longitude": updatedLongitude.value
            // },
            // "location": addressController.value.text
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        LoaderHelper.hideLoader(context);
        if (kDebugMode) {
          print(res.statusCode);
          print(res.body);
        }

        final json = jsonDecode(res.body);
        if (res.statusCode == 201 || res.statusCode == 200) {
          // final json = jsonDecode(res.body);
          if (kDebugMode) {
            print(res.body);
          }
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          nameController.clear();
          mobileController.clear();
          dobController.clear();
          guardianNameController.clear();

          showDialog(
              context: context,
              builder: (context) {
                return const EmailVerifyDailog();
              });

          // MyToast.showToast(message: 'Registed successfully');

          // Navigator.pushNamed(context, AppRoutes.mainScreenTabs);
        } else {
          MyToast.showToast(message: json['message']);
        }
      } catch (e) {
        LoaderHelper.hideLoader(context);
      }
    } else {
      if (validateName(nameController.text) != null) {
        Get.snackbar("Error", validateName(nameController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validateEmail(emailController.text) != null) {
        Get.snackbar("Error", validateEmail(emailController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validateMobile(mobileController.text) != null) {
        Get.snackbar("Error", validateMobile(mobileController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validateDob(dobController.text) != null) {
        Get.snackbar("Error", validateDob(dobController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validatePassword(passwordController.text) != null) {
        Get.snackbar("Error", validatePassword(passwordController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validateConfirmPassword(confirmPasswordController.text) != null) {
        Get.snackbar(
            "Error", validateConfirmPassword(confirmPasswordController.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (validateAddress(addressController.value.text) != null) {
        Get.snackbar("Error", validateAddress(addressController.value.text)!,
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      if (!isChecked1.value) {
        Get.snackbar("Error", "You must agree to the terms and conditions",
            colorText: whiteColor, backgroundColor: Colors.red);
        return;
      }
      try {
        LoaderHelper.showLoader(context);
        // ProgressDialogue.showw(context, 'logging in...');
        // isLoggedIn.value = true;

        if (kDebugMode) {
          print('${Constants.baseUrl}/${Constants.register}');
        }
        final res = await http.post(
          Uri.parse('${Constants.baseUrl}/${Constants.register}'),
          body: jsonEncode({
            "userName": nameController.text.toString(),
            "email": emailController.text,
            "password": passwordController.text,
            "dateOfBirth": dobController.text,
            "mobile": mobileController.text,
            "address": {
              "latitude": updatedLatitude.value,
              "longitude": updatedLongitude.value
            },
            "location": addressController.value.text
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        LoaderHelper.hideLoader(context);

        if (kDebugMode) {
          print(res.statusCode);
          print(res.body);
        }
        if (res.statusCode == 201 || res.statusCode == 200) {
          // final json = jsonDecode(res.body);
          if (kDebugMode) {
            print(res.body);
          }
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          nameController.clear();
          mobileController.clear();
          dobController.clear();
          guardianNameController.clear();

          showDialog(
              context: context,
              builder: (context) {
                return const EmailVerifyDailog();
              });

          // MyToast.showToast(message: 'Registed successfully');

          // Navigator.pushNamed(context, AppRoutes.mainScreenTabs);
        } else {
          MyToast.showGetToast(
              title: 'Error',
              message: res.reasonPhrase.toString(),
              backgroundColor: Colors.red,
              color: whiteColor);
        }
      } catch (e) {
        LoaderHelper.hideLoader(context);
        if (kDebugMode) {
          print(e);
        }
        MyToast.showGetToast(
            title: 'Error',
            message: e.toString(),
            backgroundColor: Colors.red,
            color: whiteColor);
      }
    }
  }
}
