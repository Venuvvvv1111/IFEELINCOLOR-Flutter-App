import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/common_controllers/check_portal_subscroption.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/home_controllers/doctor_home_controller.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class NearestPatients extends StatefulWidget {
  const NearestPatients({super.key});

  @override
  State<NearestPatients> createState() => _NearestPatientsState();
}

class _NearestPatientsState extends State<NearestPatients> {
  final DoctorHomeController allPatientsController =
      Get.put(DoctorHomeController());
  final subscriptionController = Get.put(CheckPortalController());
  @override
  void initState() {
    super.initState();
    allPatientsController.checkAndRequestLocationPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allPatientsController.fetchNearbyPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: doctorPrimaryColor,
      backgroundColor: whiteColor,
      strokeWidth: 3.0,
      onRefresh: () {
        return allPatientsController.fetchNearbyPatients();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              // controller: homeController.searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 10,
                  ),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: 'Find nearest patients',
                  hintStyle: Theme.of(context).textTheme.labelLarge,
                  border: InputBorder.none),
              onChanged: (query) {
                // homeController.filterDoctors(query);
              },
              style: const TextStyle(
                height: 1.2,
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          Expanded(child: Obx(() {
            if (allPatientsController.isLoading.value) {
              return Center(child: LoaderHelper.lottiWidget());
            }

            if (allPatientsController.filteredNearbyPatients.isEmpty) {
              return const Center(child: Text('No Patients found.'));
            }

            return ListView.builder(
              itemCount: allPatientsController.filteredNearbyPatients.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              itemBuilder: (context, index) {
                final patient =
                    allPatientsController.filteredNearbyPatients[index];
                return Card(
                  elevation: 5,
                  color: whiteColor,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 100,
                            width: 100,
                            child: LoadNetworkImage(
                              '${patient.patient?.image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${patient.patient?.userName}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            AppIcons.userLocationIcon),
                                        height: 17,
                                        width: 17,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${patient.patient?.location}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: secondaryFontColor,
                                                  fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle,
                                          size: 18, color: greenColor),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Recomendations sent',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: greenColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration:
                            const BoxDecoration(color: doctorPrimaryColorLight),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.max, // Ensure it takes full width
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // Allow each column to take available space
                              child: InkWell(
                                onTap: () async {
                                  await subscriptionController
                                      .checkDoctorPortalSubscription();

                                  if (subscriptionController
                                      .hasActiveSubscription.value) {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    Navigator.pushNamed(context,
                                        AppRoutes.patientIntakeDetailsScreen,
                                        arguments: allPatientsController
                                            .subscribedPatientsModel
                                            ?.body?[index]
                                            .patient
                                            ?.sId);
                                  } else {
                                    MyToast.showGetToast(
                                      title: 'Error',
                                      message:
                                          'Please subscribe to the portal in settings before accessing this feature',
                                      color: whiteColor,
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.intakeImage,
                                      height: 22,
                                      width: 22,
                                    ),
                                    const Text(
                                      'Intake Details',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, color: doctorTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.pushNamed(
                            //         context,
                            //         AppRoutes.doctorAllRecomendations,
                            //         arguments: allPatientsController
                            //             .subscribedPatientsModel
                            //             ?.body?[index]
                            //             .patient,
                            //       );
                            //     },
                            //     child: Column(
                            //       children: [
                            //         Image.asset(
                            //           AppImages.viewRecomendationImage,
                            //           height: 22,
                            //           width: 22,
                            //         ),
                            //         Text(
                            //           'Recomendations',
                            //           maxLines: 1,
                            //           overflow: TextOverflow.ellipsis,
                            //           style: TextStyle(
                            //               fontSize: 12, color: doctorTextColor),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await subscriptionController
                                      .checkDoctorPortalSubscription();

                                  if (subscriptionController
                                      .hasActiveSubscription.value) {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.doctorAllRecomendations,
                                      arguments: allPatientsController
                                          .subscribedPatientsModel
                                          ?.body?[index]
                                          .patient,
                                    );
                                  } else {
                                    MyToast.showGetToast(
                                      title: 'Error',
                                      message:
                                          'Please subscribe to the portal in settings before accessing this feature',
                                      color: whiteColor,
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.addRecomendationImage,
                                      height: 22,
                                      width: 22,
                                    ),
                                    const Text(
                                      'View & Add rec',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, color: doctorTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }))
        ],
      ),
    );
  }
}
