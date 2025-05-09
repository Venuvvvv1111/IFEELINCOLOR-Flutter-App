import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifeelin_color/models/doctor_models/doctor_profile_model.dart';
import 'package:ifeelin_color/models/doctor_models/subscribed_patients_model.dart';
import 'package:ifeelin_color/models/patient_models/organization_model.dart';
import 'package:ifeelin_color/screens/common_screens/no_internet_screen/no_internet_screen.dart';
import 'package:ifeelin_color/screens/common_screens/settings/about_this_app_screen.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/doctor_app_portal_subscriptions.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/doctor_profile_details.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_account/doctor_profile_edit_screen.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_main_tabs/doctor_main_tabs.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_recomendations/add_recomendation.dart';
import 'package:ifeelin_color/screens/doctor_screens/doctor_recomendations/doctor_all_recomendations.dart';
import 'package:ifeelin_color/screens/doctor_screens/patients/all_patients.dart';

import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/modeling_tabs/modeling_tabs_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/modeling_tabs/two_d_model/two_d_model.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/questionary_screens.dart/assessment_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/questionary_screens.dart/health_social_information.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/questionary_screens.dart/treatment_history.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/mood_info_screens/send_alert/send_alert_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/notifications/all_notification_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/auth/reset_password_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/auth/reset_password_success_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/my_subscriptions_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/privacy_policy_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/profile_detail_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/profile_edit_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/account_management/user_map_screen.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/home_screens/subscribed_doctor_details.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/home_screens/organication_list_view.dart';
import 'package:ifeelin_color/screens/patient_screens/main_screens/home_screens/organization_doctors_details.dart';

import 'package:ifeelin_color/screens/patient_screens/splash/splash_screen.dart';

import '../../models/patient_models/get_profile_model.dart';
import '../../screens/common_screens/help/help_screen.dart';
import '../../screens/common_screens/settings/all_settings_screen.dart';
import '../../screens/doctor_screens/doctor_account/subscription_patients_screen.dart';
import '../../screens/doctor_screens/patients/intake_details.dart';
import '../../screens/patient_screens/auth/login_screen_view.dart';
import '../../screens/patient_screens/auth/register_screen_view.dart';
import '../../screens/patient_screens/main_screens/home_screens/doctor_details.dart';
import '../../screens/patient_screens/main_screens/home_screens/organization_doctors_screen.dart';
import '../../screens/patient_screens/main_screens/main_sreen_tabs/MainScreenTab.dart.dart';
import '../../screens/patient_screens/patient_subscription/subscription_clinic.dart';
import '../../screens/patient_screens/patient_subscription/subscription_portal.dart';
import '../../screens/patient_screens/patient_subscription/suscription_type.dart';
import 'app_routes.dart';
import 'package:ifeelin_color/models/patient_models/nearby_doctor_model.dart'
    as doctor;
