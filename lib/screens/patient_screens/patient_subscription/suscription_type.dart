import 'package:flutter/material.dart';
import 'package:ifeelin_color/utils/Route/app_Routes.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class SubscriptionTypeView extends StatelessWidget {
  const SubscriptionTypeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: whiteColor,
            )),
        title: Text(
          'Suscribe',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  AppImages.subscriptionTypeImage,
                )),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.subscribePortalScreen);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Image.asset(AppIcons.subscribePortalIcon),
                    const SizedBox(
                      height: 35,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Subscribe Portal',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.subscribeClinicScreen);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor)),
                child: Column(
                  children: [
                    Image.asset(AppIcons.subscribeClinicIcon),
                    const SizedBox(
                      height: 35,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Subscribe Cliniciest',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
