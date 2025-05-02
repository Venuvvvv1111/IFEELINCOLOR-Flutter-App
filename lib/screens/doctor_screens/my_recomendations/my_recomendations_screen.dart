import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/recomendation_controllers/my_recomendations_controller.dart';
import 'package:ifeelin_color/utils/route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/helpers/url_launcher_helper.dart';
import 'package:readmore/readmore.dart';

class RecommendedPatientsScreen extends StatelessWidget {
  RecommendedPatientsScreen({super.key});
  final MyRecommendedPatientsController controller =
      Get.put(MyRecommendedPatientsController());

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
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF033A98),
          elevation: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, AppRoutes.doctorProfileDetailScreen);
                },
                child: CircleAvatar(
                  backgroundColor: whiteColor,
                  child: ClipOval(
                    child: LoadNetworkImage(
                      UserInfo().getUserProfileUrl,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Recomended Patients",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: whiteColor)),
                ],
              )
            ],
          ),
          actions: [
            CircleAvatar(
              backgroundColor: whiteColor,
              child: IconButton(
                icon: Image(image: AssetImage(AppIcons.notificationIcon)),
                onPressed: () {
                  Navigator.pushNamed(
                      context, AppRoutes.allNotificationsScreen);
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0), // Adjust as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: controller.searchController,
                // controller: homeController.searchController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 10,
                    ),
                    filled: true,
                    fillColor: whiteColor,
                    hintText: 'Search Recomended patients',
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    border: InputBorder.none),

                style: const TextStyle(
                  height: 1.2,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredPatients.isEmpty) {
                  return const Center(child: Text('No patients found.'));
                }

                return ListView.builder(
                  itemCount: controller.filteredPatients.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  itemBuilder: (context, index) {
                    final patientData = controller.filteredPatients[index];
                    return Card(
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              const BorderSide(width: 1, color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 50,
                                    width: 50,
                                    child: const ClipOval(
                                      child: LoadNetworkImage(
                                        "",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Suggested To',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                secondaryFontColor),
                                                  ),
                                                  Text(
                                                    '${patientData.patient?.userName}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                            fontSize: 14,
                                                            color:
                                                                primaryColor),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                  Text(
                                                    patientData
                                                            .patient?.mobile ??
                                                        " ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Suggested on',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color:
                                                              secondaryFontColor),
                                                ),
                                                Text(
                                                  "${patientData.recommendations![0].timestamp}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: primaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ReadMoreText(
                                patientData.recommendations![0].timestamp ??
                                    'A common form of Lorem ipsum reads: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. A common form of Lorem ipsum reads: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                                trimLines: 5,
                                // colorClickableText: Colors.white,
                                colorClickableText: Colors.black,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '   Read more..',
                                style: Theme.of(context).textTheme.bodySmall,
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
                            ),
                            Container(
                              color: primaryColorLight,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Use Flexible to ensure each category container takes up equal space
                                  Flexible(
                                    child: _buildCategoryContainer(index,
                                        'images', 'Images', AppIcons.imageIcon),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: _buildCategoryContainer(
                                        index,
                                        'documents',
                                        'Documents',
                                        AppIcons.documentIcon),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: _buildCategoryContainer(index,
                                        'links', 'Links', AppIcons.vedioIcon),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              final selectedCategory =
                                  controller.selectedCategory[index];
                              if (selectedCategory != null) {
                                return SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          controller.items[index]!.map((item) {
                                        return Container(
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.all(5),
                                            child: Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Ensure border radius is applied
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Ensure image corners are rounded
                                                  child: selectedCategory ==
                                                          'images'
                                                      ? LoadNetworkImage(
                                                          item,
                                                          fit: BoxFit.cover,
                                                          height: 70,
                                                          width: 70,
                                                        )
                                                      : selectedCategory ==
                                                              'documents'
                                                          ? InkWell(
                                                              onTap: () {
                                                                URLLauncherHelper
                                                                    .openURL(
                                                                        item);
                                                              },
                                                              child: Center(
                                                                  child: Image.asset(
                                                                      AppIcons
                                                                          .pdfIcon)),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                URLLauncherHelper
                                                                    .openURL(
                                                                        item);
                                                              },
                                                              child: Center(
                                                                  child: Image.asset(
                                                                      AppIcons
                                                                          .videoLinkIcon)),
                                                            )),
                                            ));
                                      }).toList(),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContainer(
      int index, String category, String label, String image) {
    return Obx(() {
      bool isSelected = controller.selectedCategory[index] == category;
      return GestureDetector(
        onTap: () {
          controller.updateCategory(index, category);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? controller.selectedColor.value
                : controller.unselectedColor.value,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(image),
                height: 20,
                width: 20,
                color: isSelected
                    ? controller.unselectedColor.value
                    : controller.selectedColor.value,
              ),
              const SizedBox(width: 5),
              // Wrap Text widget with Flexible or Expanded
              Expanded(
                child: Text(
                  label, // Use the passed label here
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: isSelected
                        ? controller.unselectedColor.value
                        : controller.selectedColor.value,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
