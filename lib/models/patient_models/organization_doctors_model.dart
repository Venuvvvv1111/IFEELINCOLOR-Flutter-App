import 'dart:convert';

OrganizationDoctorsModel organizationDoctorsModelFromJson(String str) =>
    OrganizationDoctorsModel.fromJson(json.decode(str));

String organizationDoctorsModelToJson(OrganizationDoctorsModel data) =>
    json.encode(data.toJson());

class OrganizationDoctorsModel {
  String? status;
  List<OrganizationDoctorsData>? body;
  String? message;

  OrganizationDoctorsModel({this.status, this.body, this.message});

  OrganizationDoctorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <OrganizationDoctorsData>[];
      json['body'].forEach((v) {
        body!.add(OrganizationDoctorsData.fromJson(v));
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

class OrganizationDoctorsData {
  String? experience;

  String? sId;
  String? name;
  String? email;
  String? mobileNum;
  String? dob;
  String? password;
  String? specializedIn;

  String? about;
  String? services;
  String? verified;
  String? licenseImage;

  String? image;
  List<Careerpath>? careerpath;
  String? experince;
  String? highlights;
  String? location;
  String? ratings;
  String? distance;

  PlanDetails? planDetails;

  OrganizationDoctorsData(
      {this.experience,
      this.sId,
      this.name,
      this.email,
      this.mobileNum,
      this.dob,
      this.password,
      this.specializedIn,
      this.about,
      this.services,
      this.verified,
      this.licenseImage,
      this.image,
      this.careerpath,
      this.experince,
      this.highlights,
      this.location,
      this.ratings,
      this.distance,
      this.planDetails});

  OrganizationDoctorsData.fromJson(Map<String, dynamic> json) {
    experience = json['experience'];

    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobileNum = json['mobileNum'] ?? "";
    dob = json['dob'];

    specializedIn = json['specializedIn'];

    about = json['about'];
    services = json['services'] ?? "";

    image = json['image'] ?? '';
    if (json['careerpath'] != null) {
      careerpath = <Careerpath>[];
      json['careerpath'].forEach((v) {
        careerpath!.add(Careerpath.fromJson(v));
      });
    }
    experince = json['experince'] ?? "";
    highlights = json['highlights'] ?? "";
    location = json['location'] ?? '';
    ratings = json['ratings'] ?? '4.0';
    distance = json['distance'] ?? "";

    planDetails = json['planDetails'] != null
        ? PlanDetails.fromJson(json['planDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['experience'] = experience;

    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['mobileNum'] = mobileNum;
    data['dob'] = dob;
    data['password'] = password;
    data['specializedIn'] = specializedIn;

    data['about'] = about;
    data['services'] = services;
    data['verified'] = verified;
    data['licenseImage'] = licenseImage;

    data['image'] = image;
    if (careerpath != null) {
      data['careerpath'] = careerpath!.map((v) => v.toJson()).toList();
    }
    data['experince'] = experince;
    data['highlights'] = highlights;
    data['location'] = location;
    data['ratings'] = ratings;
    data['distance'] = distance;

    if (planDetails != null) {
      data['planDetails'] = planDetails!.toJson();
    }
    return data;
  }
}

class Careerpath {
  String? name;
  String? duration;
  String? description;
  String? sId;

  Careerpath({this.name, this.duration, this.description, this.sId});

  Careerpath.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    duration = json['duration'];
    description = json['description'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['duration'] = duration;
    data['description'] = description;
    data['_id'] = sId;
    return data;
  }
}

class PlanDetails {
  String? sId;
  String? name;
  double? price;
  String? details;
  int? validity;
  String? status;
  String? createdBy;
  String? planType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PlanDetails(
      {this.sId,
      this.name,
      this.price,
      this.details,
      this.validity,
      this.status,
      this.createdBy,
      this.planType,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    details = json['details'];
    validity = json['validity'];
    status = json['status'];
    createdBy = json['createdBy'];
    planType = json['planType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['details'] = details;
    data['validity'] = validity;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['planType'] = planType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
