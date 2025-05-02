import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import this package
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/send_alert_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class SendAlertscreen extends StatefulWidget {
  const SendAlertscreen({super.key});

  @override
  State<SendAlertscreen> createState() => _SendAlertscreenState();
}

class _SendAlertscreenState extends State<SendAlertscreen> {
  GoogleMapController? mapController;
  final SendAlertController alertController = Get.put(SendAlertController());

  @override
  void initState() {
    super.initState();
    alertController.checkAndRequestLocationPermission();
    // _onMapCreated(mapController!);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Add markers and polylines after map is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitBounds();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SendAlertController>();
  }

  void _fitBounds() {
    if (alertController.patientLocation != null &&
        alertController.clinicLocation != null) {
      final LatLng southwest = LatLng(
        min(alertController.patientLocation!.latitude,
            alertController.clinicLocation!.latitude),
        min(alertController.patientLocation!.longitude,
            alertController.clinicLocation!.longitude),
      );

      final LatLng northeast = LatLng(
        max(alertController.patientLocation!.latitude,
            alertController.clinicLocation!.latitude),
        max(alertController.patientLocation!.longitude,
            alertController.clinicLocation!.longitude),
      );

      if (kDebugMode) {
        print('Southwest: $southwest');
        print('Northeast: $northeast');
      }

      final LatLngBounds bounds = LatLngBounds(
        southwest: southwest,
        northeast: northeast,
      );

      try {
        mapController
            ?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        )
            .catchError((e) {
          if (kDebugMode) {
            print('Error animating camera: $e');
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('Exception occurred: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: LoadNetworkImage(
                  UserInfo().getUserProfileUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
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
      body: Obx(() {
        if (alertController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (kDebugMode) {
          print(alertController.center);
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.7,
              child: GoogleMap(
                scrollGesturesEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: alertController.patientLocation ??
                      const LatLng(45.521563, -122.677433),
                  zoom: 16.0,
                ),
                onMapCreated: _onMapCreated,
                markers: alertController.mapMarkers,
                polylines: alertController.mapPolylines,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppIcons.sendAlert),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Alert sent',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5),
                              children: [
                                TextSpan(
                                  text:
                                      'Suicidal thoughts and behavior are common with some mental illnesses. If you think you may hurt yourself or attempt suicide, get help right away:\n\n',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                TextSpan(
                                  text: '• Call ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '911',
                                  style: TextStyle(
                                      color: Colors.red), // Color for 911
                                ),
                                TextSpan(
                                  text:
                                      ' or your local emergency number immediately.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '• Call your mental health specialist.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '• Call a suicide hotline number. In the U.S., call the ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'National Suicide Prevention Lifeline',
                                  style: TextStyle(
                                      color: Colors.blue), // Color for Lifeline
                                ),
                                TextSpan(
                                  text: ' at ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '1-800273-TALK (1-800-273-8255)',
                                  style: TextStyle(
                                      color:
                                          Colors.red), // Color for phone number
                                ),
                                TextSpan(
                                  text: ' or use its webchat on ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'suicidepreventionlifeline.org/chat',
                                  style: TextStyle(
                                      color:
                                          Colors.blue), // Color for webchat URL
                                ),
                                TextSpan(
                                  text: '.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '• Seek help from your primary care provider.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '• Reach out to a close friend or loved one.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '• Contact a minister, spiritual leader or someone else in your faith community.\n',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQueryUtil.size(context).width / 3,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.mainScreenTabs,
                                        (route) => false);
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.home),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text('Home'),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
