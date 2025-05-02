import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/announcement_controller/announcement_controller.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/statisctics_controller/doctor_statistics_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/doctor_controllers/home_controllers/doctor_home_controller.dart';

class DoctorDashboard extends StatelessWidget {
  final DoctorHomeController doctorHomeController;

  const DoctorDashboard({
    super.key,
    required this.doctorHomeController,
  });

  @override
  Widget build(BuildContext context) {
    var userinfo = Get.put(UserInfo());
    final DoctorStatisticsController doctorStatisticsController =
        Get.put(DoctorStatisticsController());
    var announcementController = Get.put(AnnouncementController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IFEELINCOLOR",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor: const Color(0xFF033A98),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQueryUtil.size(context).height * 0.07,
                color: const Color(0xFF033A98),
              ),
              Stack(
                children: [
                  Container(
                    height: MediaQueryUtil.size(context).height * 0.07,
                    color: const Color(0xFF033A98),
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
                                    userinfo.getUserName.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          userinfo.getUserDesignation
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RatingBarIndicator(
                                    rating: double.parse(
                                        userinfo.getDoctorRatings ?? "4.0"),

                                    itemCount: 5,
                                    itemSize:
                                        15.0, // Set the desired icon size here
                                    direction: Axis.horizontal,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: newIdentitiyPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 5),
                                          decoration: BoxDecoration(
                                            color: phoneBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    '+91 ${userinfo.getUserMobileNumber}',
                                                    minFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 5),
                                          decoration: BoxDecoration(
                                            color: emailBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                                    '${userinfo.getUserEmail}',
                                                    minFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 5),
                                          decoration: BoxDecoration(
                                            color: calenderBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                AppIcons.experienceIcon,
                                                height: 17,
                                                width: 17,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                    '${userinfo.getUserExp ?? 0} Experience',
                                                    minFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 5, 5),
                                          decoration: BoxDecoration(
                                            color: locationBackgoundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                AppIcons.userLocationIcon,
                                                height: 17,
                                                width: 17,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                    userinfo.getUserAdress,
                                                    minFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: primaryColor, width: 3.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(80.0)),
                              ),
                              child: LoadNetworkImage(
                                UserInfo().getUserProfileUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // ClipOval(
                          //   child: Container(
                          //     width: 100.0,
                          //     height: 100.0,
                          //     decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: whiteColor,
                          //         border: Border.all(color: primaryColor)),
                          //     child: Image.asset(
                          //       AppImages.profileStaticImage,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Subscribed Patients
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                // Show shimmer effect or loading indicator while fetching data
                if (announcementController.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Shimmer Effect for carousel items

                        LoaderHelper.lottiWidget()
                      ],
                    ),
                  );
                }

                // When the data is fetched, show the carousel with images
                if (announcementController.announcements.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.2,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: announcementController.announcements
                              .map((announcement) {
                            // If the image URL is empty, show a SizedBox
                            if (announcement.media.isEmpty) {
                              return const SizedBox.shrink();
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Show shimmer while image is loading
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.blue[200]!,
                                      child: Container(
                                        color: Colors
                                            .grey[300], // Placeholder color
                                      ),
                                    ),
                                    Image.network(
                                      announcement.media,
                                      fit: BoxFit.fill,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // Image is loaded, return the image
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      (loadingProgress
                                                              .expectedTotalBytes ??
                                                          1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // If the image URL is invalid, show a fallback
                                        return const SizedBox
                                            .shrink(); // Or show a fallback image here
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              InkWell(
                onTap: () {
                  doctorHomeController.selectedIndex.value = 0;
                },
                child: Obx(
                  () => buildCard(
                    'Subscribed Patients',
                    '${doctorStatisticsController.subscribedPatients}',
                    doctorStatisticsController.growthRate.value,
                    SfCartesianChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      primaryXAxis: const CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: doctorStatisticsController
                                  .subscriptionChartData.isNotEmpty
                              ? doctorStatisticsController.subscriptionChartData
                                  .toList()
                              : _getColumnData(), // Provide null if the list is empty
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => buildCard(
                  'Recomended Patients',
                  '${doctorStatisticsController.recommendedPatients}',
                  doctorStatisticsController.growthRate.value,
                  SfCircularChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                        dataSource: doctorStatisticsController
                                .recommendedPatientsData.isNotEmpty
                            ? doctorStatisticsController.recommendedPatientsData
                                .toList()
                            : _getPieData(),
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                  Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => buildCard(
                  'Sales',
                  '\$${doctorStatisticsController.sales.value}',
                  doctorStatisticsController.growthRate.value,
                  SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: const CategoryAxis(),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: doctorStatisticsController.salesChartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(
      String title, String value, String growth, Widget chart, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 10,
        color: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    Text(growth),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 150,
                  child: chart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartData> _getColumnData() {
    return [
      ChartData('Jan', 30),
      ChartData('Feb', 50),
      ChartData('Mar', 40),
      ChartData('Apr', 30),
      ChartData('May', 40),
    ];
  }

  List<ChartData> _getPieData() {
    return [
      ChartData('No Data', 0),
      ChartData('Segment 2', 0),
      ChartData('Segment 3', 0),
      ChartData('No data', 1),
    ];
  }
}
