import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/account_controllers/map_controller.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';

class UserMapScreen extends StatefulWidget {
  final String? latitude;
  final String? longitude;

  const UserMapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  GoogleMapController? mapController;
  final UserMapController userMapController = Get.put(UserMapController());
  final Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _setupInitialMarker();
    // Ensure initial location fetch
  }

  void _setupInitialMarker() {
    try {
      // Parse latitude and longitude
      final double? lat = widget.latitude != null && widget.latitude!.isNotEmpty
          ? double.tryParse(widget.latitude!)
          : null;
      final double? lng =
          widget.longitude != null && widget.longitude!.isNotEmpty
              ? double.tryParse(widget.longitude!)
              : null;

      if (lat != null && lng != null) {
        // Add marker for the provided coordinates
        _markers.add(
          Marker(
            markerId: const MarkerId("initialLocation"),
            position: LatLng(lat, lng),
            // infoWindow: InfoWindow(
            //   title: "Initial Location",
            //   snippet: "Lat: $lat, Lng: $lng",
            // ),
          ),
        );

        // Move the camera to the marker location
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
          );
        });
      } else {
        userMapController.getUserLocation();
        if (kDebugMode) {
          print("Coordinates not valid or empty");
        }
      }
    } catch (e) {
      userMapController.getUserLocation();
      if (kDebugMode) {
        print("Error setting up initial marker: $e");
      }
    }
  }

  @override
  void dispose() {
    Get.delete<UserMapController>();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        foregroundColor: whiteColor,
        title: const Text(
          'Your Location',
          style: TextStyle(fontSize: 16),
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
        return userMapController.center.value == null
            ? Center(child: LoaderHelper.lottiWidget())
            : GoogleMap(
                scrollGesturesEnabled: true,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: userMapController.center.value!,
                  zoom: 16.0,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  mapController = controller;

                  // Move camera to marker location after creation
                  _setupInitialMarker();
                  // double? lat = double.tryParse(widget.latitude ?? "");
                  // double? lng = double.tryParse(widget.longitude ?? "");
                  // if (lat != null && lng != null) {
                  //   mapController?.animateCamera(
                  //     CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
                  //   );
                  // }
                },
              );
      }),
    );
  }
}
