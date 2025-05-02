import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../../controllers/patient_controllers/home_controller.dart';

class SubscribedDoctors extends StatefulWidget {
  const SubscribedDoctors({super.key});

  @override
  State<SubscribedDoctors> createState() => _SubscribedDoctorsState();
}

class _SubscribedDoctorsState extends State<SubscribedDoctors> {
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();

    // Ensure state updates happen after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.fetchSubscribeDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            controller: homeController.subscribedSearchController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 10,
                ),
                filled: true,
                fillColor: whiteColor,
                hintText: 'Find nearest doctors',
                hintStyle: Theme.of(context).textTheme.labelLarge,
                border: InputBorder.none),
            onChanged: (query) {
              homeController.filterSubscribeDoctors(query);
            },
            style: const TextStyle(
              height: 1.2,
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (homeController.isLoading.value) {
              return Center(child: LoaderHelper.lottiWidget());
            }

            if (homeController.filterSubscribedDoctors.isEmpty) {
              return const Center(child: Text('No doctors found.'));
            }

            return ListView.builder(
              itemCount: homeController.filterSubscribedDoctors.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              itemBuilder: (context, index) {
                final doctor = homeController.filterSubscribedDoctors[index];
                return Card(
                  color: whiteColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 100,
                        width: 100,
                        child: LoadNetworkImage(
                          doctor.clinician?.image ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                doctor.clinician?.name ?? '',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                doctor.clinician?.specializedIn ?? '-----',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: secondaryFontColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RatingBarIndicator(
                                rating: double.parse(
                                    doctor.clinician?.ratings ?? "3.0"),

                                itemCount: 5,
                                itemSize:
                                    15.0, // Set the desired icon size here
                                direction: Axis.horizontal,
                                // itemPadding:
                                //     EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: newIdentitiyPrimaryColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image(
                                    image:
                                        AssetImage(AppIcons.userLocationIcon),
                                    height: 17,
                                    width: 17,
                                  ),
                                  Expanded(
                                    child: Text(
                                      doctor.clinician?.location ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: secondaryFontColor,
                                              fontSize: 12),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.subscribeDoctorDetailScreen,
                                        arguments: doctor,
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(color: greenColor),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.check_circle,
                                                size: 18, color: greenColor),
                                            const SizedBox(width: 5),
                                            Text(
                                              'View',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: greenColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
