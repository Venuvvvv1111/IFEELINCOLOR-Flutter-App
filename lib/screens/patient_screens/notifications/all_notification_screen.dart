import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/notification_controller/notifications_controller.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/constants/loader.dart';

import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

import '../../../utils/constants/user_data.dart';

class AllNotificationsScreen extends StatefulWidget {
  const AllNotificationsScreen({super.key});

  @override
  State<AllNotificationsScreen> createState() => _AllNotificationsScreenState();
}

class _AllNotificationsScreenState extends State<AllNotificationsScreen> {
  final NotificationsController controller = Get.put(NotificationsController());
  final UserInfo _userInfo = Get.put(UserInfo());
  @override
  void initState() {
    controller.fetchNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: whiteColor,
        backgroundColor:
            _userInfo.getDoctorLogin ? doctorPrimaryColor : primaryColor,
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
        } else if (controller.notificationsList.isEmpty) {
          return const Center(child: Text('No notifications available'));
        } else {
          return ListView.builder(
            itemCount: controller.notificationsList.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              var notification = controller.notificationsList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: calenderBackgroundColor,
                        child: Image.asset(
                          AppIcons.notificationIcon,
                          fit: BoxFit.cover,
                          height: 17,
                          width: 17,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification.sender?.model ?? ''),
                              Text(
                                '${notification.message}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 13),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  MediaQueryUtil.formatDateWithSuffix(
                                      DateTime.parse(
                                          notification.createdAt.toString())),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
