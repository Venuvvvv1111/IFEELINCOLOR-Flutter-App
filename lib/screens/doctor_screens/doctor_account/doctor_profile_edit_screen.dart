import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/account_controllers/get_doctor_profile_controller.dart';

import 'package:ifeelin_color/models/doctor_models/doctor_profile_model.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/widgets/experience_form.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/widgets/profile_form.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class DoctorProfileEditScreen extends StatefulWidget {
  final GetDoctorProfileModel getProfileModel;
  const DoctorProfileEditScreen({super.key, required this.getProfileModel});

  @override
  State<DoctorProfileEditScreen> createState() =>
      _DoctorProfileEditScreenState();
}

class _DoctorProfileEditScreenState extends State<DoctorProfileEditScreen> {
  final GetDoctorProfileController controller =
      Get.put(GetDoctorProfileController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          foregroundColor: whiteColor,
          backgroundColor: doctorPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: whiteColor,
              )),
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Profile'),
              // Tab(text: 'Specialized'),
              Tab(text: 'Experience'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProfileForm(controller: controller), // Profile Form
            // SpecializedForm(controller: controller), // Specialized Form
            ExperienceForm(controller: controller), // Experience Form
          ],
        ),
      ),
    );
  }
}
