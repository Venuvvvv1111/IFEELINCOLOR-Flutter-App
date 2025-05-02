import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/services/payment_gateway/stripe_service.dart';

import '../../../controllers/patient_controllers/portal_subscription_controller.dart';
import '../../../utils/helpers/app_images.dart';
import '../../../utils/helpers/custom_colors.dart';

class SubscribePortalScreen extends StatefulWidget {
  const SubscribePortalScreen({super.key});

  @override
  State<SubscribePortalScreen> createState() => _SubscribePortalScreenState();
}

class _SubscribePortalScreenState extends State<SubscribePortalScreen> {
  final SubscribePortalController controller =
      Get.put(SubscribePortalController());
  @override
  void initState() {
    controller.fetchPlans();
    Stripeservice().initializeStripe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: List.generate(controller.plans.length, (index) {
                final plan = controller.plans[index];
                return _buildPage(
                  plan.name ?? 'Unknown Plan ',
                  'Pick a plan that is best for you',
                  '\$ ${plan.price ?? 0.0}',
                  AppImages.subscribePlanImage,
                  plan.details ?? '',
                  plan.planType ?? 'Unknown',
                  () => controller.onGetStarted(context, Stripeservice()),
                  context,
                );
              }),
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(controller.plans.length, (index) {
                    return _buildDot(controller.currentPage.value == index);
                  }),
                )),
          ),
          Obx(() {
            return controller.plans.isEmpty
                ? const Center(
                    child: Text('Sorry! there are no plans available'))
                : const SizedBox();
          }),
          Positioned(
              top: 10,
              left: 16,
              child: SafeArea(
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios))))
        ],
      ),
    );
  }

  Widget _buildPage(
    String title,
    String subTitle,
    String amount,
    String imageUrl,
    String details,
    String planType,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  subTitle,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SvgPicture.asset(
                  imageUrl,
                  height: MediaQuery.of(context).size.height / 4.5,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  '$planType: $amount',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Obx(() => TextButton(
                      onPressed: () {
                        int currentPage = controller.currentPage.value;
                        if (controller.showViewMore.value) {
                          controller.onViewMore(currentPage);
                        } else {
                          controller.onViewLess(currentPage);
                        }
                      },
                      child: controller.showViewMore.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.showViewMore.value
                                      ? 'View More'
                                      : 'View Less',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: newIdentitiyPrimaryColor,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  controller.showViewMore.value
                                      ? Icons.arrow_forward_sharp
                                      : Icons.arrow_back_sharp,
                                  color: newIdentitiyPrimaryColor,
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_back_sharp,
                                  color: newIdentitiyPrimaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'View Less',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: newIdentitiyPrimaryColor,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? primaryColor
            : Colors.grey, // Use activeColor for active dot
      ),
    );
  }
}
