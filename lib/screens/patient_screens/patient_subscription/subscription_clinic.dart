import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/services/payment_gateway/stripe_service.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import '../../../controllers/patient_controllers/clinic_subscription_controller.dart';

class SubscribeClinicScreen extends StatefulWidget {
  final String? doctorId;
  final bool isIndividual;
  const SubscribeClinicScreen({
    super.key,
    required this.doctorId,
    required this.isIndividual,
  });

  @override
  State<SubscribeClinicScreen> createState() => _SubscribeClinicScreenState();
}

class _SubscribeClinicScreenState extends State<SubscribeClinicScreen> {
  final SubscribeClinicController controller =
      Get.put(SubscribeClinicController());
  @override
  void initState() {
    controller.fetchDoctorPlans(widget.isIndividual);
    Stripeservice().initializeStripe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            controller.intialLoading.value
                ? Center(child: LoaderHelper.lottiWidget())
                : controller.plans.isEmpty
                    ? const Center(
                        child: Text('Sorry! there are no plans available'))
                    : PageView(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        children: controller.plans.map((plan) {
                          return _buildPage(
                            plan.name ?? 'Unknown Plan',
                            'Pick a plan that is best for you',
                            '\$ ${plan.price ?? 0.0}',
                            AppImages
                                .subscribePlanImage, // Assuming the image is the same
                            plan.details ?? '',
                            plan.planType ?? '',

                            () => controller.onGetStarted(
                                context, Stripeservice(), widget.doctorId!),
                            context,
                          );
                        }).toList(),
                      ),
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
            Obx(() => controller.intialLoading.value
                ? const SizedBox()
                : Positioned(
                    top: 10,
                    left: 16,
                    child: SafeArea(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios))))),
            Obx(() {
              return controller.isloading.value
                  ? Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(child: LoaderHelper.lottiWidget()),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }

  Widget _buildPage(
    String title,
    String subtitle,
    String amount,
    String imageUrl,
    String details,
    String planType,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    if (kDebugMode) {
      print(imageUrl);
    }
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
                  subtitle,
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
                        if (controller.showViewMore.value) {
                          controller.onViewMore();
                        } else {
                          controller.onViewLess();
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
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? primaryColor : Colors.grey,
      ),
    );
  }
}
