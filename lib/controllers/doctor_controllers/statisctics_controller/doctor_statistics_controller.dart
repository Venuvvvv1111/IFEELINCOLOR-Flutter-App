import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

class DoctorStatisticsController extends GetxController {
  var subscribedPatients = 0.obs;
  var sales = 0.0.obs;
  var recommendedPatients = 0.obs;
  var growthRate = ''.obs;
  var subscriptionChartData = <ChartData>[].obs;
  var salesChartData = <ChartData>[].obs;
  var recommendedPatientsData = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionStats();
    fetchSalesStats();
    fetchRecommendedPatients();
  }

  Future<void> fetchSubscriptionStats() async {
    try {
      if (kDebugMode) {
        print('${Constants.baseUrl}/${Constants.subscriptionStatsURL}');
      }
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/${Constants.subscriptionStatsURL}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        subscribedPatients.value =
            data['body']['Subscribed_patients']['Total_subscribed_patients'];
        growthRate.value = data['body']['Subscribed_patients']['Description'];
        subscriptionChartData.value = (data['body']['Subscribed_patients']
                ['charData'] as List)
            .map((item) => ChartData(item['Month'], item['Number'].toDouble()))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchSalesStats() async {
    try {
      final response = await http.get(
        Uri.parse("${Constants.baseUrl}/${Constants.salesStatsURL}"),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        sales.value = data['body']['Sales']['total_sales_value'];
        salesChartData.value = (data['body']['Sales']['charData'] as List)
            .map((item) => ChartData(item['Month'], item['Number'].toDouble()))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> fetchRecommendedPatients() async {
    try {
      final response = await http.get(
        Uri.parse("${Constants.baseUrl}/${Constants.recommendationStatsURL}"),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${UserInfo().getUserToken}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        recommendedPatients.value =
            data['body']['Recommended_patients']['total_recommended_value'];
        recommendedPatientsData.value = (data['body']['Recommended_patients']
                ['charData'] as List)
            .map((item) => ChartData(item['Month'], item['Number'].toDouble()))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('recomneded stats error$e');
      }
    }
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
