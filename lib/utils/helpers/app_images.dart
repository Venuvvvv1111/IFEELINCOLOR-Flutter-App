class AppImages {
  AppImages._();

  static final String loginBackground = 'login_background.png'.imagePath;
  static final String loginBackgroundColor =
      'login_background_color.png'.imagePath;
  static final String subscribePlanImage = 'subscribe_plan_image.svg'.imagePath;
  static final String clinicFormIcon = 'clinic_form_icon.png'.imagePath;
  static final String dModelImage = '2d_model_image.png'.imagePath;
  static final String profileStaticImage = 'static_profile_image.png'.imagePath;
  static final String subscriptionTypeImage =
      'subscription_type_image.png'.imagePath;
  static final String summeryImage = 'summery_image.png'.imagePath;
  static final String highletsImage = 'highlets_image.png'.imagePath;
  static final String addRecomendationImage =
      'add_recomendation_image.png'.imagePath;
  static final String intakeImage = 'intake_image.png'.imagePath;
  static final String viewRecomendationImage =
      'view_recomendation_image.png'.imagePath;
  static final String loginPatientImage = 'login_patient_image.svg'.imagePath;

  static final String loginDoctorImage = 'login_doctor_image.svg'.imagePath;
  static final String loginOrganizationImage =
      'login_organization_image.svg'.imagePath;
}

extension Assets on String {
  static String get assetPath => 'assets/';
  String get imagePath => '${assetPath}images/$this';
}
