import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/organization_list_controller/organization_controller.dart';
import 'package:ifeelin_color/models/patient_models/organization_model.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';

import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class OrganizationListView extends StatefulWidget {
  const OrganizationListView({super.key});

  @override
  State<OrganizationListView> createState() => _BranchListState();
}

class _BranchListState extends State<OrganizationListView> {
  final OrganizationController organizationController =
      Get.put(OrganizationController());
  @override
  void initState() {
    super.initState();
    organizationController.fetchOrganizationList();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<OrganizationController>();
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
              'Organizations',
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
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: Container(
                height: kToolbarHeight - 7,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const ShapeDecoration(
                    shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    color: whiteColor,
                    shadows: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: organizationController
                              .searchOrganizationController,
                          onChanged: (query) {
                            organizationController.filterOrganizations(query);
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: "search your organization",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          organizationController.searchOrganizationController
                              .clear();
                          organizationController.filterOrganizations('');
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Choose Organization",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(() {
                    if (organizationController.isLoading.value) {
                      return Center(child: LoaderHelper.lottiWidget());
                    }
                    //  else if (controller.notificationsList.isEmpty) {
                    //   return Center(child: Text('No notifications available'));
                    // }
                    // ignore: prefer_is_empty
                    else if (organizationController
                            .filteredOrganizations.length ==
                        0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Text('No Organizations Found'),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          itemCount: organizationController
                              .filteredOrganizations.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.0,
                          ),
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                // final pref =
                                //     await SharedPreferences.getInstance();
                                // pref.setString('branchID', '${item['id']}');
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return AnnouncementList(
                                //       branchId: '${item['id']}',
                                //       branchName:
                                //           '${item["full_name"].toString().split(',').first}',
                                //     );
                                //   }),
                                // );
                                Navigator.pushNamed(context,
                                    AppRoutes.organizationDoctorsScreen,
                                    arguments: OrganizationArguments(
                                        organizationId: organizationController
                                            .filteredOrganizations[index].sId
                                            .toString(),
                                        organizationName: organizationController
                                            .filteredOrganizations[index].name
                                            .toString(),
                                        isIndividual: false));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.4),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: LoadNetworkImage(
                                          organizationController
                                              .filteredOrganizations[index]
                                              .image
                                              .toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Positioned(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white
                                                    .withValues(alpha: 0),
                                                primaryColor.withValues(
                                                    alpha: 0.8)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              organizationController
                                                  .filteredOrganizations[index]
                                                  .name
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  organizationController
                                                          .filteredOrganizations[
                                                              index]
                                                          .address ??
                                                      'NA',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }),
                ]),
              ],
            ),
          )),
    );
  }
}
