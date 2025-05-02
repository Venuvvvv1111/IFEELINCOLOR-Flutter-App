import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/get_profile_controller.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/address_search_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/custom_permision.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/profile_image_pick.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/patient_models/get_profile_model.dart';

class ProfileEditScreen extends StatefulWidget {
  final GetProfileModel getProfileModel;
  const ProfileEditScreen({required this.getProfileModel, super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  GetProfileController getProfileController = Get.put(GetProfileController());
  // final _formKey = GlobalKey<FormState>();

  late Permission permission;
  File? _image;
  final picker = ImagePicker();
  late ProfileImageDialog profileImageDialog;

  // _displaySuccessDialog(BuildContext context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) => CustomDialog(
  //         messageIcon: FontAwesomeIcons.check,
  //         title: 'Success',
  //         backgroundColor: kGreen,
  //         description: 'Profile Updated Successfully',
  //         buttonText: "View Account",
  //         onButtonPress: () {
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => TabsPage()),
  //             (route) => false,
  //           );
  //         },
  //       ),
  //     );
  //   });
  // }

  // _displayErrorDialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) => CustomDialog(
  //       messageIcon: FontAwesomeIcons.times,
  //       title: 'Error',
  //       backgroundColor: kRed,
  //       description: 'Error updating profile',
  //       buttonText: "Try Again",
  //       onButtonPress: () => Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => TabsPage()),
  //       ),
  //     ),
  //   );
  // }

  _onAddPhotoClicked(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProfileImageDialog(
        messageIcon: Icons.person,
        title: 'Select Profile Image',
        backgroundColor: Colors.black,
        buttonText: "Close",
        onButtonPress: () => Navigator.pop(context),
        onCameraPress: () {
          _onAddImageFromCamera(context);
          Navigator.pop(context);
        },
        onPhotoLibraryPress: () {
          _onAddImageFromGallery();
          Navigator.pop(context);
        },
      ),
    );
  }

  _showOpenCameraAppSettingsDialog(context) {
    return CustomPermissionDialog.show(
      context,
      kCameraPermission,
      Platform.isAndroid
          ? kCameraPermissionDescription
          : kCameraPermissionDescriptionIos,
      'Settings',
      openAppSettings,
    );
  }

  _onAddImageFromGallery() async {
    _photoPicker();
    // final result = await Permission.storage.request();

    // print(result);
    // if (result.isDenied) {
    //   _showOpenLibraryAppSettingsDialog(context);
    // } else if (result.isGranted) {

    // } else {
    //   _showOpenLibraryAppSettingsDialog(context);
    // }
  }

  _onAddImageFromCamera(context) async {
    permission = Permission.camera;
    var result = await permission.status;
    if (kDebugMode) {
      print(result);
    }
    if (result.isDenied) {
      var res = await permission.request();

      if (res.isPermanentlyDenied) {
        _showOpenCameraAppSettingsDialog(context);
      } else if (res.isGranted) {
        _galleryPicker();
      }
    } else if (result.isGranted) {
      _galleryPicker();
    } else {
      _showOpenCameraAppSettingsDialog(context);
    }
  }

