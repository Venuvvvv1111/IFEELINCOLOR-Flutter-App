import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/modeling_tabs/color_weel/color_weel_screen.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class ModelingTabScreen extends StatefulWidget {
  const ModelingTabScreen({super.key});

  @override
  State<ModelingTabScreen> createState() => _ModelingTabScreenState();
}

class _ModelingTabScreenState extends State<ModelingTabScreen> {
  bool isAssesment = false;
  bool isBodyAssesment = false;
  @override
  void initState() {
    super.initState();
    getAssesmentData();
  }

  Future<void> getAssesmentData() async {
    final userData = GetStorage('user_data');

    isAssesment = userData.read('assesment') ?? false;
    isBodyAssesment = userData.read('bodyAssesment') ?? false;
    if (userData.read('assesment') == null ||
        userData.read('bodyAssesment') == null) {
      isAssesment = userData.read('assesment') ?? false;
      isBodyAssesment = userData.read('bodyAssesment') ?? false;
      setState(() {});
    } else {
      isAssesment = userData.read('assesment') ?? false;
      isBodyAssesment = userData.read('bodyAssesment') ?? false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("isAssesment");
      print(isAssesment);
      print("isBodyAssesment");
      print(isBodyAssesment);
    }

    return PopScope(
      canPop: false,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello! Welcome',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: whiteColor)),
                    Text(UserInfo().getUserName ?? 'Hi User',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: whiteColor)),
                  ],
                )
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
          ),
          body: ColorWheelScreen(
            isAssesment: isAssesment == true ? isAssesment : false,
            isBodyAssesment: isBodyAssesment == true ? isBodyAssesment : false,
          )),
    );
  }
}
