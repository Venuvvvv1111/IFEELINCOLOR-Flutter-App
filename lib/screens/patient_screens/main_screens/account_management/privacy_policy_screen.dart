import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/account_controllers/privacy_policy_controller.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../../utils/constants/user_data.dart';

// ignore: must_be_immutable
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

  // ignore: unused_field
  final UserInfo _userInfo = Get.put(UserInfo());
  @override
  void initState() {
    super.initState();
    controller.fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor:
            UserInfo().getUserLogin ? primaryColor : doctorPrimaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: whiteColor,
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoaderHelper.lottiWidget());
        }

        // Check if title or content is null
        if (controller.title.value == null ||
            controller.content.value == null) {
          return const Center(child: Text('No Privacy Policy Available'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.title.value ?? 'Privacy Policy', // Display title
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.justify,
                  controller.content.value ?? 'N/A', // Display content
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
