class AppIcons {
  AppIcons._();

  static final String facebookIcon = 'facebook_icon.png'.iconPath;
  static final String logoIcon = 'logo_icon.png'.iconPath;
  static final String textLogo = 'text_logo.png'.iconPath;
  static final String subscribeClinicIcon =
      'subscribe_clinic_icon.png'.iconPath;
  static final String subscribePortalIcon =
      'subscribe_portal_icon.png'.iconPath;
  static final String rightArrowIcon = 'right_arrow.png'.iconPath;
  static final String doctorIcon = 'doctor_icon.png'.iconPath;
  static final String familyMentalHealthHistoryIcon =
      'family_mental_health_history_icon.png'.iconPath;
  static final String socialInformationIcon =
      'social_information_icon.png'.iconPath;
  static final String treatmentHistory = 'treatment_history.png'.iconPath;
  static final String profileIcon = 'profile_main_icon.png'.iconPath;
  static final String subscribeMainIcon = 'subscribe_main_icon.png'.iconPath;
  static final String paymentMenthodMainIcon = 'payment_main_icon.png'.iconPath;
  static final String privacyPolicyMainIcon = 'privacy_main_icon.png'.iconPath;
  static final String settingsMainIcon = 'settings_main_icon.png'.iconPath;
  static final String helpMainIcon = 'help_main_icon.png'.iconPath;
  static final String logoutMainIcon = 'logout_main_icon.png'.iconPath;
  static final String userPhoneIcon = 'user_phone_icon.png'.iconPath;
  static final String userMailIcon = 'user_mail_icon.png'.iconPath;
  static final String userLocationIcon = 'user_location_icon.png'.iconPath;
  static final String calenderIcon = 'calender_icon.png'.iconPath;
  static final String experienceIcon = 'experience_icon.png'.iconPath;
  static final String editIcon = 'edit_icon.png'.iconPath;
  static final String notificationIcon = 'notification_icon.png'.iconPath;
  static final String recomendationsBottomIcon =
      'recomendations_bottom_icon.png'.iconPath;
  static final String homeBottomIcon = 'home_bottom_icon.png'.iconPath;
  static final String moodInfoBottomIcon = 'mood_info_bottom_icon.png'.iconPath;
  static final String documentIcon = 'document_icon.png'.iconPath;
  static final String imageIcon = 'image_icon.png'.iconPath;
  static final String vedioIcon = 'vedio_icon.png'.iconPath;
  static final String chnagePasswordIcon = 'change_password_icon.png'.iconPath;
  static final String colorWeelIcon = 'colorWeelIcon.png'.iconPath;
  static final String pdfIcon = 'pdf.png'.iconPath;
  static final String videoLinkIcon = 'video_link.png'.iconPath;
  static final String sendAlert = 'send_alert.png'.iconPath;
  // static final String calender = 'calender.png'.iconPath;
}

extension Assets on String {
  static String get assetPath => 'assets/';
  String get iconPath => '${assetPath}icons/$this';
}
