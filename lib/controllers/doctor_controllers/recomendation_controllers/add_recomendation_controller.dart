import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/services/pdf_view_sreen.dart';
import 'package:ifeelin_color/utils/constants/string_constants.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/dailogs/add_recomendation_dailog.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RecommendationController extends GetxController {
  var recommendationText = ''.obs;

  var selectedCategory = 0.obs;
  var images = <dynamic>[].obs; // List to store images
  var documents = <dynamic>[].obs; // List to store documents
  var links = <String>[].obs;

  final ImagePicker _picker = ImagePicker(); // For picking images

  // Update selected category based on index (0 for images, 1 for documents, 2 for links)
  void updateCategory(int index) {
    selectedCategory.value = index; // Now we just pass the index (int)
  }

  final List<Map<String, String>> categories = [
    {'label': 'Images', 'icon': AppIcons.imageIcon},
    {'label': 'Documents', 'icon': AppIcons.documentIcon},
    {'label': 'Links', 'icon': AppIcons.vedioIcon},
  ];

  // Pick images using ImagePicker and add only to images list
  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      images.addAll(pickedFiles); // Add picked images only to images list
    }
  }

  // Pick a document (PDF) using FilePicker and add only to documents list
  // Future<void> pickDocument() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'], // Restrict to PDF files
  //   );
  //   if (result != null) {
  //     File document = File(result.files.single.path!); // Get the file
  //     documents.add(document); // Add document only to documents list
  //   }
  // }
  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      if (filePath.endsWith('.pdf')) {
        File document = File(filePath);
        documents.add(document);
      } else {
        Get.snackbar('Invalid File', 'Please select a valid PDF document',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> addVideoLink() async {
    String? videoLink; // Declare the variable here
    videoLink = await Get.dialog<String?>(
      AlertDialog(
        title: const Text('Add Video Link'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Enter video URL'),
          onChanged: (value) => videoLink = value, // Use the outer variable
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Get.back(result: videoLink), // Return the videoLink
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (videoLink != null && videoLink!.isNotEmpty) {
      links.add(videoLink.toString()); // Add video link only to links list
    }
  }

  // Remove an item from the selected list
  void removeItem(int category, dynamic item) {
    if (category == 0) {
      images.remove(item); // Remove from images list
    } else if (category == 1) {
      documents.remove(item); // Remove from documents list
    } else if (category == 2) {
      links.remove(item); // Remove from links list
    }
  }

  void previewPDF(String filePath, context) {
    if (kDebugMode) {
      print(filePath);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFViewerScreen(filePath: filePath)));
  }

// API request to create recommendation
  Future<void> sendRecommendation(String recommendedTo, context) async {
    try {
      LoaderHelper.showLoader(context);
      var url =
          Uri.parse('${Constants.baseUrl}/${Constants.addRecomendationURL}');

      var request = http.MultipartRequest('POST', url);
      request.headers['authorization'] = 'Bearer ${UserInfo().getUserToken}';
      request.fields['recommendation'] = recommendationText.value;
      request.fields['recommendedTo'] = recommendedTo;

      // Add images
      for (var image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('images', image.path));
      }

      // Add documents
      for (var document in documents) {
        request.files
            .add(await http.MultipartFile.fromPath('documents', document.path));
      }

      // Add links
      request.fields['videos'] = jsonEncode(links);

      // Send the request and process the response
      var response = await request.send();
      LoaderHelper.hideLoader(context);
      // Decode the response and show it in a dialog
      if (response.statusCode == 200 || response.statusCode == 201) {
        response.stream.transform(utf8.decoder).listen((value) async {
          var jsonResponse = jsonDecode(value); // Parse the response JSON

          String message = jsonResponse['message'] ?? '...';
          String status = jsonResponse['status'] ?? 'false';

          // Show dialog with the response message

          // Show a snackbar based on the status
          if (status == "success") {
            await showDialog(
              context: context,
              builder: (context) {
                return AddrecomendationDailog(
                  status: true,
                  message: message,
                );
              },
            );
          } else {
            MyToast.showGetToast(
                title: 'Error',
                message: message,
                color: whiteColor,
                backgroundColor: Colors.red);
          }
        });
      } else {
        MyToast.showGetToast(
            title: 'Error',
            message: 'unexpected server response ${response.statusCode}',
            color: whiteColor,
            backgroundColor: Colors.red);
      }

      // Check the status code for additional handling
    } catch (e) {
      LoaderHelper.hideLoader(context);

      MyToast.showGetToast(
          title: 'Error',
          message: e.toString(),
          color: whiteColor,
          backgroundColor: Colors.red);
    }
  }
}
