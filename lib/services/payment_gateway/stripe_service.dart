import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class Stripeservice {
  // Fetch the publishable key from your server
  Future<void> initializeStripe() async {
    final publishableKey = await fetchPublishableKey();
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.identifier';
    Stripe.urlScheme = 'your-url-scheme';
    if (kDebugMode) {
      print('publish key ');
    }
  }

  Future<String> fetchPublishableKey() async {
    // Replace with your logic to fetch the key
    return 'pk_live_51Ha38vC3fYlapPgfpKPhkXJikYr65YuLqCR7VtDrg8EMutKKjqUuGcQt1WKQb5aG57r8WUO1red22ol5hKiK1ZLt007WmwMnfg';
  }

  Map<String, dynamic>? paymentIntent;

  Future<bool> makePayment(context, double amount, String? name) async {
    try {
      LoaderHelper.showLoader(context);
      paymentIntent = await createPaymentIntent(amount, name);

      if (paymentIntent != null) {
        await initializePaymentSheet(name);
        await presentPaymentSheet(context); // Ensure this step completes
        return true; // Return true only if payment succeeds
      }
    } catch (e) {
      // LoaderHelper.hideLoader(context);
      if (kDebugMode) {
        print(e);
      }
      // Display a specific error message
    } finally {
      LoaderHelper.hideLoader(context);
    }
    return false;
  }

  Future<void> initializePaymentSheet(String? name) async {
    if (kDebugMode) {
      print("Publishable Key: ${Stripe.publishableKey}");
      print("Using live secret key in API call: sk_live_...");
    }

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: '$name',
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            currencyCode: 'USD',
            //  testEnv: false,
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing payment sheet: $e');
      }
      throw Exception('Error initializing payment sheet: ');
    }
  }

  Future<void> presentPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception('Error presenting payment sheet: $e');
    }
  }

  Future<String> createCustomer(String email, String name, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization':
              'Bearer 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', // Replace with your test/live key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'name': name,
          'phone': phone,
        },
      );

      if (response.statusCode == 200) {
        final customer = json.decode(response.body);
        return customer['id']; // Return the newly created customer ID
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating customer: $e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    double amount,
    String? name,
  ) async {
    double finalAmount = amount;
    UserInfo userInfo = Get.put(UserInfo());
    if (kDebugMode) {
      print(
          "userInfo.getUserEmail ${userInfo.getUserEmail} patinet id ${userInfo.getPatientId}");
    }
    int amountInCents = (finalAmount * 100).toInt(); // Convert to cents
    String customerId = await createCustomer(
      userInfo.getUserEmail,
      userInfo.getUserName ?? 'Unknown',
      userInfo.getUserMobileNumber,
    );

    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': '$amountInCents',
          'currency': 'USD',
          'customer': customerId,
          'metadata[name]': userInfo.getUserName ?? 'UnKnown',
          'receipt_email': userInfo.getUserEmail.isNotEmpty
              ? userInfo.getUserEmail
              : 'fallback@example.com',
          'metadata[phone]': userInfo.getUserMobileNumber,
          'metadata[customer_id]': userInfo.getPatientId,
          'metadata[payment_date]': DateTime.now().toIso8601String(),
          'metadata[plan_type]': name ?? 'unknown plan',
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print('Failed to create payment intent: ${response.body}');
        }
        throw Exception('Failed to create payment intent:');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }
}
