import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/account_controllers/get_doctor_profile_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class SpecializedForm extends StatefulWidget {
  final GetDoctorProfileController controller;

  const SpecializedForm({super.key, required this.controller});

  @override
  State<SpecializedForm> createState() => _SpecializedFormState();
}

class _SpecializedFormState extends State<SpecializedForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: MediaQueryUtil.size(context).width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Spetialization',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      editInputFeilds(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editInputFeilds(BuildContext context) {
    return Column(
      children: [
        Container(
          color: whiteColor,
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.controller.spetialityEditController.value,
                  focusNode: widget.controller.mobileEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    label: const Text('Specialty'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: whiteColor,
                    hintText: 'Enter Specialty',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  // validator: (value) =>
                  //     widget.controller.validateMobile(value ?? ''),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQueryUtil.size(context).width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(2);
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   widget.controller.updateProfile(context);
                      // });
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
