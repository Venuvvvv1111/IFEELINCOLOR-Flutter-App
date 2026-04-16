import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/route/app_routes.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';

class SplashScreen extends StatefulWidget {
  static String tag = 'splash-screen';

  const SplashScreen({
    super.key,
  });

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  void showTtsSelectionDialog(BuildContext context) {
    final userInfo = Get.find<UserInfo>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("Choose Mode"),
          content: Text("Do you want to use voice assistance?"),
          actions: [
            TextButton(
              onPressed: () {
                userInfo.setTtsEnabled = false;
                Navigator.pop(context);
              },
              child: Text("Text Only"),
            ),
            ElevatedButton(
              onPressed: () {
                userInfo.setTtsEnabled = true;
                Navigator.pop(context);
              },
              child: Text("Enable Voice"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final userInfo = Get.find<UserInfo>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!userInfo.isTtsEnabled.value) {
        showTtsSelectionDialog(context);
      }
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      GetStorage box = GetStorage();
      if (box.read('isLogin') == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.mainScreenTabs, (route) => false);
      } else if (box.read('isDoctorLogin') == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.doctorMainTabsScreen, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginScreen, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              AppImages.loginBackground,
              fit: BoxFit.cover,
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    AppIcons.textLogo,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
