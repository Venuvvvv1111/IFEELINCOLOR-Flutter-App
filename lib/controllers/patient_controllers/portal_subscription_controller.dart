import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/services/payment_gateway/stripe_service.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/dailogs/payment_sucess.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../models/patient_models/portal_plans_model.dart';
import '../../utils/constants/string_constants.dart';

class SubscribePortalController extends GetxController {
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

  void onPageChanged(int index) {
    currentPage.value = index;
    showViewMore.value = index != plans.length - 1;
  }

  void onGetStarted(context, Stripeservice stripeService) async {
    // Check if there is an active subscription
    final bool hasActiveSubscription = await checkActiveSubscription();
    try {
      isloading.value = true;
      if (kDebugMode) {
        print('hasActiveSubscription' "$hasActiveSubscription");
      }
      if (hasActiveSubscription == true) {
        // Show message if there's an active subscription
        MyToast.showGetToast(
          title: "Active Subscription Found",
          message:
              "You are already on an active plan, so you can proceed after that completion of active plan",
          backgroundColor: Colors.green,
          color: whiteColor,
        );
        return; // Stop the process if there's an active subscription
      } else {
        final currentPlan = plans[currentPage.value];
        String planId = '${currentPlan.sId}';
        if (currentPlan.name == "FREE TRAIL") {
          await subscribePortal(context, planId,title:currentPlan.name );
        } else {
          bool paymentSuccess = await stripeService.makePayment(
              context, double.parse(currentPlan.price!), currentPlan.name);

          if (kDebugMode) {
            print('ID: ${currentPlan.sId}');
          }

          if (paymentSuccess) {
            MyToast.showGetToast(
              title: "Thank you",
              message: "Your payment has been successfully completed.",
              backgroundColor: Colors.green,
              color: whiteColor,
            );

            // Proceed with subscription only if payment succeeds
            await subscribePortal(context, planId);
          } else {
            // Show payment failure message
            MyToast.showGetToast(
              title: "Payment Failed",
              message: "Your payment was not successful. Please try again.",
              backgroundColor: Colors.red,
              color: whiteColor,
            );
          }
        }
      }

      // Proceed if there's no active subscription
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isloading.value = false;
    }
  }

// Function to check if there is an active subscription
  Future<bool> checkActiveSubscription() async {
    UserInfo userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print('is user loged in ');
      print(userInfo.getUserLogin);
    }

    try {
      isloading.value = true;
      final response = await http.get(
        Uri.parse(userInfo.getUserLogin
            ? '${Constants.baseUrl}/${Constants.patientSubscriptionCheck}'
            : '${Constants.baseUrl}/${Constants.doctorSubscriptionCheck}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${userInfo.getUserToken}'
        },
      );

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

  void onViewMore(int page) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    showViewMore.value = false;
  }

  void onViewLess(int page) {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    showViewMore.value = true;
  }

  Future<void> fetchPlans() async {
    Get.put(UserInfo());
    try {
      intialLoading.value = true;
      if (kDebugMode) {
        print('is user logged in');
        print(UserInfo().getUserLogin);
      }

      final response = await http.get(
        Uri.parse(UserInfo().getUserLogin
            ? '${Constants.baseUrl}/${Constants.listPortalPlans}'
            : '${Constants.baseUrl}/${Constants.doctorApplistPortalPlans}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}'
        },
      );

      if (kDebugMode) {
        print(response.statusCode);
      }
      // print(response.body);
      if (response.statusCode == 200) {
        final portalPlansModel = portalPlansModelFromJson(response.body);
        plans.value = portalPlansModel.body ?? [];
      } else {
        // Handle the error
        if (kDebugMode) {
          print('Failed to load plans');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      intialLoading.value = false;
    }
  }

  Future<void> subscribePortal(context, String doctorId,{title=""}) async {
    Get.put(UserInfo());
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
      final response = await http.post(
          Uri.parse(UserInfo().getUserLogin
              ? '${Constants.baseUrl}/${Constants.subscribeToDoctor}/${currentPlan.sId}'
              : '${Constants.baseUrl}/${Constants.doctorAppSubscribeToPortal}/${currentPlan.sId}'),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer ${UserInfo().getUserToken}'
          },
          body: jsonEncode({"clinisistId": 'null'}));
      final json = jsonDecode(response.body);
      if (kDebugMode) {
        print(
            "'${Constants.baseUrl}/${Constants.subscribeToDoctor}/${currentPlan.sId}'  {response.statusCode}"
            "{response.body}");
        print("${response.statusCode}" "${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if(currentPlan.name=="FREE TRAIL"){
           MyToast.showGetToast(title: '🎉 Free Trial Activated!', message: "Enjoy full access to all features during your trial period",color: whiteColor,backgroundColor: greenColor);
        }
        _handlePaymentSuccess(context, UserInfo().getUserLogin ? true : false);
      } else {
        MyToast.showGetToast(
            title: "Error",
            message: json['message'],
            backgroundColor: Colors.red,
            color: whiteColor);
        // throw Exception('Error ${response.statusCode}${response.body}');
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
            isUserLogin: isUserLogin,
            status: true,
          );
        });
  }
}
