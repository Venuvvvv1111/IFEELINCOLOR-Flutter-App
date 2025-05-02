import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/address_search_screen.dart';
import 'package:ifeelin_color/utils/Route/app_Routes.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:intl/intl.dart';

import '../../../controllers/patient_controllers/registration_controller.dart';
import '../../../utils/medial_query_util/media_query_util.dart';
import '../../../utils/helpers/custom_colors.dart';

class RegistrationScreenView extends StatefulWidget {
  const RegistrationScreenView({super.key});

  @override
  RegistrationScreenViewState createState() => RegistrationScreenViewState();
}

class RegistrationScreenViewState extends State<RegistrationScreenView> {
  final RegistrationController controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppImages.loginBackground,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: MediaQueryUtil.size(context).height / 3.6,
                  width: MediaQueryUtil.size(context).width,
                  child: Image.asset(
                    AppImages.loginBackgroundColor,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding:
                    EdgeInsets.only(bottom: isKeyboardVisible ? 150.0 : 0.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 0,
                          ),
                          registerInputFeilds(context),
                          const SizedBox(
                            height: 20,
                          ),
                          goToSiginInFields(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget goToSiginInFields(BuildContext context) {
    return Column(
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
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      onPressed: () {
                        MyToast.showGetToast(
                            title: 'Error',
                            message:
                                'Oops! Facebook registration is not available at the moment.',
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
                icon: const Icon(Icons.email, color: Colors.white),
                onPressed: () {
                  signInWithGoogle(context);
                  // Handle Google login
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: 'Sign in',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    FocusScope.of(context).unfocus();
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.loginScreen, (route) => false);
                    // Handle sign in tap
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget registerInputFeilds(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppIcons.textLogo),
        const SizedBox(height: 10),
        Container(
          color: whiteColor,
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: buildCard('Patient', AppImages.loginPatientImage),
                    ), // Replace with actual image path
                    Flexible(
                      child: buildCard('Doctor', AppImages.loginDoctorImage),
                    ), // Replace with actual image path
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Name',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => controller.validateName(value ?? ''),
                  style: const TextStyle(
                    height: 1.2,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Email',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => controller.validateEmail(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.mobileController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Mobile',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => controller.validateMobile(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      controller.dobController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      if (kDebugMode) {
                        print(controller.dobController.text);
                      }
                      controller.calculateAge(pickedDate);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: controller.dobController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: 'Date of Birth',
                        hintStyle: Theme.of(context).textTheme.labelLarge,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => controller.validateDob(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(() {
                  return controller.isGuardianFieldVisible.value
                      ? Column(
                          children: [
                            TextFormField(
                              controller: controller.guardianNameController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 10,
                                ),
                                filled: true,
                                fillColor: whiteColor,
                                hintText: 'Guardian Name',
                                hintStyle:
                                    Theme.of(context).textTheme.labelLarge,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  controller.validateGuardianName(value ?? ''),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                }),
                Obx(() {
                  return SizedBox(
                      height:
                          controller.isGuardianFieldVisible.value ? 16.0 : 0);
                }),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      controller.validatePassword(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.confirmPasswordController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Confirm Password',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      controller.validateConfirmPassword(value ?? ''),
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () async {
                    // Open address search screen
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressSearchScreen(),
                      ),
                    );

                    if (result != null) {
                      // If an address is selected, update the address and store latitude & longitude
                      controller.addressController.value.text =
                          result['address'];
                      controller.updatedLatitude.value =
                          "${result['latitude']}";
                      controller.updatedLongitude.value =
                          "${result['longitude']}";

                      if (kDebugMode) {
                        print('Selected Address: ${result['address']}');
                        print('Latitude: ${result['latitude']}');
                        print('Longitude: ${result['longitude']}');
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: controller.addressController.value,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: 'Address',
                        hintStyle: Theme.of(context).textTheme.labelLarge,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                controller.selectedCard!.value == "Doctor"
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(),
                controller.selectedCard!.value == "Doctor"
                    ? TextFormField(
                        controller: controller.licenseController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 10,
                          ),
                          filled: true,
                          fillColor: whiteColor,
                          hintText: 'License Number',
                          hintStyle: Theme.of(context).textTheme.labelLarge,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            controller.validateMobile(value ?? ''),
                      )
                    : const SizedBox(),
                controller.selectedCard!.value == "Doctor"
                    ? const SizedBox(height: 10)
                    : const SizedBox(),
                controller.selectedCard!.value == "Doctor"
                    ? const Text('Upload Doctor License* :')
                    : const SizedBox(),
                controller.selectedCard!.value == "Doctor"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Front Image Button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 4,
                                color: whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Show front image if selected, otherwise show "+" icon
                                      controller.frontLicenseImage.value != null
                                          ? GestureDetector(
                                              onTap: () => controller.pickImage(
                                                  true), // Open image picker again
                                              child: AspectRatio(
                                                aspectRatio:
                                                    1, // Maintain aspect ratio
                                                child: Image.file(
                                                  controller
                                                      .frontLicenseImage.value!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () =>
                                                  controller.pickImage(
                                                      true), // Open image picker
                                              icon: const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.blue,
                                              ),
                                            ),
                                      const SizedBox(height: 8),
                                      const Text("Front License"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Back Image Button
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: whiteColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Show back image if selected, otherwise show "+" icon
                                      controller.backLicenseImage.value != null
                                          ? GestureDetector(
                                              onTap: () => controller.pickImage(
                                                  false), // Open image picker again
                                              child: AspectRatio(
                                                aspectRatio:
                                                    1, // Maintain aspect ratio
                                                child: Image.file(
                                                  controller
                                                      .backLicenseImage.value!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () =>
                                                  controller.pickImage(
                                                      false), // Open image picker
                                              icon: const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.blue,
                                              ),
                                            ),
                                      const SizedBox(height: 8),
                                      const Text("Back License"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

                // Display selected images
                // controller.selectedCard!.value == "Doctor"
                //     ? Obx(() {
                //         return Column(
                //           children: [
                //             controller.frontLicenseImage.value != null
                //                 ? Image.file(
                //                     controller.frontLicenseImage.value!)
                //                 : Text('No Front Image Selected'),
                //             SizedBox(height: 8),
                //             controller.backLicenseImage.value != null
                //                 ? Image.file(controller.backLicenseImage.value!)
                //                 : Text('No Back Image Selected'),
                //           ],
                //         );
                //       })
                //     : SizedBox(),

                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isChecked1.value,
                          onChanged: controller.onTermsAndConditionsChanged,
                        )),
                    const SizedBox(
                        width:
                            2), // Adjust this value to control the space between checkbox and text
                    const Text('I agree with terms and conditions'),
                  ],
                ),
                Obx(() {
                  return SizedBox(
                    width: MediaQueryUtil.size(context).width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isChecked1.value
                              ? primaryColor
                              : disabledButtonColor),
                      onPressed: () {
                        if (!mounted) {
                          return;
                        }
                        if (controller.selectedCard!.value == "Patient") {
                          controller.register(
                            context,
                            false,
                            '',
                            '',
                            '',
                          );
                        } else if (controller.selectedCard!.value == "Doctor") {
                          controller.doctorRegister(
                              context,
                              false,
                              '',
                              '',
                              '',
                              controller.frontLicenseImage.value,
                              controller.backLicenseImage.value);
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
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: controller.isChecked1.value
                                ? whiteColor
                                : primaryColor),
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ),
      ],
    );
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isAndroid
        ? '7093278234-mdp7jpvool8baiqiobf7tf4a8agnpu2o.apps.googleusercontent.com'
        : "7093278234-v47g69ugtmdppjfjfl55k1kq10jrvku3.apps.googleusercontent.com",
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  Future<void> signInWithGoogle(context) async {
    if (controller.selectedCard!.value == "Patient") {
      try {
        await _googleSignIn.signOut();
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          if (kDebugMode) {
            print('User ID: ${googleUser.id}');
          }

          if (kDebugMode) {
            print('Photo URL: ${googleUser.photoUrl}');
          }
          controller.register(
            context,
            true,
            googleUser.email,
            "${googleUser.displayName}",
            "${googleUser.displayName}",
          );
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
    } else if (controller.selectedCard!.value != "Patient") {
      MyToast.showGetToast(
          title: 'Error',
          message: 'Please select valid role',
          backgroundColor: Colors.red,
          color: Colors.white);
    } else {
      MyToast.showGetToast(
          title: 'Error',
          message: 'Google registration failed try again',
          backgroundColor: Colors.red,
          color: Colors.white);
    }
  }
}
