import 'dart:convert';

SubscribedPatientsModel subscribedPatientsModelFromJson(String str) =>
    SubscribedPatientsModel.fromJson(json.decode(str));

String subscribedPatientsModelToJson(SubscribedPatientsModel data) =>
    json.encode(data.toJson());

class SubscribedPatientsModel {
  String? status;
  List<SubscribedBody>? body;
  String? message;

  SubscribedPatientsModel({this.status, this.body, this.message});

  SubscribedPatientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <SubscribedBody>[];
      json['body'].forEach((v) {
        body!.add(SubscribedBody.fromJson(v));
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

class SubscribedBody {
  Patient? patient;
  Subscription? subscription;

  SubscribedBody({this.patient, this.subscription});

  SubscribedBody.fromJson(Map<String, dynamic> json) {
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
      this.location});

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
