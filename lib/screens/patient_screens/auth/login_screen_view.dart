import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifeelin_color/utils/Route/app_Routes.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';

import '../../../controllers/patient_controllers/login_controller.dart';
import '../../../utils/medial_query_util/media_query_util.dart';
import '../../../utils/helpers/custom_colors.dart';

List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/images/login_background_image2.svg",
                fit: BoxFit.fill,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: Obx(() {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Column(
                            children: [
                              Image.asset(AppIcons.textLogo),
                              const SizedBox(height: 20),
                              Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: buildCard(
                                        'Patient', AppImages.loginPatientImage),
                                  ), // Replace with actual image path
                                  Flexible(
                                    child: buildCard(
                                        'Doctor', AppImages.loginDoctorImage),
                                  ), // Replace with actual image path
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 10,
                                  ),
                                  filled: true,
                                  fillColor: whiteColor,
                                  hintText: 'Username/Email',
                                  hintStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  border: InputBorder.none,
                                ),
                                validator: (value) =>
                                    controller.validateEmail(value ?? ''),
                                style: const TextStyle(
                                  height: 1.2,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: controller.passwordController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 10,
                                    ),
                                    filled: true,
                                    fillColor: whiteColor,
                                    hintText: 'password',
                                    hintStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                    border: InputBorder.none,
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          if (controller
                                              .isPasswordVisible.value) {
                                            controller.isPasswordVisible.value =
                                                false;
                                          } else {
                                            controller.isPasswordVisible.value =
                                                true;
                                          }
                                        },
                                        child: Icon(
                                            controller.isPasswordVisible.value
                                                ? Icons.visibility_off
                                                : Icons.visibility))),
                                obscureText: controller.isPasswordVisible.value,
                                validator: (value) =>
                                    controller.validatePassword(value ?? ''),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Obx(() => Checkbox(
                                            activeColor: primaryColor,
                                            value: controller.rememberMe.value,
                                            onChanged:
                                                controller.onRememberMeChanged,
                                          )),
                                      const Text('Remember me'),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.selectedCard!.value ==
                                          "Patient") {
                                        controller.onForgetPassword(context);
                                      } else if (controller
                                              .selectedCard!.value ==
                                          "Doctor") {
                                        controller
                                            .onDoctorForgetPassword(context);
                                      } else if (controller
                                              .selectedCard!.value ==
                                          "Organization") {
                                        MyToast.showGetToast(
                                            title: 'Error',
                                            message: 'Invalid role',
                                            color: Colors.white,
                                            backgroundColor: Colors.red);
                                      } else {
                                        MyToast.showGetToast(
                                            title: 'Error',
                                            message: 'Please select your role',
                                            color: Colors.white,
                                            backgroundColor: Colors.red);
                                      }
                                    },
                                    child: Text(
                                      "Forget Password?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: newIdentitiyPrimaryColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              SizedBox(
                                width: MediaQueryUtil.size(context).width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.selectedCard!.value ==
                                        "Patient") {
                                      controller.login(context, false, "", "");
                                    } else if (controller.selectedCard!.value ==
                                        "Doctor") {
                                      controller.doctorLogin(context);
                                    } else if (controller.selectedCard!.value ==
                                        "Organization") {
                                      MyToast.showGetToast(
                                          title: 'Error',
                                          message: 'Invalid role',
                                          color: Colors.white,
                                          backgroundColor: Colors.red);
                                    } else {
                                      MyToast.showGetToast(
                                          title: 'Error',
                                          message: 'Please select your role',
                                          color: Colors.white,
                                          backgroundColor: Colors.red);
                                    }
                                    // controller.doctorLogin(context);
                                    // Navigator.pushNamed(
                                    //     context, AppRoutes.mainScreenTabs);
                                  },
                                  child: const Text('Sign in'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(),
                          Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  const Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      endIndent: 10,
                                      indent: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "or with",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: whiteColor),
                                  ),
                                  const Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Platform.isAndroid
                                      ? CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: IconButton(
                                            icon: const Icon(Icons.facebook,
                                                color: Colors.white),
                                            onPressed: () {
                                              MyToast.showGetToast(
                                                  title: 'Error',
                                                  message:
                                                      'Oops! Facebook login is not available at the moment.',
                                                  backgroundColor: Colors.red,
                                                  color: Colors.white);
                                              // Handle Facebook login
                                            },
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(width: 16.0),
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: IconButton(
                                      icon: const Icon(Icons.email,
                                          color: Colors.white),
                                      onPressed: () {
                                        if (kDebugMode) {
                                          print('hii');
                                        }
                                        signInWithGoogle(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              RichText(
                                text: TextSpan(
                                  text: "Don't you have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.white),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Sign up',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(context,
                                              AppRoutes.registerScreen);

                                          if (kDebugMode) {
                                            print("Sign up tapped");
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isAndroid
        ? '7093278234-mdp7jpvool8baiqiobf7tf4a8agnpu2o.apps.googleusercontent.com'
        : "7093278234-v47g69ugtmdppjfjfl55k1kq10jrvku3.apps.googleusercontent.com",
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  Future<void> signInWithGoogle(context) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        if (kDebugMode) {
          print('User ID: ${googleUser.id}');
          print('Name: ${googleUser.displayName}');
          print('Photo URL: ${googleUser.photoUrl}');
          print('Email: ${googleUser.email}');
        }

        if (controller.selectedCard!.value == "Patient") {
          controller.login(
              context, true, googleUser.email, "${googleUser.displayName}");
        } else if (controller.selectedCard!.value == "Doctor") {
          MyToast.showGetToast(
              title: 'Error',
              message: 'Google Sign-In Failed',
              backgroundColor: Colors.red,
              color: Colors.white);
        } else if (controller.selectedCard!.value == "Organization") {
          MyToast.showGetToast(
              title: 'Error',
              message: 'Invalid role',
              color: Colors.white,
              backgroundColor: Colors.red);
        } else {
          MyToast.showGetToast(
              title: 'Error',
              message: 'Please select your role',
              color: Colors.white,
              backgroundColor: Colors.red);
        }
        // controller.doctorLogin(context);
        // Navigator.pushNamed(
        //     context, AppRoutes.mainScreenTabs);
      } else {
        if (kDebugMode) {
          print('Sign-In canceled by the user.');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Google Sign-In failed: $error');
      }
    }
  }

  Widget buildCard(String title, String imagePath) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.03;

    return GestureDetector(
      onTap: () {
        controller.selectCard(title); // Update the selected card
      },
      child: Obx(() {
        bool isSelected =
            controller.selectedCard!.value == title; // Check selection
        return Card(
          shape: isSelected
              ? RoundedRectangleBorder(
                  side: const BorderSide(color: primaryColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0))
              : RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0)),
          color: whiteColor,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width > 600 ? 200 : 100,
            height: MediaQuery.of(context).size.width > 600 ? 200 : 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: textSize,
                    color: isSelected ? primaryColor : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
