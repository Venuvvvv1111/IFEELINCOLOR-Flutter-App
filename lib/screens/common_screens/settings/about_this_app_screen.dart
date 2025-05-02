import 'package:flutter/material.dart';

import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        elevation: 0,
        foregroundColor: whiteColor,
        backgroundColor:
            UserInfo().getUserLogin ? primaryColor : doctorPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
                child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              child: Image.asset(
                AppIcons.logoIcon, // Replace with your app logo path
              ),
            )),
            const SizedBox(height: 20),

            // Title
            Align(
              alignment: Alignment.center,
              child: Text(
                "IFEELINCOLOR",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Tagline
            Text(
              "Revolutionizing Healthcare Through Seamless Communication",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Description Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Mission",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "The IFEELINCOLOR application aims to streamline communication between patients and doctors, allowing patients to easily receive health results and personalized recommendations directly through the app. This enhances convenience, accessibility, and patient care.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Additional Information
            Text(
              "Key Features",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.teal),
              title: Text(
                "Receive personalized health recommendations",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.teal),
              title: Text(
                "Seamless doctor-patient communication",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.teal),
              title: Text(
                "Stay updated with important health alerts",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 30),

            // Footer
            Center(
              child: Text(
                "Empowering Lives Through Better Healthcare",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
