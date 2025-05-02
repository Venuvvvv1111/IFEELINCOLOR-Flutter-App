import 'package:flutter/foundation.dart';
import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/load_neatwork_image.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:flutter/material.dart';

import '../../../common_screens/settings/logout_dailog.dart';

var countArray = [];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  String userName = '';
  @override
  void initState() {
    super.initState();

    userName = UserInfo().getUserName ?? 'Hi User';
  }

  @override
  Widget build(BuildContext context) {
    userName = UserInfo().getUserName ?? 'Hi User';
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70, bottom: 10),
                width: MediaQueryUtil.size(context).width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2B024B),
                      Color(0xFF2B024B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // color: primaryColor,
                child: Column(
                  children: [
                    Center(
                        child: Stack(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 110.0,
                            width: 110.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: primaryColor, width: 3.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: LoadNetworkImage(
                              UserInfo().getUserProfileUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 15,
                            child: GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print('profile$userName');
                                }
                                if (kDebugMode) {
                                  print(
                                    UserInfo().getUserName ?? 'Hi User',
                                  );
                                }
                              },
                              child: const CircleAvatar(
                                backgroundColor: greenColor,
                                radius: 5,
                              ),
                            ))
                      ],
                    )),
                    const SizedBox(height: 10),
                    Text(
                      'Hello, Welcome',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: whiteColor),
                    ),
                    Text(
                      userName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: whiteColor),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF320257), Color(0xFF320257)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            width: MediaQueryUtil.size(context).width,
            height: MediaQueryUtil.size(context).height / 1.4,
            // color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingItems(
                  image: AppIcons.profileIcon,
                  title: 'Profile',
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.profileDetailScreen);
                  },
                ),
                SettingItems(
                  image: AppIcons.subscribeMainIcon,
                  title: 'My Subscriptions',
                  ontap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.mySubscriptionScreen);
                  },
                ),
                SettingItems(
                  image: AppIcons.paymentMenthodMainIcon,
                  title: 'Subscribe Portal',
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.subscribePortalScreen,
                    );
                  },
                ),
                SettingItems(
                  image: AppIcons.paymentMenthodMainIcon,
                  title: 'Organization Subscription',
                  ontap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.allOrganizationScreen,
                    );
                  },
                ),
                SettingItems(
                  image: AppIcons.privacyPolicyMainIcon,
                  title: 'Privacy Policy',
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.privacyPolicyScreen);
                  },
                ),
                SettingItems(
                  image: AppIcons.settingsMainIcon,
                  title: 'Settings',
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.allSettingsScreen);
                  },
                ),
                SettingItems(
                  image: AppIcons.helpMainIcon,
                  title: 'Help',
                  ontap: () {
                    Navigator.pushNamed(context, AppRoutes.helpScreen);
                  },
                ),
                SettingItems(
                  image: AppIcons.logoutMainIcon,
                  title: 'LogOut',
                  ontap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return LogoutDailog(
                            onpress: () async {
                              UserInfo().removeData();
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.loginScreen, (route) => false);

                              // Navigator.of(context).pushAndRemoveUntil(
                              //   MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         LoginScreen(),
                              //   ),
                              //   (route) => false,
                              // );
                            },
                          );
                        });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingItems extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback ontap;
  const SettingItems({
    super.key,
    required this.image,
    required this.title,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        image: AssetImage(image),
        height: 23,
        width: 23,
      ),
      title: Text(
        title,
        style: const TextStyle(color: whiteColor),
      ),
      onTap: ontap,
      trailing: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }
}
