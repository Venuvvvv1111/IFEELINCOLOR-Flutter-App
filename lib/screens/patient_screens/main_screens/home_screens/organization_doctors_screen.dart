import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/organization_list_controller/organization_controller.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class OrganizationDoctorsScreen extends StatefulWidget {
  final String organizationId;
  final String organizationName;
  const OrganizationDoctorsScreen(
      {super.key,
      required this.organizationId,
      required this.organizationName});

  @override
  State<OrganizationDoctorsScreen> createState() =>
      _OrganizationDoctorsScreenState();
}

class _OrganizationDoctorsScreenState extends State<OrganizationDoctorsScreen> {
  final OrganizationController organizationController =
      Get.put(OrganizationController());

  @override
  void initState() {
    super.initState();
    organizationController.fetchOrganizationDoctorsList(widget.organizationId);
    // Ensure state updates happen after the widget is built
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.organizationName} Doctors',
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller:
                    organizationController.searchOrganizationDoctorsController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'search doctors',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: InputBorder.none),
                onChanged: (query) {
                  organizationController.filterOrganizationDoctors(query);
                },
                style: const TextStyle(
                  height: 1.2,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (organizationController.isDoctorsLoading.value) {
                  return Center(child: LoaderHelper.lottiWidget());
                }

                if (organizationController
                    .filteredOrganizationDoctors.isEmpty) {
                  return const Center(child: Text('No doctors found.'));
                }

                return ListView.builder(
                  itemCount:
                      organizationController.filteredOrganizationDoctors.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  itemBuilder: (context, index) {
                    final doctor = organizationController
                        .filteredOrganizationDoctors[index];
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
                              doctor.image ?? '',
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
                                    doctor.name ?? '',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    doctor.specializedIn ?? '-----',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: secondaryFontColor),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  RatingBarIndicator(
                                    rating:
                                        double.parse(doctor.ratings ?? "4.0"),

                                    itemCount: 5,
                                    itemSize:
                                        15.0, // Set the desired icon size here
                                    direction: Axis.horizontal,

                                    itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: newIdentitiyPrimaryColor),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image(
                                        image:
                                            AssetImage(AppIcons.experienceIcon),
                                        height: 17,
                                        width: 17,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Text(
                                          doctor.experience ?? 'XXXXXXXX',
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
                                            AppRoutes
                                                .organizationDoctorDetailsScreen,
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
                                              border: Border.all(
                                                  color:
                                                      newIdentitiyPrimaryColor),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.check_circle,
                                                    size: 18,
                                                    color:
                                                        newIdentitiyPrimaryColor),
                                                const SizedBox(width: 5),
                                                Text(
                                                  'Subscribe',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color:
                                                              newIdentitiyPrimaryColor),
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
        ));
  }
}
