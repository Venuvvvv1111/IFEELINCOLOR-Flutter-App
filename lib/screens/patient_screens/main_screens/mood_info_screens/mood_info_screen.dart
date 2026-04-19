import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/announcement_controller/announcement_controller.dart';
import 'package:ifeelin_color/controllers/common_controllers/check_portal_subscroption.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/widgets/assessment_dialog.dart';
import 'package:ifeelin_color/services/tts_service.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/widgets/arrow_buttons.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class MoodInfoScreenView extends StatefulWidget {
  const MoodInfoScreenView({super.key});

  @override
  State<MoodInfoScreenView> createState() => _MoodInfoScreenViewState();
}

class _MoodInfoScreenViewState extends State<MoodInfoScreenView>
    with WidgetsBindingObserver {
  final UserInfo userInfo = Get.put(UserInfo());
  var announcementController = Get.put(AnnouncementController());
  final subscriptionController = Get.put(CheckPortalController());
  bool isTtsOn = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final userInfo = Get.find<UserInfo>();
    isTtsOn = userInfo.isTtsEnabled.value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakFullScreen();
    });
  }

  void _speakFullScreen() async {
    final userName = userInfo.getUserName ?? "User";

    final text = """
      Hello! Welcome $userName.

      This is Clinic Intake Form.

      The clinic intake form is an important document used to collect essential information from patients before their appointment. 
      It includes personal details, medical history, current medications, and reason for visit.

      Below options are available:

      Treatment History. It will open Treatment History Form.

      Health And Social Information.

      Assessment. It will open Assessment Form.

      Finally, Submit and Get Result button is available at the bottom.
      """;

    await TTSService().speak(text);
    await Future.delayed(const Duration(seconds: 1));

    // Step 3: Guide action

    // Step 4: Navigate
    if (!mounted) return;
    if (!userInfo.getTreatmentHistory.value) {
      await TTSService().speak("Let's fill Treatment History form first");
      Navigator.pushNamed(context, AppRoutes.treatmentHistory);
    } else if (!userInfo.getSocialHealthHistory.value) {
      await TTSService().speak("Let's fill Health And Social Information");
      Navigator.pushNamed(context, AppRoutes.healthSocialInformation);
    } else if (userInfo.getBodyAssesment.value) {
      await TTSService().speak("Let's fill Assessment form");
      Navigator.pushNamed(context, AppRoutes.twodModel);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fetchUserInfo();
  }

  void _fetchUserInfo() {
    // Call your API or service to refresh UserInfo data
    userInfo
        .refreshData(); // Assuming `refreshData` fetches and updates the user data
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (kDebugMode) {
      print('didChangeAppLifecycleState(state)');
    }
    // Check if the app resumed and refresh the screen if needed
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('AppLifecycleState.resumed');
      }
      // setState(() {
      if (kDebugMode) {
        print('changed cycle');
      }
      userInfo.refreshData();
      // This will refresh the state when the user navigates back to this screen

      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profileDetailScreen);
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
                ), // Replace with your profile image
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello! Welcome',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: whiteColor)),
                Text(UserInfo().getUserName ?? 'Hi User',
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
                Navigator.pushNamed(context, AppRoutes.allNotificationsScreen);
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      // backgroundColor: Color.fromARGB(255, 163, 79, 178).withValues(alpha:0.3),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Purple Box
          Container(
            height: MediaQueryUtil.size(context).height * 0.13,
            color: primaryColor,
          ),
          // Main Content
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQueryUtil.size(context).height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile

                    const SizedBox(
                      height: 20,
                    ),

                    Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: SizedBox(
                                    height:
                                        MediaQueryUtil.size(context).height /
                                            5.5,
                                    child:
                                        Image.asset(AppImages.clinicFormIcon))),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("Clinic Intake Form",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                            ReadMoreText(
                              'The clinic intake form is an important document used to collect essential information from patients before their appointment. It includes sections for personal details, medical history, current medications, and the reason for the visit. This helps to ensure that healthcare providers have the relevant background information to deliver personalized care. Providing accurate and complete information helps healthcare professionals assess health conditions and plan appropriate treatments.',
                              trimLines: 3,
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      // Show shimmer effect or loading indicator while fetching data
                      if (announcementController.isLoading.value) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Shimmer Effect for carousel items

                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.blue[200]!,
                                child: Container(
                                  color: Colors.grey[300], // Placeholder color
                                ),
                              ),
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
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
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
                                              color: Colors.grey[
                                                  300], // Placeholder color
                                            ),
                                          ),
                                          Image.network(
                                            announcement.media,
                                            fit: BoxFit.fill,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child; // Image is loaded, return the image
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                    const SizedBox(
                      height: 20,
                    ),

                    Obx(() {
                      return Speakable(
                        text: "It will open Treatment History Form",
                        child: ArrowButton(
                          text: "Treatment History",
                          image: AppIcons.treatmentHistory,
                          submitType: userInfo.getTreatmentHistory.value,
                          onTap: () async {
                            // await subscriptionController
                            //     .checkFreeTrailActive();
                            // await subscriptionController
                            //     .checkPremiumActiveSubscription();

                            if (await subscriptionController
                                    .checkFreeTrailActive() ||
                                await subscriptionController
                                    .checkPremiumActiveSubscription()) {
                              if (!context.mounted) {
                                return;
                              }
                              Navigator.pushNamed(
                                  context, AppRoutes.treatmentHistory);
                            } else {
                              TTSService().speak(
                                  "Please subscribe or start a free trial from Doctor/Portal Plans in Settings.");
                              MyToast.showGetToast(
                                title: 'Error',
                                message:
                                    'Please subscribe or start a free trial from Doctor/Portal Plans in Settings.',
                                color: whiteColor,
                                backgroundColor: Colors.red,
                              );
                            }

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => Treatmenthistory()));
                          },
                        ),
                      );
                    }),

                    const SizedBox(
                      height: 20,
                    ),

                    Obx(() {
                      return Speakable(
                        text: "Health And Social Information",
                        child: ArrowButton(
                          text: "Health And Social Information",
                          image: AppIcons.socialInformationIcon,
                          submitType: userInfo.getSocialHealthHistory.value,
                          onTap: () async {
                            if (await subscriptionController
                                    .checkFreeTrailActive() ||
                                await subscriptionController
                                    .checkPremiumActiveSubscription()) {
                              if (!context.mounted) {
                                return;
                              }
                              Navigator.pushNamed(
                                  context, AppRoutes.healthSocialInformation);
                            } else {
                              TTSService().speak(
                                  "Please subscribe or start a free trial from Doctor/Portal Plans in Settings.");
                              MyToast.showGetToast(
                                title: 'Error',
                                message:
                                    'Please subscribe or start a free trial from Doctor/Portal Plans in Settings.',
                                color: whiteColor,
                                backgroundColor: Colors.red,
                              );
                            }

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => Healthsocialinformation()));
                          },
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Speakable(
                        text: "It will open Assesment Form",
                        child: ArrowButton(
                          text: "Assesment",
                          submitType: userInfo.getAssesment.value
                              ? userInfo.getAssesment.value
                              : userInfo.getBodyAssesment.value,
                          image: AppIcons.familyMentalHealthHistoryIcon,
                          onTap: () async {
                            if (await subscriptionController
                                    .checkFreeTrailActive() ||
                                await subscriptionController
                                    .checkPremiumActiveSubscription()) {
                              if (!context.mounted) {
                                return;
                              }
                              if (isTtsOn) {
                                Navigator.pushNamed(
                                    context, AppRoutes.twodModel);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AssessmentDialog();
                                    });
                              }
                            } else {
                              TTSService().speak(
                                  "Please subscribe or start a free trial from Doctor/Portal Plans in Settings.");
                              MyToast.showGetToast(
                                title: 'Error',
                                message:
                                    'Please subscribe or start a free trial from Doctor/Portal Plans in Settings.',
                                color: whiteColor,
                                backgroundColor: Colors.red,
                              );
                            }

                            // Navigator.pushNamed(
                            //     context, AppRoutes.familyMentalHealth);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (_) => Treatment()));
                          },
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Speakable(
                      text: "'Submit & Get Result'",
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isTtsOn ? Colors.green : primaryColor),
                              onPressed: () {
                                if ((userInfo.getAssesment.value ||
                                        userInfo.getBodyAssesment.value) &&
                                    userInfo.getSocialHealthHistory.value &&
                                    userInfo.getTreatmentHistory.value) {
                                  // userInfo.removeData();
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.modelingTabsScreen);
                                } else {
                                  TTSService()
                                      .speak("Please fill required forms");
                                  MyToast.showGetToast(
                                      title: 'Error',
                                      message: 'Please fill required forms',
                                      color: whiteColor,
                                      backgroundColor: Colors.red);
                                }
                              },
                              child: const Text('Submit & Get Result'))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
