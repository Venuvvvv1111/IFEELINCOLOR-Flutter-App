import 'dart:convert';

OrganizationModel organizationModelFromJson(String str) =>
    OrganizationModel.fromJson(json.decode(str));

class OrganizationModel {
  String? status;
  List<OrganizationsData>? body;
  String? message;

  OrganizationModel({this.status, this.body, this.message});

  OrganizationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <OrganizationsData>[];
      json['body'].forEach((v) {
        body!.add(OrganizationsData.fromJson(v));
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

class OrganizationsData {
  SocialProfile? socialProfile;
  String? sId;
  String? name;
  String? email;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? mobile;
  String? image;
  String? address;
  String? companyName;
  String? established;
  String? founder;
  bool? active;
  bool? verified;
  String? certificate;

  OrganizationsData(
      {this.socialProfile,
      this.sId,
      this.name,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.mobile,
      this.image,
      this.address,
      this.companyName,
      this.established,
      this.founder,
      this.active,
      this.verified,
      this.certificate});

  OrganizationsData.fromJson(Map<String, dynamic> json) {
    socialProfile = json['socialProfile'] != null
        ? SocialProfile.fromJson(json['socialProfile'])
        : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    mobile = json['mobile'];
    image = json['image'];
    address = json['address'];
    companyName = json['companyName'];
    established = json['established'];
    founder = json['founder'];
    active = json['active'];
    verified = json['verified'];
    certificate = json['certificate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (socialProfile != null) {
      data['socialProfile'] = socialProfile!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['mobile'] = mobile;
    data['image'] = image;
    data['address'] = address;
    data['companyName'] = companyName;
    data['established'] = established;
    data['founder'] = founder;
    data['active'] = active;
    data['verified'] = verified;
    data['certificate'] = certificate;
    return data;
  }
}

class SocialProfile {
  String? instagram;
  String? twitter;
  String? facebook;
  String? linkedin;

  SocialProfile({this.instagram, this.twitter, this.facebook, this.linkedin});

  SocialProfile.fromJson(Map<String, dynamic> json) {
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    data['facebook'] = facebook;
    data['linkedin'] = linkedin;
    return data;
  }
}

class OrganizationArguments {
  final String organizationId;
  final String organizationName;
  final bool isIndividual;

  OrganizationArguments({
    required this.organizationId,
    required this.organizationName,
    required this.isIndividual,
  });
}
