import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserInfo extends GetxService {
  final _userData = GetStorage('user_data');
  RxBool isTtsEnabled = false.obs;
  RxBool isMoodInfoAlreadyRead = false.obs;
  GetStorage box = GetStorage();
  var userName = ''.obs;
  RxBool getTreatmentHistory = false.obs;
  RxBool getSocialHealthHistory = false.obs;
  RxBool getAssesment = false.obs;
  RxBool getBodyAssesment = false.obs;
  set addTreatmentHistory(bool url) {
    _userData.write('checkTreatmentHistory', url);
  }

  @override
  void onInit() {
    super.onInit();
    // Load the stored value into the observable when the service initializes
    isTtsEnabled.value = _userData.read('isTtsEnabled') ?? false;
    isMoodInfoAlreadyRead.value =
        _userData.read('isMoodInfoAlreadyRead') ?? false;

    getTreatmentHistory.value =
        _userData.read('checkTreatmentHistory') ?? false;
    getSocialHealthHistory.value =
        _userData.read('socialHealthHistory') ?? false;
    getAssesment.value = _userData.read('assesment') ?? false;
    getBodyAssesment.value = _userData.read('bodyAssesment') ?? false;
    userName.value = _userData.read('name') ?? 'Hi User';
  }

  set setTtsEnabled(bool value) {
    _userData.write('isTtsEnabled', value);
    isTtsEnabled.value = value;
  }

  void refreshData() async {
    // Fetch user data from API or service

    if (await _userData.read('assesment') == null ||
        await _userData.read('bodyAssesment') == null) {
      getAssesment.value = _userData.read('assesment') ?? false;
      getBodyAssesment.value = _userData.read('bodyAssesment') ?? false;
    } else {
      getAssesment.value = _userData.read('assesment') ?? false;
      getBodyAssesment.value = _userData.read('bodyAssesment') ?? false;
    }
    if (_userData.read('checkTreatmentHistory') == null) {
      getTreatmentHistory.value =
          _userData.read('checkTreatmentHistory') ?? false;
    } else {
      getTreatmentHistory.value =
          _userData.read('checkTreatmentHistory') ?? false;
    }
    if (_userData.read('socialHealthHistory') == null) {
      getSocialHealthHistory.value =
          _userData.read('socialHealthHistory') ?? false;
    } else {
      getSocialHealthHistory.value =
          _userData.read('socialHealthHistory') ?? false;
    }
  }

  set addSocialHealthHistory(bool url) {
    _userData.write('socialHealthHistory', url);
  }

  set setIsMoodInfoAlreadyReadEnabled(bool value) {
    _userData.write('isMoodInfoAlreadyRead', value);
  }

  set addAssesment(bool url) {
    _userData.write('assesment', url);
  }

  set addBodyAssesment(bool url) {
    _userData.write('bodyAssesment', url);
  }

  set addUserLogin(bool isLogin) {
    _userData.write('isLogin', isLogin);
  }

  set addDoctorLogin(bool isLogin) {
    _userData.write('isDoctorLogin', isLogin);
  }

  get getDoctorLogin {
    bool isLogin = _userData.read('isDoctorLogin') ?? false;

    return isLogin;
  }

  get getUserLogin {
    bool isLogin = _userData.read('isLogin') ?? false;

    return isLogin;
  }

  set addUserProfileUrl(String url) {
    _userData.write('url', url);
    if (kDebugMode) {
      print(url);
    }
  }

  set addDoctorRatings(String url) {
    _userData.write('ratings', url);
    if (kDebugMode) {
      print(url);
    }
  }

  get getDoctorRatings {
    String url = _userData.read('ratings') ?? '';

    if (kDebugMode) {
      print(url);
    }
    return url;
  }

  get getUserProfileUrl {
    String url = _userData.read('url') ?? '';

    if (kDebugMode) {
      print(url);
    }
    return url;
  }

  set addPatientId(String pId) {
    _userData.write('pId', pId);
  }

  get getPatientId {
    String pId = _userData.read('pId') ?? '';
    return pId;
  }

  set addUserToken(String token) {
    _userData.write('token', token);
    if (kDebugMode) {
      print('User data saved');
    }
  }

  get getUserToken {
    String token = _userData.read('token') ?? '';

    return token;
  }

  set addUserName(String name) {
    _userData.write('name', name);
    if (kDebugMode) {
      print('User name saved');
    }
    userName.value = name;
  }

  String getname = '';
  get getUserName {
    getname = _userData.read('name') ?? '';
    return getname;
  }

  get getUpdatedName {
    return getname;
  }

  set addUserEmail(String email) {
    _userData.write('email', email);
    if (kDebugMode) {
      print('User name saved');
    }
  }

  get getUserEmail {
    String email = _userData.read('email') ?? '';
    return email;
  }

  set addUserAdress(String adress) {
    _userData.write('adress', adress);
    if (kDebugMode) {
      print('Adress saved');
    }
  }

  set addUserLatitude(String latitude) {
    _userData.write('latitude', latitude);
    if (kDebugMode) {
      print('Adress latitude');
    }
  }

  set addUserLongitude(String longitude) {
    _userData.write('longitude', longitude);
    if (kDebugMode) {
      print('Adress longitude');
    }
  }

  get getUserLatitude {
    String latitude = _userData.read('latitude') ?? '';
    return latitude;
  }

  get getUserLongitude {
    String longitude = _userData.read('longitude') ?? '';
    return longitude;
  }

  get getUserExp {
    String email = _userData.read('exp') ?? '';
    return email;
  }

  set addExperince(String exp) {
    _userData.write('exp', exp);
    if (kDebugMode) {
      print('experience saved');
    }
  }

  get getUserAdress {
    String adress = _userData.read('adress') ?? '';
    return adress;
  }

  set addUserMobileNumber(String number) {
    _userData.write('number', number);
    if (kDebugMode) {
      print('User name saved');
    }
  }

  get getUserMobileNumber {
    String? number = _userData.read('number');
    return number;
  }

  set addUserDesignation(String design) {
    _userData.write('designation', design);
    if (kDebugMode) {
      print('User name saved');
    }
  }

  get getUserDesignation {
    String designation = _userData.read('designation') ?? '';
    return designation;
  }

  set addUserDepartment(String design) {
    _userData.write('department', design);
    if (kDebugMode) {
      print('User name saved');
    }
  }

  get getUserDepartment {
    String designation = _userData.read('department') ?? '';
    return designation;
  }

  set addUserId(String id) {
    _userData.write('id', id);
    if (kDebugMode) {
      print('User name saved');
    }
  }

  get getUserId {
    String id = _userData.read('id') ?? '';
    return id;
  }

  removeAssememt() {
    // getTreatmentHistory.value = false;
    // getSocialHealthHistory.value = false;
    getAssesment.value = false;
    getBodyAssesment.value = false;
    _userData.remove('assesment');
    _userData.remove('bodyAssesment');
    _userData.remove('socialHealthHistory');
    _userData.remove('checkTreatmentHistory');
  }

  removeData() {
    getTreatmentHistory.value = false;
    getSocialHealthHistory.value = false;
    getAssesment.value = false;
    getBodyAssesment.value = false;
    box.remove('isLogin');
    box.remove('isDoctorLogin');
    _userData.remove('checkTreatmentHistory');
    _userData.remove('socialHealthHistory');
    _userData.remove('assesment');
    _userData.remove('department');
    _userData.remove('url');
    _userData.remove('email');
    _userData.remove('number');
    _userData.remove("isLogin");
    _userData.remove("token");
    _userData.remove('isDoctorLogin');
    _userData.erase().then((value) {
      if (kDebugMode) {
        print('erased the data');
      }
    });
  }

  removeProfileData() {
    _userData.remove('url');
    _userData.remove('email');
    _userData.remove('number');
    _userData.remove('name');
  }
}
