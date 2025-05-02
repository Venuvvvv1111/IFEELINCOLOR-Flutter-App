import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/home_screens/widgets/stepper_widget.dart';

import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/helpers/url_launcher_helper.dart';
import 'package:readmore/readmore.dart';

import 'package:ifeelin_color/models/patient_models/nearby_doctor_model.dart'
    as doctor;

class DoctorDetailsScreen extends StatelessWidget {
  final doctor.Body? nearbyDoctorsModel;
  const DoctorDetailsScreen({super.key, required this.nearbyDoctorsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Details",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor: primaryColor,
      ),
      body: Padding(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    nearbyDoctorsModel?.name ?? 'Dr. Welcome',
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
                                          nearbyDoctorsModel?.specializedIn ??
                                              '--------------------',
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
                                    rating: double.parse(nearbyDoctorsModel
                                            ?.ratings
                                            .toString() ??
                                        "3.0"),

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
                                                    nearbyDoctorsModel
                                                                ?.subscribed ==
                                                            1
                                                        ? nearbyDoctorsModel!
                                                            .mobileNum
                                                            .toString()
                                                        : '+91 XXXXXXXXXX',
                                                    minFontSize: 8,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                    nearbyDoctorsModel
                                                                ?.subscribed ==
                                                            1
                                                        ? nearbyDoctorsModel!
                                                            .email
                                                            .toString()
                                                        : 'XXXXX@gmail.com',
                                                    minFontSize: 8,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                    "${nearbyDoctorsModel?.experience}"
                                                    ' Experience',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 8,
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
                                                    nearbyDoctorsModel
                                                                ?.subscribed ==
                                                            1
                                                        ? nearbyDoctorsModel!
                                                            .location
                                                            .toString()
                                                        : 'XXXXXXXXXX',
                                                    minFontSize: 8,
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
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                  border: Border.all(color: primaryColor)),
                              child: LoadNetworkImage(
                                "${nearbyDoctorsModel?.image}",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        CircleAvatar(
                          radius: 25,
                          child: Image.asset(AppImages.summeryImage),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summery',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              ReadMoreText(
                                "${nearbyDoctorsModel?.about}",
                                trimLines: 5,
                                // colorClickableText: Colors.white,
                                colorClickableText: Colors.black,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '   Read more..',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
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
                        CircleAvatar(
                          radius: 25,
                          child: Image.asset(AppImages.highletsImage),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highlight',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              ReadMoreText(
                                "${nearbyDoctorsModel?.highlights}",
                                trimLines: 5,
                                // colorClickableText: Colors.white,
                                colorClickableText: Colors.black,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '   Read more..',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 13),
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
              const SizedBox(
                height: 20,
              ),
              nearbyDoctorsModel?.subscribed == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                        'Active Plan',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    )
                  : const SizedBox(),
              nearbyDoctorsModel?.subscribed == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.only(top: 10),
                          width: MediaQueryUtil.size(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${nearbyDoctorsModel?.planDetails?.name} : \$${nearbyDoctorsModel?.planDetails?.price}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${nearbyDoctorsModel?.planDetails?.details}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Plan :${nearbyDoctorsModel?.planDetails?.planType}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: greenColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text(
                                        'Active',
                                        style: TextStyle(
                                            color: whiteColor, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                width: MediaQueryUtil.size(context).width,
                                child: Text(
                                  'Validity : ${MediaQueryUtil.formatDateWithSuffix(DateTime.parse(nearbyDoctorsModel?.planDetails?.createdAt.toString() ?? ''))}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              nearbyDoctorsModel?.subscribed == 1
                  ? const SizedBox(
                      height: 30,
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  'Career Path',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    0.8, // Adjust the height as needed
                child: StepperWidget(
                  careerpathList: nearbyDoctorsModel?.careerpath ?? [],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: MediaQueryUtil.size(context).width,
          child: ElevatedButton(
            onPressed: () {
              if (nearbyDoctorsModel?.subscribed == 1) {
                var phoneNumber = 'tel:+${nearbyDoctorsModel?.mobileNum}';
                if (kDebugMode) {
                  print(phoneNumber);
                }
                URLLauncherHelper.openURL(phoneNumber);
              } else {
                Navigator.pushNamed(context, AppRoutes.subscribeClinicScreen,
                    arguments: nearbyDoctorsModel?.sId);
              }
            },
            child: Text(nearbyDoctorsModel?.subscribed == 1
                ? 'Contact Now'
                : 'Subscribe Now'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
