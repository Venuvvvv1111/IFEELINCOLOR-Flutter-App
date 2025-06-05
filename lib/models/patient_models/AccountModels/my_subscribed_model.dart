import 'dart:convert';

MySubscriptionsModel mySubscriptionsModelFromJson(String str) =>
    MySubscriptionsModel.fromJson(json.decode(str));

String mySubscriptionsModelToJson(MySubscriptionsModel data) =>
    json.encode(data.toJson());

class MySubscriptionsModel {
  String? status;
  List<Body>? body;
  String? message;

  MySubscriptionsModel({this.status, this.body, this.message});

  MySubscriptionsModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? patient;
  Plan? plan;
  String? clinisist;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  String? clinicianName;

  Body(
      {this.sId,
      this.patient,
      this.plan,
      this.clinisist,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
  
      this.clinicianName});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient = json['patient'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    clinisist = json['clinisist'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    clinicianName = json['clinicianName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['patient'] = patient;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    data['clinisist'] = clinisist;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    data['clinicianName'] = clinicianName;
    return data;
  }
}

class Plan {
  String? sId;
  String? name;
  double? price;
  String? details;
  int? validity;
  String? status;
  CreatedBy? createdBy;
  String? planType;
  String? createdAt;
  String? updatedAt;


  Plan(
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
    });

  Plan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    final rawPrice = json['price'];
  if (rawPrice is int) {
    price = rawPrice.toDouble();
  } else if (rawPrice is double) {
    price = rawPrice;
  }
    details = json['details'];
    validity = json['validity'];
    status = json['status'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    planType = json['planType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['details'] = details;
    data['validity'] = validity;
    data['status'] = status;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['planType'] = planType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}

class CreatedBy {
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

  String? image;
  List<Careerpath>? careerpath;
  String? experince;
  String? highlights;
  String? location;
  String? ratings;

  CreatedBy(
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
 
      this.image,
      this.careerpath,
      this.experince,
      this.highlights,
      this.location,
      this.ratings});

  CreatedBy.fromJson(Map<String, dynamic> json) {
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

    data['image'] = image;
    if (careerpath != null) {
      data['careerpath'] = careerpath!.map((v) => v.toJson()).toList();
    }
    data['experince'] = experince;
    data['highlights'] = highlights;
    data['location'] = location;
    data['ratings'] = ratings;
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
