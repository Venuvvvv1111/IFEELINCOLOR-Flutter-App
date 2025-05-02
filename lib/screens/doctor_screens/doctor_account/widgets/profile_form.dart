import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/account_controllers/get_doctor_profile_controller.dart';

import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/address_search_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/custom_permision.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/widgets/profile_image_pick.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class ProfileForm extends StatefulWidget {
  final GetDoctorProfileController controller;

  const ProfileForm({super.key, required this.controller});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late Permission permission;
  File? _image;
  final picker = ImagePicker();
  late ProfileImageDialog profileImageDialog;

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
      widget.controller.uploadImage(context, _image!);
    });
  }

  _galleryPicker() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      // ignore: unnecessary_this
      this._image = File(pickedFile!.path);
      widget.controller.uploadImage(context, _image!);
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
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQueryUtil.size(context).height * 0.07,
                  color: doctorPrimaryColor,
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQueryUtil.size(context).height * 0.07,
                      color: doctorPrimaryColor,
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
                                      widget.controller.nameEditController.value
                                          .text,
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
                                        print(widget
                                            .controller.profileImage?.value);
                                      }

                                      return Center(
                                        child: widget.controller.profileImage
                                                        ?.value !=
                                                    null ||
                                                widget.controller.profileImage
                                                        ?.value !=
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
                                                        "${widget.controller.profileImage?.value}",
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
                  controller: widget.controller.nameEditController.value,
                  focusNode: widget.controller.nameEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    label: const Text('Name'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter Name',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validateName(value ?? ''),
                  style: const TextStyle(
                    height: 1.2,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.controller.emailEditController.value,
                  focusNode: widget.controller.emailEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    label: const Text('Email'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter Email',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validateEmail(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widget.controller.mobileEditController.value,
                  focusNode: widget.controller.mobileEditFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    label: const Text('Mobile'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: whiteColor,
                    hintText: 'Enter Mobile',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      widget.controller.validateMobile(value ?? ''),
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
                      widget.controller.dobEditController.value.text =
                          "$pickedDate";
                      if (kDebugMode) {
                        print('$pickedDate');
                      }
                      widget.controller.dobDisplayController.value.text =
                          MediaQueryUtil.formatDateWithSuffix(pickedDate);
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: widget.controller.dobDisplayController.value,
                      focusNode: widget.controller.dobEditFocusNode,
                      decoration: InputDecoration(
                        label: const Text('DOB'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          widget.controller.validateDob(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    // Open the address search screen
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressSearchScreen(),
                      ),
                    );

                    // Update the controller and other variables after address selection
                    if (result != null) {
                      setState(() {
                        widget.controller.addressEditController.value.text =
                            result['address'];
                        widget.controller.updatedLatitude.value =
                            "${result['latitude']}"; // Store latitude
                        widget.controller.updatedLongitude.value =
                            "${result['longitude']}"; // Store longitude
                      });

                      if (kDebugMode) {
                        print('Selected Address: ${result['address']}');
                        print('Latitude: ${result['latitude']}');
                        print('Longitude: ${result['longitude']}');
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: widget.controller.addressEditController.value,
                      focusNode: widget.controller.addressEditFocusNode,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 10,
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        label: const Text('Address'),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter Address',
                        hintStyle: Theme.of(context).textTheme.labelLarge,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          widget.controller.validatePassword(value ?? ''),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQueryUtil.size(context).width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(1);
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   widget.controller.updateProfile(context);
                      // });
                    },
                    child: const Text(
                      'Next',
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
