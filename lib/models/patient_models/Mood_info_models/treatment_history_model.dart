import 'dart:convert';

TreatmentHistoryModel treatmentHistoryModelFromJson(String str) =>
    TreatmentHistoryModel.fromJson(json.decode(str));

String treatmentHistoryModelToJson(TreatmentHistoryModel data) =>
    json.encode(data.toJson());

class TreatmentHistoryModel {
  String? status;
  Body? body;
  String? message;

  TreatmentHistoryModel({this.status, this.body, this.message});

  TreatmentHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? treatmentHistory;
  List<String>? socialInformation;
  List<String>? medicalHistory;

  Body({this.treatmentHistory, this.socialInformation, this.medicalHistory});

  Body.fromJson(Map<String, dynamic> json) {
    treatmentHistory = json['treatmentHistory'].cast<String>();
    socialInformation = json['socialInformation'].cast<String>();
    medicalHistory = json['medicalHistory'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['treatmentHistory'] = treatmentHistory;
    data['socialInformation'] = socialInformation;
    data['medicalHistory'] = medicalHistory;
    return data;
  }
}
