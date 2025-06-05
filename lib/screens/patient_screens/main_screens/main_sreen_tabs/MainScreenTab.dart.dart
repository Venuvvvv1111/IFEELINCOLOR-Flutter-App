import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../../controllers/patient_controllers/home_controller.dart';
import '../account_management/account_management_screen.dart';
import '../home_screens/hom_screen_view.dart';
import '../mood_info_screens/mood_info_screen.dart';

import '../recomendations/recomendation_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen>
    with WidgetsBindingObserver {
  final HomeController homeController = Get.put(HomeController());
  final UserInfo userController = Get.put(UserInfo());

  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); 
         
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
      userController.refreshData();
      // This will refresh the state when the user navigates back to this screen
      homeController.changePage(homeController.selectedIndex.value);
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
          index: homeController.selectedIndex.value,
          children: [
            const MoodInfoScreenView(),
            const HomeSreenView(),

            RecomendationScreenView(),
            // RazorPaymentScreen(),
            const SettingsScreen()
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return CurvedNavigationBar(
          backgroundColor: primaryColorLight,
          buttonBackgroundColor: primaryColorDark.withValues(alpha: 0.5),
          color: whiteColor,
          animationDuration: const Duration(milliseconds: 400),
          height: 55,
          items: <Widget>[
            Image.asset(
              AppIcons.moodInfoBottomIcon,
              height: 20,
              width: 20,
              color: homeController.selectedIndex.value == 0
                  ? whiteColor
                  : primaryColor,
            ),

            Image.asset(
              AppIcons.homeBottomIcon,
              height: 20,
              width: 20,
              color: homeController.selectedIndex.value == 1
                  ? whiteColor
                  : primaryColor,
            ),
            Image.asset(
              AppIcons.recomendationsBottomIcon,
              height: 20,
              width: 20,
              color: homeController.selectedIndex.value == 2
                  ? whiteColor
                  : primaryColor,
            ),
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
              color: homeController.selectedIndex.value == 3
                  ? whiteColor
                  : primaryColor,
              height: 20,
              width: 20,
            ),
          ],
          index: homeController.selectedIndex.value,
          onTap: (index) {
            homeController.changePage(index);
          },
        );
      }),
    );
  }
}
