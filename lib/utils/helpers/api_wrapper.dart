import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ifeelin_color/utils/constants/user_data.dart';

class ApiWrapper {
  final String baseUrl;
  final http.Client client;

  ApiWrapper({required this.baseUrl, required this.client});

  Future<Map<String, dynamic>> get(String endpoint,
      {bool token = false, Map<String, dynamic>? queryParams}) async {
    Uri uri = Uri.parse('$baseUrl/$endpoint');
    if (kDebugMode) {
      print('queryParams != null');
      print(queryParams != null);
    }

    // ignore: prefer_typing_uninitialized_variables
    var newUri;
    if (queryParams != null) {
      newUri = uri.replace(queryParameters: queryParams);
      if (kDebugMode) {
        print(newUri);
      }
    }

    final response = await client.get(
      queryParams != null ? newUri : uri,
      headers: token
          ? {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${UserInfo().getUserToken.toString()}',
            }
          : {
              'Content-Type': 'application/json',
            },
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data,
      {bool token = false}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(data),
        headers: token
            ? {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${UserInfo().getUserToken.toString()}',
              }
            : {
                'Content-Type': 'application/json',
              },
      );
      // .timeout(const Duration(milliseconds: 10000));

      if (kDebugMode) {
        print(response.statusCode);
        print(response.body);
      }

      if (response.statusCode == 200) {
        return _processResponse(response);
      } else {
        if (kDebugMode) {
          print('response.body');
          print(response.body);
        }

        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print('e');
      }

      if (e is SocketException) {
        if (kDebugMode) {
          print("Socket exception: ${e.toString()}");
        }
      } else if (e is TimeoutException) {
        Get.defaultDialog(title: 'Error in getting data');
        if (kDebugMode) {
          print("Timeout exception: ${e.toString()}");
        }
      } else {
        if (kDebugMode) {
          print('unhandled exception..... $e');
        }
      }

      if (kDebugMode) {
        print(e);
        print('this is exception');
      }

      return {
        'error': 'There was an error in getting the data please try again',
        'status': 'exception'
      };
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, dynamic data,
      {bool token = false}) async {
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/$endpoint'),
            body: jsonEncode(data),
            headers: token
                ? {
                    'Content-Type': 'application/json',
                    'Authorization':
                        'Bearer ${UserInfo().getUserToken.toString()}',
                  }
                : {
                    'Content-Type': 'application/json',
                  },
          )
          .timeout(const Duration(milliseconds: 10000));

      if (kDebugMode) {
        print(response.body);
        print(response.statusCode);
        print('response');
      }

      if (response.statusCode == 200) {
        return _processResponse(response);
      } else {
        if (kDebugMode) {
          print('response.body');
          print(response.body);
          print('response.body');
          print(response.statusCode);
          print('an error has occured');
        }

        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (e is SocketException) {
        if (kDebugMode) {
          print("Socket exception: ${e.toString()}");
        }
      } else if (e is TimeoutException) {
        Get.defaultDialog(title: 'Error in updating data');
        if (kDebugMode) {
          print("Timeout exception: ${e.toString()}");
        }
      } else {
        if (kDebugMode) {
          print('unhandled exception..... $e');
        }
      }

      if (kDebugMode) {
        print(e);
      }

      return {
        'error': 'There was an error in updating the data please try again',
        'status': 'exception'
      };
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint,
      {bool token = false}) async {
    try {
      final response = await client
          .delete(
            Uri.parse('$baseUrl/$endpoint'),
            headers: token
                ? {
                    'Content-Type': 'application/json',
                    'Authorization':
                        'Bearer ${UserInfo().getUserToken.toString()}',
                  }
                : {
                    'Content-Type': 'application/json',
                  },
          )
          .timeout(const Duration(milliseconds: 10000));

      if (kDebugMode) {
        print(response.statusCode);
        print('response');
        print(response.body);
      }

      if (response.statusCode == 200) {
        return _processResponse(response);
      } else {
        if (kDebugMode) {
          print('response.body');
          print(response.body);
          print('response.body');
          print(response.statusCode);
          print('an error has occured');
        }

        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (e is SocketException) {
        if (kDebugMode) {
          print("Socket exception: ${e.toString()}");
        }
      } else if (e is TimeoutException) {
        Get.defaultDialog(title: 'Error in deleting data');
        if (kDebugMode) {
          print("Timeout exception: ${e.toString()}");
        }
      } else {
        if (kDebugMode) {
          print('unhandled exception..... $e');
        }
      }

      if (kDebugMode) {
        print(e);
      }

      return {
        'error': 'There was an error in deleting the data please try again',
        'status': 'exception'
      };
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (kDebugMode) {
      print(statusCode);
      print(responseBody);
    }

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      return jsonDecode(responseBody);
    }
  }
}
