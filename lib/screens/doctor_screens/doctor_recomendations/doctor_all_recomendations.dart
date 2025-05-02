import 'package:flutter/material.dart';
import 'package:ifeelin_color/models/doctor_models/subscribed_patients_model.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_recomendations/doctor_portal_recomendation_screen.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_recomendations/patient_recomendation_screen.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/app_images.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class DoctorAllRecomendations extends StatelessWidget {
  final Patient patient;

  const DoctorAllRecomendations({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(0xFF033A98),
              expandedHeight: screenHeight * 0.25,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF033A98), Color(0xFF0857DE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(context),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                CircleAvatar(
                  backgroundColor: whiteColor,
                  child: IconButton(
                    icon: Image(image: AssetImage(AppIcons.notificationIcon)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.allNotificationsScreen);
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
              title: const Text(
                'Recommendations',
                style: TextStyle(height: 1.2, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              centerTitle: true,
            ),
          ];
        },
        body: Column(
          children: [
            // Divider(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _buildTabBar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      color: whiteColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: LoadNetworkImage(
                      patient.image.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          patient.userName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(AppIcons.userLocationIcon),
                              height: 17,
                              width: 17,
                            ),
                            Expanded(
                              child: Text(
                                patient.location.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: secondaryFontColor,
                                        fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildProfileOptions(context),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: const BoxDecoration(color: Color(0xFFEDF0FC)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.patientIntakeDetailsScreen,
                        arguments: patient.sId);
                  },
                  child: _buildProfileOption('Intake Details'))),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addRecommendationScreen,
                    arguments: patient);
              },
              child: _buildProfileOption('Add recommendations'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title) {
    return Row(
      children: [
        Image.asset(
          AppImages.intakeImage,
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: doctorTextColor),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicator: BoxDecoration(
              border: Border(
                left:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
                right:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2), // No bottom border for active tab
              ),
            ),
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.recommend),
                      // SizedBox(height: 4),
                      Text(
                        'Clinician Recommendations',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services),
                      Text(
                        'Portal Recommendations',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                PatientRecomendationScreen(
                  patientId: patient.sId,
                ),
                DoctorPortalRecomendationScreen(
                  patientId: patient.sId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
