import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/home_controllers/doctor_home_controller.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/doctor_settings_screen.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_dashboard/doctor_dashboard.dart';
import 'package:ifeelin_color/screens/doctor_screens/patients/all_patients.dart';

import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class DoctorMainTabsScreen extends StatefulWidget {
  const DoctorMainTabsScreen({super.key});

  @override
  State<DoctorMainTabsScreen> createState() => _DoctorMainTabsScreenState();
}

class _DoctorMainTabsScreenState extends State<DoctorMainTabsScreen>
    with WidgetsBindingObserver {
  final DoctorHomeController doctorhomeController =
      Get.put(DoctorHomeController());
  final UserInfo userController = Get.put(UserInfo());

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Add observer to listen to app state changes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserInfo();
  }

  void _fetchUserInfo() {
    // Call your API or service to refresh UserInfo data
    userController
        .refreshData(); // Assuming `refreshData` fetches and updates the user data
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Check if the app resumed and refresh the screen if needed
    if (state == AppLifecycleState.resumed) {
      // setState(() {
      if (kDebugMode) {
        print('changed cycle');
      }
      // This will refresh the state when the user navigates back to this screen
      doctorhomeController.changePage(doctorhomeController.selectedIndex.value);
      // });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: doctorhomeController.selectedIndex.value,
          children: [
            const AllPatientsScreen(),
            DoctorDashboard(
              doctorHomeController: doctorhomeController,
            ),
            // RecommendedPatientsScreen(),
            const DoctorSettingsScreen()

            // RecomendationScreenView(),
            // // RazorPaymentScreen(),
            // SettingsScreen()
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return CurvedNavigationBar(
          backgroundColor: doctorPrimaryColorLight,
          buttonBackgroundColor: doctorPrimaryColor.withValues(alpha: 0.5),
          color: whiteColor,
          animationDuration: const Duration(milliseconds: 400),
          height: 55,
          items: <Widget>[
            Image.asset(
              AppIcons.moodInfoBottomIcon,
              height: 20,
              width: 20,
              color: doctorhomeController.selectedIndex.value == 0
                  ? whiteColor
                  : doctorPrimaryColor,
            ),

            Image.asset(
              AppIcons.homeBottomIcon,
              height: 20,
              width: 20,
              color: doctorhomeController.selectedIndex.value == 1
                  ? whiteColor
                  : doctorPrimaryColor,
            ),
            // Image.asset(
            //   AppIcons.recomendationsBottomIcon,
            //   height: 20,
            //   width: 20,
            //   color: doctorhomeController.selectedIndex.value == 2
            //       ? whiteColor
            //       : doctorPrimaryColor,
            // ),
            // Image.asset(
            //   AppIcons.paymentMenthodMainIcon,
            //   height: 20,
            //   width: 20,
            //   color: homeController.selectedIndex.value == 3
            //       ? whiteColor
            //       : primaryColor,
            // ),
            Image.asset(
              AppIcons.profileIcon,
              color: doctorhomeController.selectedIndex.value == 2
                  ? whiteColor
                  : doctorPrimaryColor,
              height: 20,
              width: 20,
            ),
          ],
          index: doctorhomeController.selectedIndex.value,
          onTap: (index) {
            doctorhomeController.changePage(index);
          },
        );
      }),
    );
  }
}
