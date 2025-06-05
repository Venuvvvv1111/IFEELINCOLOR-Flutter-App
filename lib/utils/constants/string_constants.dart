class Constants {
  static const kMonthsList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  static const int appId = 1565574114;
  static const String appSign =
      "800faa6ea313423c8f0065d9163ccfdecba172997b717b0666f00bbe2e83baaf";
//local
  static const String baseUrl = "https://ifeelincolorvps.projexino.com/api";
  //emulator
  // static const String baseUrl = "http://10.0.2.2:3000/api";
  //render
  // static const String baseUrl = "https://rough-1-gcic.onrender.com/api";
  //aws
  // static const String baseUrl = "http://18.209.44.54:3000/api";

  static const String department = "department";
  static const String doctor = "doctor";
  static const String updateProfile = "patients/updatePatient";
  static const String updateProfileImage = "media/image";
  static const String updateHistory = "patients/update-history";
  static const String changePassword = "patients/change-password";
  static const String resetPassword = "auth/request-password-reset";
  static const String login = "auth/patient-login";
  static const String getProfile = "patients/profile";
  static const String register = "auth/patient-register";
  static const String listOrgDoctorPlans = "patients/list-organization-plans";
  static const String listIndDoctorPlans = "patients/list-doctor-plans";
  static const String listPortalPlans = "patients/list-portal-plans";
  static const String getSubscribedPlans = "patients/profile/my-subscriptions";
  static const String getNotification = "patients/notifications";
  static const String getNearestDoctors = "patients/get-nearest-doctors";
  static const String getsubscribeDoctors = "patients/subscribed-doctors";
  static const String doctorRecommendations = "rec/doctor_recommendations";
  static const String portalRecommendations = "rec/portal_recommendations";
  static const String assesmentTestQuestions = "test";
  static const String assesmentsubmit = "test/take-assessment";
  static const String level2Assesmentsubmit = "patients/mood-assessment";
  static const String patientNotifications = "patients/notifications";
  static const String sendAlert = "patients/alert";
  static const String mySubscriptions = "patients/profile/my-subscriptions";
  static const String subscribeToDoctor = "patients/subscribe-to";
  static const String patientSubscriptionCheck =
      "patients/check-active-subscription";
  static const String doctorSubscriptionCheckViaId =
      "patients/check-patient-clinicist-subscription";
  static const String allOrganizationListUrl =
      "patients/list-all-organizations";
  static const String getOrganizationDoctorsUrl =
      "patients/get-organization-doctors";
  static const String getIndividualDoctorsUrl = "patients/get-doctors";

  //doctor apis
  static const String doctorRegister = "auth/doctor-register";
  static const String doctorSubscriptionCheck =
      "doctor/check-active-subscription";
  static const String intakeDetailsUrl =
      "doctor/subscribed-patient-assessment-infos";

  static const String doctorApplistPortalPlans = "clinicistPlan";

  static const String doctorLogin = "auth/doctor-login";
  static const String subscribedPatients = "doctor/subscribed-patients";
  static const String patientRecommendations =
      "rec/recommendations-for-subscribed-patient";
  static const String doctorPortalRecommendations =
      "rec/portal-recommendations-for-patient";
  static const String getDoctorProfileURL = "doctor/profile";

  static const String addRecomendationURL = "rec/create-doctor-rec";
  static const String nearbySubscribedPatients =
      "doctor/nearby-subscribed-patients-assessments";
  static const String salesStatsURL = "doctor/sales-stats";
  static const String recommendationStatsURL = "doctor/recommendation-stats";

  static const String subscriptionStatsURL = "doctor/subscription-stats";
  static const String allRecomendedPatientsURL = "doctor/recommended-patients";
  static const String updateDoctorPrifileURL = "doctor/update-doctor";
  static const String updateDoctorProfileImage = "doctor/update-dp";
  static const String faqURL = "faq";

  static const String doctorChangePassword = "doctor/update-password";
  static const String getNearbyPatients =
      "doctor/nearby-subscribed-patients-assessments";
  static const String allSubscribedPatientsURL = "doctor/subscribed-patients";
  static const String announcementUrl = "announcement";
  static const String doctorAppPortalSubscriptionsUrl =
      "doctorSub/clinician-subscriptions";
  static const String doctorAppSubscribeToPortal = "doctorSub/create";
  static const String doctorAppNotifications = "doctor/notifications";

  static const String notificationStatusChange = "notification-alerts";

 static const String chekPreviusSubscriptionPatient = "patients/check-previous-subscription";
  static const String chekPreviusSubscriptionDoctor = "doctorsub/check-previous-subscription";

}
