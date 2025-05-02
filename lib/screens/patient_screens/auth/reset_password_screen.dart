import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/auth_controllers/reset_password_controller.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());
  final UserInfo _userInfo = Get.put(UserInfo());
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<ResetPasswordController>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(AppImages.loginBackground), fit: BoxFit.cover),
        // gradient: LinearGradient(
        //   colors: [
        //     primaryColorDark,
        //     primaryColorLight,
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_sharp,
                        )),
                    Text(
                      'Reset Password',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(),
                    ),
                    const SizedBox()
                  ],
                ),
                const SizedBox(height: 50),
                Image.asset(
                  AppIcons.chnagePasswordIcon,
                  color: primaryColor,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return TextFormField(
                    controller: controller.currentPasswordController.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 10,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'Current Password',
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      border: InputBorder.none,
                    ),
                    // validator: (value) =>
                    //     controller.(value ?? ''),
                    style: const TextStyle(
                      height: 1.2,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  return TextFormField(
                    controller: controller.newPasswordController.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 10,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'New password',
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      border: InputBorder.none,
                    ),
                    validator: (value) =>
                        controller.validatePassword(value ?? ''),
                    style: const TextStyle(
                      height: 1.2,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  return TextFormField(
                    controller: controller.confirmPasswordController.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 10,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'Conform password',
                      hintStyle: Theme.of(context).textTheme.labelLarge,
                      border: InputBorder.none,
                    ),
                    validator: (value) =>
                        controller.validatePassword(value ?? ''),
                    style: const TextStyle(
                      height: 1.2,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  );
                }),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (controller.newPasswordController.value.text ==
                        controller.confirmPasswordController.value.text) {
                      controller.resetPassword(
                          context, _userInfo.getUserLogin ? false : true);
                    } else {
                      Get.snackbar('Error', 'Conform password not matched');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 10),
                    textStyle: const TextStyle(fontSize: 14),
                    backgroundColor: primaryColor,
                  ),
                  child: const Text("Update Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
