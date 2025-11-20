import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/api_wrapper.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var rememberMe = false.obs;
  var isLoading = true.obs;
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final loginFormKey = GlobalKey<FormState>();
  final api = ApiWrapper(baseUrl: Constants.baseUrl, client: http.Client());

  RxString? selectedCard = ''.obs;
  RxBool? isSelected = false.obs;
  RxBool isPasswordVisible = true.obs;
  @override
  void onClose() {
    super.onClose();
    emailController.clear();
    passwordController.clear();
  }

  // Function to handle card selection
  void selectCard(String cardType) {
    selectedCard?.value = cardType;

    update();
    if (kDebugMode) {
      print('Selected: $cardType');
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    if (!RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  void onRememberMeChanged(bool? value) {
    rememberMe.value = value ?? false;
    if (kDebugMode) {
      print(rememberMe.value);
    }
  }

  Future<void> login(
      context, bool isGmail, String? gMail, String? gPassword) async {
    try {
      if(Platform.isIOS){
    await getAPNSToken();
      }
  
      if (kDebugMode) {
        print('token in login $gMail $isGmail ');
      }
String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      LoaderHelper.showLoader(context);
      // ProgressDialogue.showw(context, 'logging in...');
      // isLoggedIn.value = true;

      if (kDebugMode) {
        print(
            'base url ${Constants.baseUrl}/${Constants.login} ${emailController.text} $isGmail');
      }

      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.login}'),
        body: jsonEncode({
          "email": isGmail ? gMail : emailController.text,
          "password": isGmail ? gPassword : passwordController.text,
          "deviceToken":deviceToken,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      LoaderHelper.hideLoader(context);
      final json = jsonDecode(res.body);
      if (kDebugMode) {
        if (kDebugMode) {
          print(res.body);
        }
      }
      if (kDebugMode) {
        print(res.statusCode);
      }
      if (res.statusCode == 200) {
        GetStorage box = GetStorage();
        var userinfo = Get.put(UserInfo());
        if (kDebugMode) {
          print(json);
        }
        if (rememberMe.value) {
          userinfo.addUserLogin = true;
        }
        userinfo.addUserLogin = true;
        box.write('isLogin', true);

        userinfo.addUserToken = json['body']['token'];
        userinfo.addPatientId = json['body']['patient']['id'];
        userinfo.addUserName = json['body']['patient']['userName'];
        userinfo.addUserEmail = json['body']['patient']['email'];
        userinfo.addUserMobileNumber = json['body']['patient']['mobile'];
        userinfo.addUserAdress = json['body']['patient']['location'] ?? "";

        userinfo.addUserProfileUrl = json['body']['patient']['image'] ?? '';
        // userinfo.addUserLatitude = "${json['body']['address']['latitude']}";
        // userinfo.addUserLatitude = "${json['body']['address']['longitude']}";
        emailController.clear();
        passwordController.clear();
        MyToast.showGetToast(
            title: "Success",
            message: json['message'],
            backgroundColor: Colors.green,
            color: Colors.white);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.mainScreenTabs,
          (Route<dynamic> route) => false, // This removes all previous routes
        );
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      if (kDebugMode) {
        print(e);
      }
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
      if (kDebugMode) {
        print('login ec');
      }
    } finally {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  Future<void> getAPNSToken() async {
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken() ?? "";
    if (kDebugMode) {
      print("APNS Token: $apnsToken");
    }
  }

  Future<void> doctorLogin(context) async {
    try {
      await getAPNSToken();
      // print(await FirebaseMessaging.instance.getToken());
      LoaderHelper.showLoader(context);
      // ProgressDialogue.showw(context, 'logging in...');
      // isLoggedIn.value = true;
      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.doctorLogin}');
      }
      final res = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.doctorLogin}'),
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
          "deviceToken": await FirebaseMessaging.instance.getToken() ?? "",
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(res.body);
      if (kDebugMode) {
        print(res.statusCode);
        print(json);
      }

      LoaderHelper.hideLoader(context);
      if (res.statusCode == 200) {
        GetStorage box = GetStorage();
        var userinfo = Get.put(UserInfo());
        if (rememberMe.value) {
          userinfo.addDoctorLogin = true;
        }
        userinfo.addDoctorLogin = true;
        box.write('isDoctorLogin', true);
        userinfo.addUserToken = json['body']['token'];
        userinfo.addPatientId = json['body']['clinisist']['_id'];
        userinfo.addUserName = json['body']['clinisist']['name'];
        userinfo.addUserEmail = json['body']['clinisist']['email'];
        userinfo.addUserMobileNumber = json['body']['clinisist']['mobileNum'];
        userinfo.addExperince = json['body']['clinisist']['experience'] ?? '';
        userinfo.addUserProfileUrl = json['body']['clinisist']['image'] ?? '';
        userinfo.addUserAdress = json['body']['clinisist']['location'] ?? "";
        userinfo.addDoctorRatings = json['body']['clinisist']['ratings'] ?? '';
        userinfo.addUserDesignation =
            json['body']['clinisist']['specializedIn'] ?? '';
        emailController.clear();
        passwordController.clear();
        MyToast.showGetToast(
            title: "Success",
            message: json['message'],
            backgroundColor: Colors.green,
            color: Colors.white);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.doctorMainTabsScreen,
          (Route<dynamic> route) => false, // This removes all previous routes
        );
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
            backgroundColor: Colors.red,
            color: Colors.white);
      }
    } catch (e) {
      LoaderHelper.hideLoader(context);
      if (kDebugMode) {
        print(e);
      }
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void onForgetPassword(context) async {
    try {
      LoaderHelper.showLoader(context);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.resetPassword}'),
        body: jsonEncode(
            {"email": emailController.value.text, "userType": "patient"}),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
      if (kDebugMode) {
        print(e);
      }
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      LoaderHelper.hideLoader(context);
      isLoading(false);
    }
  }

  void onDoctorForgetPassword(context) async {
    try {
      LoaderHelper.showLoader(context);
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/${Constants.resetPassword}'),
        body: jsonEncode(
            {"email": emailController.value.text, "userType": "clinisist"}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
      MyToast.showGetToast(
          title: "Error",
          message: e.toString(),
          backgroundColor: Colors.red,
          color: Colors.white);
    } finally {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      LoaderHelper.hideLoader(context);
      isLoading(false);
    }
  }
}