  Future<void> _photoPicker() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      getProfileController.uploadImage(context, _image!);
    });
  }

  _galleryPicker() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      // ignore: unnecessary_this
      this._image = File(pickedFile!.path);
      getProfileController.uploadImage(context, _image!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
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
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: whiteColor,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQueryUtil.size(context).height * 0.07,
                  color: primaryColor,
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQueryUtil.size(context).height * 0.07,
                      color: primaryColor,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              width: MediaQueryUtil.size(context).width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 60 + 5,
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      getProfileController
                                          .nameEditController.value.text,
                                      style: const TextStyle(
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
                          Positioned(
                            top: -45,
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _onAddPhotoClicked(context),
                                    child: Obx(() {
                                      if (kDebugMode) {
                                        print(getProfileController
                                            .profileImage?.value);
                                      }

                                      return Center(
                                        child: getProfileController
                                                        .profileImage?.value !=
                                                    null ||
                                                getProfileController
                                                        .profileImage?.value !=
                                                    ''
                                            ? Stack(
                                                children: [
                                                  Container(
                                                    height: 110.0,
                                                    width: 110.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color:
                                                              emailForegroundColor,
                                                          width: 3.0),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  80.0)),
                                                    ),
                                                    child: ClipOval(
                                                      child: LoadNetworkImage(
                                                        "${getProfileController.profileImage?.value}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: CircleAvatar(
                                                          radius: 15,
                                                          child:
                                                              Icon(Icons.edit)))
                                                ],
                                              )
                                            : (_image == null)
                                                ? Stack(
                                                    children: [
                                                      Container(
                                                        height: 110.0,
                                                        width: 110.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: whiteColor,
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                AppImages
                                                                    .profileStaticImage),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          border: Border.all(
                                                              color:
                                                                  newIdentitiyPrimaryColor,
                                                              width: 2.0),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          80.0)),
                                                        ),
                                                      ),
                                                      const Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child: CircleAvatar(
                                                            radius: 15,
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ))
                                                    ],
                                                  )
                                                : (_image != null)
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            height: 110.0,
                                                            width: 110.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              image:
                                                                  DecorationImage(
                                                                image: FileImage(
                                                                    _image!),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              border: Border.all(
                                                                  color:
                                                                      emailForegroundColor,
                                                                  width: 3.0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          80.0)),
                                                            ),
                                                          ),
                                                          const Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              child: CircleAvatar(
                                                                  radius: 15,
                                                                  child: Icon(
                                                                      Icons
                                                                          .edit)))
                                                        ],
                                                      )
                                                    : Stack(
                                                        children: [
                                                          Container(
                                                            height: 110.0,
                                                            width: 110.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: whiteColor,
                                                              image:
                                                                  const DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                        ''),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              border: Border.all(
                                                                  color:
                                                                      newIdentitiyPrimaryColor,
                                                                  width: 5.0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          80.0)),
                                                            ),
                                                          ),
                                                          const Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color:
                                                                    primaryColor,
                                                              ))
                                                        ],
                                                      ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: getProfileController.nameEditController.value,
                  focusNode: getProfileController.nameEditFocusNode,
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
                  validator: (value) =>
                      getProfileController.validateName(value ?? ''),
                  style: const TextStyle(
                    height: 1.2,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: getProfileController.emailEditController.value,
                  focusNode: getProfileController.emailEditFocusNode,
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
                  validator: (value) =>
                      getProfileController.validateEmail(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: getProfileController.mobileEditController.value,
                  focusNode: getProfileController.mobileEditFocusNode,
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
                  validator: (value) =>
                      getProfileController.validateMobile(value ?? ''),
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
                      getProfileController.dobEditController.value.text =
                          "$pickedDate";
                      if (kDebugMode) {
                        print('$pickedDate');
                      }
                      getProfileController.dobDisplayController.text =
                          MediaQueryUtil.formatDateWithSuffix(pickedDate);
                      getProfileController.calculateAge(pickedDate);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: getProfileController.dobDisplayController,
                      focusNode: getProfileController.dobEditFocusNode,
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
                      validator: (value) =>
                          getProfileController.validateDob(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(() {
                  return getProfileController.isGuardianFieldVisible.value
                      ? Column(
                          children: [
                            TextFormField(
                              controller: getProfileController
                                  .guardianNameEditController.value,
                              focusNode: getProfileController
                                  .guardianNameEditFocusNode,
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
                              validator: (value) => getProfileController
                                  .validateGuardianName(value ?? ''),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                }),
                Obx(() {
                  return SizedBox(
                      height: getProfileController.isGuardianFieldVisible.value
                          ? 16.0
                          : 0);
                }),
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
                      getProfileController.addressEditController.value.text =
                          result['address'];
                      getProfileController.updatedLatitude.value =
                          "${result['latitude']}";
                      getProfileController.updatedLongitude.value =
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
                      controller:
                          getProfileController.addressEditController.value,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () async {
                //     // Open address search
                //     var result = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AddressSearchScreen(),
                //       ),
                //     );

                //     if (result != null) {
                //       getProfileController.addressEditController.value.text =
                //           result['address'];
                //       print('Selected Address: ${result['address']}');
                //       print('Latitude: ${result['latitude']}');
                //       print('Longitude: ${result['longitude']}');
                //     }
                //   },
                //   child: IgnorePointer(
                //     child: TextFormField(
                //       controller:
                //           getProfileController.addressEditController.value,
                //       focusNode: getProfileController.addressEditFocusNode,
                //       decoration: InputDecoration(
                //         contentPadding: EdgeInsets.symmetric(
                //           vertical: 13,
                //           horizontal: 10,
                //         ),
                //         filled: true,
                //         fillColor: whiteColor,
                //         hintText: 'Search Address',
                //         hintStyle: Theme.of(context).textTheme.labelLarge,
                //         border: OutlineInputBorder(),
                //       ),
                //       validator: (value) =>
                //           getProfileController.validatePassword(value ?? ''),
                //     ),
                //   ),
                // ),
                // TextFormField(
                //   controller: getProfileController.addressEditController.value,
                //   focusNode: getProfileController.addressEditFocusNode,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(
                //       vertical: 13,
                //       horizontal: 10,
                //     ),
                //     filled: true,
                //     fillColor: whiteColor,
                //     hintText: 'Address',
                //     hintStyle: Theme.of(context).textTheme.labelLarge,
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQueryUtil.size(context).width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        getProfileController.updateProfile(context);
                      });
                    },
                    child: const Text(
                      'Update',
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
