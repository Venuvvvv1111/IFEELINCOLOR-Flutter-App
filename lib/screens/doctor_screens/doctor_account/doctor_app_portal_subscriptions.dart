import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/doctor_controllers/doctor_app_portal_subscriptions_controller.dart/doctor_app_portal_subscription_controller.dart';

import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class DoctorAppPortalSubscriptionScreen extends StatefulWidget {
  const DoctorAppPortalSubscriptionScreen({super.key});

  @override
  State<DoctorAppPortalSubscriptionScreen> createState() =>
      _DoctorAppPortalSubscriptionScreenState();
}

class _DoctorAppPortalSubscriptionScreenState
    extends State<DoctorAppPortalSubscriptionScreen> {
  final DoctorAppPortalSubscriptionController controller =
      Get.put(DoctorAppPortalSubscriptionController());
  @override
  void initState() {
    controller.fetchSubscriptions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Subscriptions',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor: doctorPrimaryColorDark,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: whiteColor,
            )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: LoaderHelper.lottiWidget());
        }
        //  else if (controller.notificationsList.isEmpty) {
        //   return Center(child: Text('No notifications available'));
        // }
        // ignore: prefer_is_empty
        else if (controller
                    .doctorAppSubscribedSubscriptionsModel?.body?.length ==
                0 ||
            controller.doctorAppSubscribedSubscriptionsModel?.body?.length ==
                null) {
          return const Center(
            child: Text('No Subscriptions Found'),
          );
        } else {
          return ListView.builder(
            itemCount:
                controller.doctorAppSubscribedSubscriptionsModel?.body?.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              var allSubscriptions = controller
                  .doctorAppSubscribedSubscriptionsModel?.body?[index];
              return Card(
                color: (allSubscriptions?.endDate != null &&
                        DateTime.parse(allSubscriptions!.endDate!)
                            .isBefore(DateTime.now()))
                    ? disabledButtonColor
                    : whiteColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: (allSubscriptions?.endDate != null &&
                            DateTime.parse(allSubscriptions!.endDate!)
                                .isBefore(DateTime.now()))
                        ? disabledButtonColor
                        : whiteColor,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  width: MediaQueryUtil.size(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${allSubscriptions?.plan?.name ?? 'NA'} - \$${allSubscriptions?.plan?.price ?? 'NA'}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Details: ${allSubscriptions?.plan?.details ?? 'NA'}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type: ${allSubscriptions?.plan?.planType}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                  color: (allSubscriptions?.endDate != null &&
                                          DateTime.parse(
                                                  allSubscriptions!.endDate!)
                                              .isBefore(DateTime.now()))
                                      ? alertColor
                                      : greenColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                (allSubscriptions?.endDate != null &&
                                        DateTime.parse(
                                                allSubscriptions!.endDate!)
                                            .isBefore(DateTime.now()))
                                    ? "Expired"
                                    : "Active",
                                style:
                                    TextStyle(color: whiteColor, fontSize: 12),
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
                          'Validity : ${MediaQueryUtil.formatDateWithSuffix(DateTime.parse(allSubscriptions!.endDate.toString()))}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