import 'package:ifeelin_color/models/patient_models/home_models/subscribed_doctor_model.dart'
    as subscribed_doctor;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return CupertinoPageRoute(
            builder: (_) => const SplashScreen(), settings: settings);
      case AppRoutes.noInternet:
        return CupertinoPageRoute(builder: (_) => const NoInternetScreen());
      case AppRoutes.loginScreen:
        return CupertinoPageRoute(
            builder: (_) => const LoginScreen(), settings: settings);
      case AppRoutes.resetPasswordScreen:
        return CupertinoPageRoute(
            builder: (_) => const ResetPasswordScreen(), settings: settings);
      case AppRoutes.passwordResetSuccessScreen:
        return CupertinoPageRoute(
            builder: (_) => const PasswordResetSuccessScreen(),
            settings: settings);
      case AppRoutes.registerScreen:
        return CupertinoPageRoute(
            builder: (_) => const RegistrationScreenView(), settings: settings);
      case AppRoutes.privacyPolicyScreen:
        return CupertinoPageRoute(
            builder: (_) => const PrivacyPolicyScreen(), settings: settings);
      case AppRoutes.subscriptionTypeScreen:
        return CupertinoPageRoute(
            builder: (_) => const SubscriptionTypeView(), settings: settings);
      case AppRoutes.subscribePortalScreen:
        return CupertinoPageRoute(
            builder: (_) => const SubscribePortalScreen(), settings: settings);
      case AppRoutes.subscribeClinicScreen:
        final args = settings.arguments as SubscribeClinicArguments;
        return CupertinoPageRoute(
          builder: (_) => SubscribeClinicScreen(
            doctorId: args.doctorId,
            isIndividual: args.isIndividual,
          ),
          settings: settings,
        );
      case AppRoutes.organizationDoctorDetailsScreen:
        final args = settings.arguments as OrganizationDoctorArguments;

        return CupertinoPageRoute(
          builder: (_) => OrganizationDoctorDetailsScreen(
            organizationDoctorsData: args.doctorData,
            isIndividual: args.isIndividual,
          ),
          settings: settings,
        );

      case AppRoutes.homeScreen:
        return CupertinoPageRoute(
            builder: (_) => const LoginScreen(), settings: settings);
      case AppRoutes.mainScreenTabs:
        return CupertinoPageRoute(
            builder: (_) => const MainTabsScreen(), settings: settings);
      case AppRoutes.recomendationScreen:
        return CupertinoPageRoute(
            builder: (_) => const SubscriptionTypeView(), settings: settings);
      case AppRoutes.moodInfoScreen:
        return CupertinoPageRoute(
            builder: (_) => const SubscribePortalScreen(), settings: settings);
      // case AppRoutes.acountMnagementScreen:
      //   return CupertinoPageRoute(
      //       builder: (_) => const SubscribeClinicScreen(
      //             doctorId: '123',
      //           ),
      //       settings: settings);
      case AppRoutes.doctorDetailScreen:
        final nearbyDoctorsModel = settings.arguments as doctor.Body;
        return CupertinoPageRoute(
            builder: (_) => DoctorDetailsScreen(
                  nearbyDoctorsModel: nearbyDoctorsModel,
                ),
            settings: settings);
      case AppRoutes.subscribeDoctorDetailScreen:
        final subscribedDoctorsModel =
            settings.arguments as subscribed_doctor.SubscribedList;
        return CupertinoPageRoute(
            builder: (_) => SubscribedDoctorDetailsScreen(
                  subscriedDoctorsModel: subscribedDoctorsModel,
                ),
            settings: settings);
      case AppRoutes.treatmentHistory:
        return CupertinoPageRoute(
            builder: (_) => const TreatmentHistory(), settings: settings);
      case AppRoutes.mySubscriptionScreen:
        return CupertinoPageRoute(
            builder: (_) => const MySubscriptionScreen(), settings: settings);
      case AppRoutes.familyMentalHealth:
        return CupertinoPageRoute(
            builder: (_) => const AssesmentScreen(), settings: settings);
      case AppRoutes.healthSocialInformation:
        return CupertinoPageRoute(
            builder: (_) => const HealthSocialInformation(),
            settings: settings);

      case AppRoutes.twodModel:
        return CupertinoPageRoute(
            builder: (_) => const TwoDModelScreen(), settings: settings);
      case AppRoutes.modelingTabsScreen:
        return CupertinoPageRoute(
            builder: (_) => const ModelingTabScreen(), settings: settings);
      case AppRoutes.sendAlertscreen:
        return CupertinoPageRoute(
            builder: (_) => const SendAlertscreen(), settings: settings);
      case AppRoutes.userMapScreen:
        final adressData = settings.arguments as Map<String, String>?;
        return CupertinoPageRoute(
            builder: (_) => UserMapScreen(
                  latitude: adressData?['latitude'] ?? '',
                  longitude: adressData?['longitude'] ?? '',
                ),
            settings: settings);
      case AppRoutes.profileDetailScreen:
        return CupertinoPageRoute(
            builder: (_) => const ProfileDetailScreen(), settings: settings);
      case AppRoutes.profileEditScreen:
        final profileModel = settings.arguments as GetProfileModel;
        return CupertinoPageRoute(
          builder: (_) => ProfileEditScreen(getProfileModel: profileModel),
          settings: settings,
        );
      case AppRoutes.allNotificationsScreen:
        return CupertinoPageRoute(
            builder: (_) => const AllNotificationsScreen(), settings: settings);

      //doctor screens
      case AppRoutes.doctorAllRecomendations:
        final patientModel = settings.arguments as Patient;
        return CupertinoPageRoute(
            builder: (_) => DoctorAllRecomendations(
                  patient: patientModel,
                ),
            settings: settings);
      case AppRoutes.allPatientsScreen:
        return CupertinoPageRoute(
            builder: (_) => const AllPatientsScreen(), settings: settings);
      case AppRoutes.addRecommendationScreen:
        final patientModel = settings.arguments as Patient;
        return CupertinoPageRoute(
            builder: (_) => AddRecommendationScreen(
                  patient: patientModel,
                ),
            settings: settings);
      case AppRoutes.doctorProfileDetailScreen:
        return CupertinoPageRoute(
            builder: (_) => const DoctorProfileDetailScreen(),
            settings: settings);
      case AppRoutes.doctorProfileEditScreen:
        final doctorProfileModel = settings.arguments as GetDoctorProfileModel;
        return CupertinoPageRoute(
            builder: (_) =>
                DoctorProfileEditScreen(getProfileModel: doctorProfileModel),
            settings: settings);
      case AppRoutes.doctorMainTabsScreen:
        return CupertinoPageRoute(
            builder: (_) => const DoctorMainTabsScreen(), settings: settings);
      case AppRoutes.patientIntakeDetailsScreen:
        final String patientId = settings.arguments as String;
        return CupertinoPageRoute(
            builder: (_) => PatientIntakeDetailsScreen(
                  patientId: patientId,
                ),
            settings: settings);
      case AppRoutes.helpScreen:
        return CupertinoPageRoute(
            builder: (_) => const HelpScreen(), settings: settings);
      case AppRoutes.allSettingsScreen:
        return CupertinoPageRoute(
            builder: (_) => const AllSettingsScreen(), settings: settings);
      case AppRoutes.subscriptionPatientsScreen:
        return CupertinoPageRoute(
            builder: (_) => const SubscriptionPatientsScreen(),
            settings: settings);
      case AppRoutes.doctorAppPortalSubscriptions:
        return CupertinoPageRoute(
            builder: (_) => const DoctorAppPortalSubscriptionScreen(),
            settings: settings);
      case AppRoutes.aboutAppPage:
        return CupertinoPageRoute(
            builder: (_) => const AboutAppPage(), settings: settings);
      case AppRoutes.allOrganizationScreen:
        return CupertinoPageRoute(
            builder: (_) => const OrganizationListView(), settings: settings);
      case AppRoutes.organizationDoctorsScreen:
        final args = settings.arguments as OrganizationArguments;
        return CupertinoPageRoute(
            builder: (_) => OrganizationDoctorsScreen(
                  organizationId: args.organizationId,
                  organizationName: args.organizationName,
                  isIndividual: false,
                ),
            settings: settings);

      case AppRoutes.individualDoctorsScreen:
        final args = settings.arguments as OrganizationArguments;
        return CupertinoPageRoute(
            builder: (_) => OrganizationDoctorsScreen(
                  organizationId: args.organizationId,
                  organizationName: args.organizationName,
                  isIndividual: true,
                ),
            settings: settings);

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('unknown route ${settings.name}'),
                  ),
                ));
    }
  }
}
