import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/recomendation_controllers/patient_recomendation_controller.dart';

import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/helpers/url_launcher_helper.dart';
import 'package:readmore/readmore.dart';

class PatientRecomendationScreen extends StatefulWidget {
  final String? patientId;
  const PatientRecomendationScreen({super.key, required this.patientId});

  @override
  State<PatientRecomendationScreen> createState() =>
      _PatientRecomendationScreenState();
}

class _PatientRecomendationScreenState
    extends State<PatientRecomendationScreen> {
  final PatientRecomendationController controller =
      Get.put(PatientRecomendationController());
  @override
  void initState() {
    super.initState();
    controller.fetchRecommendations(widget.patientId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.value
          ? Center(child: LoaderHelper.lottiWidget())
          : controller.totalPatientRecomendations.value == 0
              ? const Center(child: Text('No Doctor Recomendations'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.totalPatientRecomendations.value,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) {
                    var allRecomendations =
                        controller.patientsRecomendationsModel?.body?[index];

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
                                    child: ClipOval(
                                      child: SvgPicture.asset(
                                        AppIcons.logoIcon,
                                        // "${allRecomendations?.recommendedBy?.image.toString()}",
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
                                                    'Suggested By',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                secondaryFontColor),
                                                  ),
                                                  Text(
                                                    '${allRecomendations?.recommendedBy?.name}',
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
                                                    'spetialized in ',
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
                                                  'July 07 2024',
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
                                allRecomendations?.recommendation ??
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
    });
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
