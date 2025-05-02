import 'dart:convert';

SubscriptionPatientsModel subscriptionPatientsModelFromJson(String str) =>
    SubscriptionPatientsModel.fromJson(json.decode(str));

String subscriptionPatientsModelToJson(SubscriptionPatientsModel data) =>
    json.encode(data.toJson());

class SubscriptionPatientsModel {
  String? status;
  List<Body>? body;
  String? message;

  SubscriptionPatientsModel({this.status, this.body, this.message});

  SubscriptionPatientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body!.add(Body.fromJson(v));
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

class Body {
  Patient? patient;
  Subscription? subscription;

  Body({this.patient, this.subscription});

  Body.fromJson(Map<String, dynamic> json) {
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
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
    return data;
  }
}

class Patient {
  String? sId;
  String? userName;
  String? email;
  String? password;
  String? dateOfBirth;
  String? mobile;
  String? guardian;
  String? verified;
  int? score;
  int? iV;
  String? privacy;
  String? resetPasswordExpires;
  String? resetPasswordToken;
  String? image;
  String? location;
  Address? address;

  Patient(
      {this.sId,
      this.userName,
      this.email,
      this.password,
      this.dateOfBirth,
      this.mobile,
      this.guardian,
      this.verified,
      this.score,
      this.iV,
      this.privacy,
      this.resetPasswordExpires,
      this.resetPasswordToken,
      this.image,
      this.location,
      this.address});

  Patient.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    dateOfBirth = json['dateOfBirth'];
    mobile = json['mobile'];
    guardian = json['guardian'];
    verified = json['verified'];
    score = json['score'];
    iV = json['__v'];
    privacy = json['privacy'];
    resetPasswordExpires = json['resetPasswordExpires'];
    resetPasswordToken = json['resetPasswordToken'];
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
    data['password'] = password;
    data['dateOfBirth'] = dateOfBirth;
    data['mobile'] = mobile;
    data['guardian'] = guardian;
    data['verified'] = verified;
    data['score'] = score;
    data['__v'] = iV;
    data['privacy'] = privacy;
    data['resetPasswordExpires'] = resetPasswordExpires;
    data['resetPasswordToken'] = resetPasswordToken;
    data['image'] = image;
    data['location'] = location;
    if (address != null) {
      data['address'] = address!.toJson();
    }
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
