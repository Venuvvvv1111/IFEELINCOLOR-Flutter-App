import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/recomendations/clinicist_recomendation.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/recomendations/portal_recomendation.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../../controllers/patient_controllers/home_controller.dart';

class RecomendationScreenView extends StatelessWidget {
  RecomendationScreenView({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            elevation: 0,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profileDetailScreen);
                  },
                  child: CircleAvatar(
                    backgroundColor: whiteColor,
                    child: ClipOval(
                      child: LoadNetworkImage(
                        UserInfo().getUserProfileUrl,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('Recomendations',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: whiteColor))
              ],
            ),
            actions: [
              CircleAvatar(
                backgroundColor: whiteColor,
                child: IconButton(
                  icon: Image(image: AssetImage(AppIcons.notificationIcon)),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.allNotificationsScreen);
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0), // Adjust as needed
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.white, // Main container color
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: TabBar(
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 7),
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                    color: newIdentitiyPrimaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.white,
                  labelPadding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Tab(
                          iconMargin: EdgeInsets.zero,
                          child: Text('Clinicist',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Tab(
                          iconMargin: EdgeInsets.zero,
                          child: Text('Portal',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: const Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ClinicistRecomendationScreen(),
                    PortalRecomendationScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
