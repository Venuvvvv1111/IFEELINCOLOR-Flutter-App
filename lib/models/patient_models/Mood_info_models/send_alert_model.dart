import 'dart:convert';

SendAlertModel sendAlertModelFromJson(String str) =>
    SendAlertModel.fromJson(json.decode(str));

String sendAlertModelToJson(SendAlertModel data) => json.encode(data.toJson());

class SendAlertModel {
  String? status;
  Body? body;
  String? message;

  SendAlertModel({this.status, this.body, this.message});

  SendAlertModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  NewAlert? newAlert;
  AlertMessage? alertMessage;

  Body({this.newAlert, this.alertMessage});

  Body.fromJson(Map<String, dynamic> json) {
    newAlert =
        json['newAlert'] != null ? NewAlert.fromJson(json['newAlert']) : null;
    alertMessage = json['alertMessage'] != null
        ? AlertMessage.fromJson(json['alertMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (newAlert != null) {
      data['newAlert'] = newAlert!.toJson();
    }
    if (alertMessage != null) {
      data['alertMessage'] = alertMessage!.toJson();
    }
    return data;
  }
}

class NewAlert {
  String? patientName;
  String? patientMobileNum;
  PatientLocation? patientLocation;
  double? distance;
  String? nearestClinisistName;
  String? nearestClinisistId;
  PatientLocation? nearestClinisistLocation;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NewAlert(
      {this.patientName,
      this.patientMobileNum,
      this.patientLocation,
      this.distance,
      this.nearestClinisistName,
      this.nearestClinisistId,
      this.nearestClinisistLocation,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NewAlert.fromJson(Map<String, dynamic> json) {
    patientName = json['patient_name'];
    patientMobileNum = json['patient_mobile_num'];
    patientLocation = json['patient_location'] != null
        ? PatientLocation.fromJson(json['patient_location'])
        : null;
    distance = json['distance'];
    nearestClinisistName = json['nearest_clinisist_name'];
    nearestClinisistId = json['nearest_clinisist_id'];
    nearestClinisistLocation = json['nearest_clinisist_location'] != null
        ? PatientLocation.fromJson(json['nearest_clinisist_location'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_name'] = patientName;
    data['patient_mobile_num'] = patientMobileNum;
    if (patientLocation != null) {
      data['patient_location'] = patientLocation!.toJson();
    }
    data['distance'] = distance;
    data['nearest_clinisist_name'] = nearestClinisistName;
    data['nearest_clinisist_id'] = nearestClinisistId;
    if (nearestClinisistLocation != null) {
      data['nearest_clinisist_location'] = nearestClinisistLocation!.toJson();
    }
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class PatientLocation {
  double? latitude;
  double? longitude;

  PatientLocation({this.latitude, this.longitude});

  PatientLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class AlertMessage {
  String? warning;
  List<String>? steps;

  AlertMessage({this.warning, this.steps});

  AlertMessage.fromJson(Map<String, dynamic> json) {
    warning = json['warning'];
    steps = json['steps'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warning'] = warning;
    data['steps'] = steps;
    return data;
  }
}
