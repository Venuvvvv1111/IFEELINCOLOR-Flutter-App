import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/common_controllers/all_settings_controller.dart';
import 'package:ifeelin_color/services/tts_service.dart';

import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../patient_screens/auth/login_screen_view.dart';
import 'logout_dailog.dart';

class AllSettingsScreen extends StatefulWidget {
  const AllSettingsScreen({super.key});

  @override
  AllSettingsScreenState createState() => AllSettingsScreenState();
}

class AllSettingsScreenState extends State<AllSettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  final UserInfo _userInfo = Get.put(UserInfo());
  final AllSettingsController notificationController =
      Get.put(AllSettingsController());

  @override
  Widget build(BuildContext context) {
      notificationController.getIsFreeTrailActive();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: whiteColor,
        backgroundColor:
            _userInfo.getUserLogin ? primaryColor : doctorPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.grey[100],
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Profile Section

            const SizedBox(height: 20.0),

            // General Settings Section
            _buildSectionTitle('General'),

            Obx(() => Card(
              elevation: 5,
              color: Colors.white,
              child: Column(
                children: [
                  _buildSwitchTile(
                        title: 'Notifications',
                        subtitle: 'Receive notifications for updates',
                        value: notificationController.notificationsEnabled.value,
                        onChanged: notificationController.toggleNotification,
                        icon: Icons.notifications_active,
                      ),
     
            Obx(() => _buildSwitchTile(
                  title: 'Voice Assistance',
                  subtitle: 'Enable text to speech',
                  value: _userInfo.isTtsEnabled.value,
                  onChanged: (val) {
                    _userInfo.setTtsEnabled = val;
                    if (!val) {
                      TTSService()
                          .speak("You Turned of the text to speech feature");
                    } else {
                      TTSService().speak(
                          "Now you can long press on text to listen the text");
                    }
                   
                  },
                  icon: Icons.volume_up,
                )),
                ],
              ),
            )),

            
            const SizedBox(height: 20.0),
            // Account Settings Section
            _buildSectionTitle('Account'),
            Card(
              elevation: 5,
              color: Colors.white,
              child: Column(
                children: [
                  _buildListTile(
                    title: 'Manage Account',
                    subtitle: 'change password',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
                      // Navigate to Manage Account Screen
                    },
                  ),
                   _buildListTile(
              title: 'Privacy & Security Policy',
              subtitle: 'Manage privacy and security',
              icon: Icons.lock,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.privacyPolicyScreen);
                // Navigate to Privacy Settings Screen
              },
            ),
                ],
              ),
            ),
           

            const SizedBox(height: 20.0),

            // Help Section
            _buildSectionTitle('Help'),
             Card(
              elevation: 5,
              color: Colors.white,
              child: Column(
                children: [
                  _buildListTile(
                    title: 'Help & Support',
                    subtitle: 'Get assistance with your issues',
                    icon: Icons.help,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.helpScreen);
                    },
                  ),
                   _buildListTile(
              title: 'About',
              subtitle: 'Learn more about the app',
              icon: Icons.info,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.aboutAppPage);
                // Navigate to About Screen
              },
            ),
                ],
              ),
            ),
           

            const SizedBox(height: 20.0),

            // Logout Section
            Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return LogoutDailog(
                          onpress: () {
                            var userInfo = Get.put(UserInfo());
                            userInfo.removeData();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        );
                      });
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDarkMode ? Colors.tealAccent : Colors.teal),
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey[600],fontSize: 13),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12.0),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return  ListTile(
      
  dense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
  leading: Icon(
    icon,
    color: isDarkMode ? Colors.tealAccent : Colors.teal,
    size: 22,
  ),
  title: Text(
    title,
    style: TextStyle(
      color: isDarkMode ? Colors.white : Colors.black,
      fontSize: 15,
    ),
  ),
  subtitle: Text(
    subtitle,
    style: TextStyle(
      color: isDarkMode ? Colors.grey : Colors.grey[600],
      fontSize: 13,
    ),
  ),
  trailing: Transform.scale(
    scale: 0.8, 
    child: Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.teal,
    ),
  ),
);
}}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllSettingsScreen(),
    ));
