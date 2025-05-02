import 'dart:convert';

SubscribedDoctorsModel subscribedDoctorsModelFromJson(String str) =>
    SubscribedDoctorsModel.fromJson(json.decode(str));

String subscribedDoctorsModelToJson(SubscribedDoctorsModel data) =>
    json.encode(data.toJson());

class SubscribedDoctorsModel {
  String? status;
  List<SubscribedList>? body;
  String? message;

  SubscribedDoctorsModel({this.status, this.body, this.message});

  SubscribedDoctorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <SubscribedList>[];
      json['body'].forEach((v) {
        body!.add(SubscribedList.fromJson(v));
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

class SubscribedList {
  Clinician? clinician;
  List<SubscribedPlans>? subscribedPlans;

  SubscribedList({this.clinician, this.subscribedPlans});

  SubscribedList.fromJson(Map<String, dynamic> json) {
    clinician = json['clinician'] != null
        ? Clinician.fromJson(json['clinician'])
        : null;
    if (json['subscribedPlans'] != null) {
      subscribedPlans = <SubscribedPlans>[];
      json['subscribedPlans'].forEach((v) {
        subscribedPlans!.add(SubscribedPlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (clinician != null) {
      data['clinician'] = clinician!.toJson();
    }
    if (subscribedPlans != null) {
      data['subscribedPlans'] =
          subscribedPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clinician {
  String? experience;
  String? organization;
  String? sId;
  String? name;
  String? email;
  String? mobileNum;
  String? dob;
  String? password;
  String? specializedIn;
  Address? address;
  String? about;
  String? services;
  String? verified;
  String? licenseImage;
  int? iV;
  String? image;
  List<Careerpath>? careerpath;
  String? experince;
  String? highlights;
  String? location;
  String? ratings;
  String? active;

  Clinician(
      {this.experience,
      this.organization,
      this.sId,
      this.name,
      this.email,
      this.mobileNum,
      this.dob,
      this.password,
      this.specializedIn,
      this.address,
      this.about,
      this.services,
      this.verified,
      this.licenseImage,
      this.iV,
      this.image,
      this.careerpath,
      this.experince,
      this.highlights,
      this.location,
      this.ratings,
      this.active});

  Clinician.fromJson(Map<String, dynamic> json) {
    experience = json['experience'];
    organization = json['organization'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobileNum = json['mobileNum'];
    dob = json['dob'];
    password = json['password'];
    specializedIn = json['specializedIn'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    about = json['about'];
    services = json['services'];
    verified = json['verified'];
    licenseImage = json['licenseImage'];
    iV = json['__v'];
    image = json['image'];
    if (json['careerpath'] != null) {
      careerpath = <Careerpath>[];
      json['careerpath'].forEach((v) {
        careerpath!.add(Careerpath.fromJson(v));
      });
    }
    experince = json['experince'];
    highlights = json['highlights'];
    location = json['location'];
    ratings = json['ratings'];
    active = json['Active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['experience'] = experience;
    data['organization'] = organization;
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['mobileNum'] = mobileNum;
    data['dob'] = dob;
    data['password'] = password;
    data['specializedIn'] = specializedIn;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['about'] = about;
    data['services'] = services;
    data['verified'] = verified;
    data['licenseImage'] = licenseImage;
    data['__v'] = iV;
    data['image'] = image;
    if (careerpath != null) {
      data['careerpath'] = careerpath!.map((v) => v.toJson()).toList();
    }
    data['experince'] = experince;
    data['highlights'] = highlights;
    data['location'] = location;
    data['ratings'] = ratings;
    data['Active'] = active;
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

class SubscribedPlans {
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

  SubscribedPlans(
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

  SubscribedPlans.fromJson(Map<String, dynamic> json) {
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
