import 'dart:convert';

GetDoctorProfileModel getDoctorProfileModelFromJson(String str) =>
    GetDoctorProfileModel.fromJson(json.decode(str));

String getDoctorProfileModelToJson(GetDoctorProfileModel data) =>
    json.encode(data.toJson());

class GetDoctorProfileModel {
  String? status;
  Body? body;
  String? message;

  GetDoctorProfileModel({this.status, this.body, this.message});

  GetDoctorProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? name;
  String? email;
  String? mobileNum;
  String? dob;
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
  String? degree;
  String? experience;
  String? licenseExpirationDate;
  String? licenseNumber;
  String? npiNumber;
  String? organization;
  String? updatedAt;

  Body(
      {this.sId,
      this.name,
      this.email,
      this.mobileNum,
      this.dob,
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
      this.active,
      this.degree,
      this.experience,
      this.licenseExpirationDate,
      this.licenseNumber,
      this.npiNumber,
      this.organization,
      this.updatedAt});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobileNum = json['mobileNum'];
    dob = json['dob'];
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
    degree = json['degree'];
    experience = json['experience'];
    licenseExpirationDate = json['licenseExpirationDate'];
    licenseNumber = json['licenseNumber'];
    npiNumber = json['npiNumber'];
    organization = json['organization'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['mobileNum'] = mobileNum;
    data['dob'] = dob;
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
    data['degree'] = degree;
    data['experience'] = experience;
    data['licenseExpirationDate'] = licenseExpirationDate;
    data['licenseNumber'] = licenseNumber;
    data['npiNumber'] = npiNumber;
    data['organization'] = organization;
    data['updatedAt'] = updatedAt;
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
  String? startDate;
  String? endDate;
  String? description;
  String? specialty;
  String? organizationName;
  String? sId;

  Careerpath(
      {this.name,
      this.startDate,
      this.endDate,
      this.description,
      this.specialty,
      this.organizationName,
      this.sId});

  Careerpath.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    description = json['description'];
    specialty = json['specialty'];
    organizationName = json['organizationName'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['description'] = description;
    data['specialty'] = specialty;
    data['organizationName'] = organizationName;
    data['_id'] = sId;
    return data;
  }
}
