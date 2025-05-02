import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifeelin_color/controllers/patient_controllers/get_profile_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:readmore/readmore.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final getProfileController = Get.put(GetProfileController());
  @override
  void dispose() {
    super.dispose();
    Get.delete<GetProfileController>();
  }

  @override
  void initState() {
    getProfileController.fetchGetProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.profileEditScreen,
                arguments: getProfileController.getProfileModel,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image(image: AssetImage(AppIcons.editIcon)),
            ),
          )
        ],
      ),
      body: Obx(() {
        return getProfileController.isLoading.value
            ? Center(
                child: LoaderHelper.lottiWidget(),
              )
            : Padding(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getProfileController.getProfileModel
                                                    ?.body?.userName
                                                    .toString() ??
                                                '-------',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 5),
                                                  decoration: BoxDecoration(
                                                    color: phoneBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        AppIcons.userPhoneIcon,
                                                        height: 17,
                                                        width: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                            getProfileController
                                                                    .getProfileModel
                                                                    ?.body
                                                                    ?.mobile ??
                                                                '--------',
                                                            minFontSize: 8,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        phoneForegroundColor)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 5),
                                                  decoration: BoxDecoration(
                                                    color: emailBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        AppIcons.userMailIcon,
                                                        height: 17,
                                                        width: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                            getProfileController
                                                                    .getProfileModel
                                                                    ?.body
                                                                    ?.email ??
                                                                '--------',
                                                            minFontSize: 8,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      emailForegroundColor,
                                                                )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 5),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        calenderBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        AppIcons.calenderIcon,
                                                        height: 17,
                                                        width: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                            getProfileController
                                                                        .getProfileModel
                                                                        ?.body
                                                                        ?.dateOfBirth !=
                                                                    null
                                                                ? 'DOB : ${MediaQueryUtil().formatPatientDate(getProfileController.getProfileModel?.body?.dateOfBirth)}'
                                                                : 'DOB :------',
                                                            minFontSize: 8,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        calenderForegroundColor)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 5, 5),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        locationBackgoundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        AppIcons
                                                            .userLocationIcon,
                                                        height: 17,
                                                        width: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                            getProfileController
                                                                    .getProfileModel
                                                                    ?.body
                                                                    ?.location ??
                                                                '-------',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 8,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelSmall!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      locationForegroundColor,
                                                                )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -45,
                                  child: ClipOval(
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: const BoxDecoration(
                                        color: whiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: LoadNetworkImage(
                                        "${getProfileController.profileImage?.value}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: MediaQueryUtil.size(context).width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: primaryColorLight,
                                    child: Icon(
                                      Icons.location_history,
                                      color: primaryColor,
                                      size: 40,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      ReadMoreText(
                                        getProfileController.getProfileModel
                                                ?.body?.location ??
                                            '-----------',
                                        trimLines: 5,
                                        // colorClickableText: Colors.white,
                                        colorClickableText: Colors.black,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '   Read more..',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        trimExpandedText: '    Read less..',
                                        moreStyle: const TextStyle(
                                            color: newIdentitiyPrimaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                        lessStyle: const TextStyle(
                                            color: newIdentitiyPrimaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      getProfileController
                                  .getProfileModel?.body?.address?.latitude !=
                              null
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  child: GoogleMap(
                                    scrollGesturesEnabled: true,
                                    mapType: MapType.normal,
                                    myLocationButtonEnabled: true,
                                    myLocationEnabled: true,
                                    zoomControlsEnabled: true,
                                    compassEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          getProfileController.getProfileModel!
                                              .body!.address!.latitude!,
                                          getProfileController.getProfileModel!
                                              .body!.address!.longitude!),
                                      zoom: 16.0,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId:
                                            const MarkerId("initialLocation"),
                                        position: LatLng(
                                            getProfileController
                                                .getProfileModel!
                                                .body!
                                                .address!
                                                .latitude!,
                                            getProfileController
                                                .getProfileModel!
                                                .body!
                                                .address!
                                                .longitude!),
                                        infoWindow: InfoWindow(
                                          title: "Your Location",
                                          snippet:
                                              "${getProfileController.getProfileModel?.body?.location}",
                                        ),
                                      ),
                                    },
                                    onMapCreated: (controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
