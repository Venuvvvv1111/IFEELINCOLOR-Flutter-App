import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/services/payment_gateway/stripe_service.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/dailogs/payment_sucess.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../models/patient_models/portal_plans_model.dart';
import '../../utils/constants/string_constants.dart';

class SubscribeClinicController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentPage = 0.obs;
  RxBool showViewMore = true.obs;
  RxList<Body> plans = <Body>[].obs;
  Rx<bool> isloading = false.obs;
  Rx<bool> intialLoading = false.obs;
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchDoctorPlans(bool isIndividual) async {
    try {
      intialLoading.value = true;
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${isIndividual ? Constants.listIndDoctorPlans : Constants.listOrgDoctorPlans}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );
      if (kDebugMode) {
        print('venu ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final portalPlansModel = PortalPlansModel.fromJson(data);
        plans.value = portalPlansModel.body ?? [];
      } else {
        if (kDebugMode) {
          print(response.body);
        }
        throw Exception('Failed to load doctor plans');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      intialLoading.value = false;
    }
  }

  void onGetStarted(
      context, Stripeservice stripeService, String doctorId) async {
    final bool hasActiveSubscription = await checkActiveSubscription(doctorId);
    try {
      isloading.value = true;
      if (hasActiveSubscription == true) {
        MyToast.showGetToast(
          title: "Active Subscription Found",
          message:
              "You are already on an active plan, so you can proceed after completion of active plan",
          backgroundColor: Colors.green,
          color: whiteColor,
        );
        return;
      } else {
        final currentPlan = plans[currentPage.value];

        if (currentPlan.name == "FREE TRAIL") {
          await subscribeDoctor(context, doctorId);
        } else {
          bool paymentSuccess = await stripeService.makePayment(
              // ignore: use_build_context_synchronously
              context,
              double.parse(currentPlan.price!),
              currentPlan.name);
          // String planId = '${currentPlan.sId}';
          if (kDebugMode) {
            print('ID: ${currentPlan.sId}');
          }

          if (paymentSuccess) {
            MyToast.showGetToast(
              title: "Thank you",
              message: "Your payment has been succesfull completed",
              backgroundColor: Colors.green,
              color: whiteColor,
            );
            // Proceed with subscript
            //ion only if payment succeeds
            await subscribeDoctor(context, doctorId);
          } else {
            // Show payment failure message
            MyToast.showGetToast(
              title: "Payment Failed",
              message: "Your payment was failed. Please try again.",
              backgroundColor: Colors.red,
              color: whiteColor,
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isloading.value = false;
    }
  }

// Function to check if there is an active subscription
  Future<bool> checkActiveSubscription(String doctorId) async {
    UserInfo userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print('is user loged in ');
      print(userInfo.getUserLogin);
    }

    try {
      isloading.value = true;
      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.doctorSubscriptionCheckViaId}');
      }
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/${Constants.doctorSubscriptionCheckViaId}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );

      if (kDebugMode) {
        print(
          response.request,
        );
        print(response.body);
      }

      if (response.statusCode == 200) {
        // Parse the response JSON
        var data = jsonDecode(response.body);
        if (kDebugMode) {
          print(data['body']['hasActiveSubscription']);
        }
        bool hasActiveSubscription = data['body']['hasActiveSubscription'];

        return hasActiveSubscription;
      } else {
        // Handle API error
        if (kDebugMode) {
          print('Error: Unable to fetch subscription status');
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // Handle any errors during the API request
      MyToast.showGetToast(
        title: "Payment Failed",
        message: "Unable to fetch subscription status",
        backgroundColor: Colors.red,
        color: whiteColor,
      );
      return true;
    } finally {
      isloading.value = false;
    }
  }

  Future<void> subscribeDoctor(context, String doctorId) async {
    final currentPlan = plans[currentPage.value];
    if (kDebugMode) {
      print('Get Started tapped on Page ${currentPage.value + 1}');
      print('Current Plan Details:');
      print('Name: ${currentPlan.name}');
      print('Price: ${currentPlan.price}');
      print('Details: ${currentPlan.details}');
      print('Validity: ${currentPlan.validity}');
    }

    try {
      isloading.value = true;
      GetStorage box = GetStorage();
      final response = await http.post(
          Uri.parse(
              '${Constants.baseUrl}/${Constants.subscribeToDoctor}/${currentPlan.sId}'),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer ${UserInfo().getUserToken}'
          },
          body: jsonEncode({"clinisistId": doctorId}));
      if (kDebugMode) {
        print(response.body);
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _handlePaymentSuccess(context, box.read('isLogin') ?? false);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
            backgroundColor: Colors.red,
            color: whiteColor);
        throw Exception('Failed ${response.statusCode}${response.body}');
      }
    } catch (e) {
      // MyToast.showGetToast(
      //     title: "Error",
      //     message: e.toString(),
      //     backgroundColor: Colors.red,
      //     color: whiteColor);
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isloading.value = false;
    }
  }

  void _handlePaymentSuccess(BuildContext context, bool isUserLogin) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PaymenStatusDailog(
            status: true,
            isUserLogin: isUserLogin,
          );
        });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    showViewMore.value = index != plans.length - 1;
  }

  // void onGetStarted() {
  //   final currentPlan = plans[currentPage.value];
  //   print('Get Started tapped on Page ${currentPage.value + 1}');
  //   print('Current Plan Details:');
  //   print('Name: ${currentPlan.name}');
  //   print('Price: ${currentPlan.price}');
  //   print('Details: ${currentPlan.details}');
  //   print('Validity: ${currentPlan.validity}');
  // }

  void onViewMore() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    showViewMore.value = false;
  }

  void onViewLess() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    showViewMore.value = true;
  }
}
