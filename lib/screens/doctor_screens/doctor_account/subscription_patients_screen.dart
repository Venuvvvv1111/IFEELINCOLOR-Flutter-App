import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../controllers/doctor_controllers/subscription_patients_controllers/subscription_patients_controller.dart';

class SubscriptionPatientsScreen extends StatefulWidget {
  const SubscriptionPatientsScreen({super.key});

  @override
  State<SubscriptionPatientsScreen> createState() =>
      _SubscriptionPatientsScreenState();
}

class _SubscriptionPatientsScreenState
    extends State<SubscriptionPatientsScreen> {
  final SubscriptionPatientsController controller =
      Get.put(SubscriptionPatientsController());

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
          'Subscribed Patients',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor: doctorPrimaryColor,
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
          // ignore: prefer_is_empty
        } else if (controller.subscriptionPatientsModel?.body?.length == 0 ||
            controller.subscriptionPatientsModel?.body?.length == null) {
          return const Center(
            child: Text('No Subscriptions Found'),
          );
        } else {
          return ListView.builder(
            itemCount: controller.subscriptionPatientsModel?.body?.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              var allSubscriptions =
                  controller.subscriptionPatientsModel?.body?[index];
              return Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.only(top: 10),
                  width: MediaQueryUtil.size(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${allSubscriptions?.subscription?.planName ?? 'NA'} - \$30",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Location: ${allSubscriptions?.patient?.location ?? 'NA'}',
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
                              'Patient: ${allSubscriptions?.patient?.userName ?? 'NA'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                'Active',
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
                          'Validity : ${MediaQueryUtil.formatDateWithSuffix(DateTime.parse(allSubscriptions!.subscription!.endDate.toString()))}',
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
