import 'dart:convert';

NearbySubscriptionDoctorsModel nearbySubscriptionDoctorsModelFromJson(
        String str) =>
    NearbySubscriptionDoctorsModel.fromJson(json.decode(str));

String nearbySubscriptionDoctorsModelToJson(
        NearbySubscriptionDoctorsModel data) =>
    json.encode(data.toJson());

class NearbySubscriptionDoctorsModel {
  String? status;
  List<NearbyBody>? body;
  String? message;

  NearbySubscriptionDoctorsModel({this.status, this.body, this.message});

  NearbySubscriptionDoctorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <NearbyBody>[];
      json['body'].forEach((v) {
        body!.add(NearbyBody.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class NearbyBody {
  Patient? patient;
  Subscription? subscription;
  LatestAssessment? latestAssessment;

  NearbyBody({this.patient, this.subscription, this.latestAssessment});

  NearbyBody.fromJson(Map<String, dynamic> json) {
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
    latestAssessment = json['latestAssessment'] != null
        ? LatestAssessment.fromJson(json['latestAssessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    if (latestAssessment != null) {
      data['latestAssessment'] = latestAssessment!.toJson();
    }
    return data;
  }
}

class Patient {
  String? sId;
  String? userName;
  String? email;
  String? dateOfBirth;
  String? mobile;
  Address? address;
  String? image;
    String? location;

  Patient(
      {this.sId,
      this.userName,
      this.email,
      this.dateOfBirth,
      this.mobile,
      this.address,
      this.image,
      this.location
      });

  Patient.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    mobile = json['mobile'];
      image = json['image'];
    location = json['location'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['email'] = email;
    data['dateOfBirth'] = dateOfBirth;
    data['mobile'] = mobile;
        data['image'] = image;
    if (address != null) {
      data['address'] = address!.toJson();
    }
        data['location'] = location;
    return data;
  }
}

class Address {
  double? latitude;
  double? longitude;
  String? sId;

  Address({this.latitude, this.longitude, this.sId});

  Address.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['_id'] = sId;
    return data;
  }
}

class Subscription {
  String? planName;
  String? startDate;
  String? endDate;
  bool? renewal;

  Subscription({this.planName, this.startDate, this.endDate, this.renewal});

  Subscription.fromJson(Map<String, dynamic> json) {
    planName = json['planName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    renewal = json['renewal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planName'] = planName;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['renewal'] = renewal;
    return data;
  }
}

class LatestAssessment {
  String? sId;
  String? patientId;
  String? mood;
  String? moodLevel;
  String? createdAt;
  String? updatedAt;

  LatestAssessment({
    this.sId,
    this.patientId,
    this.mood,
    this.moodLevel,
    this.createdAt,
    this.updatedAt,
  });

  LatestAssessment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patientId = json['patientId'];
    mood = json['mood'];
    moodLevel = json['moodLevel'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['patientId'] = patientId;
    data['mood'] = mood;
    data['moodLevel'] = moodLevel;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}
