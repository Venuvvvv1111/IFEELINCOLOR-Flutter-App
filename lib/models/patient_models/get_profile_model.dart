import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) =>
    GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) =>
    json.encode(data.toJson());

class GetProfileModel {
  String? status;
  Body? body;
  String? message;

  GetProfileModel({this.status, this.body, this.message});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  String? email;
  String? dateOfBirth;
  String? mobile;
  String? guardian;
  String? verified;
  int? score;
  int? iV;
  String? privacy;
  String? image;
  String? location;
  Address? address;

  Body(
      {this.sId,
      this.userName,
      this.email,
      this.dateOfBirth,
      this.mobile,
      this.guardian,
      this.verified,
      this.score,
      this.iV,
      this.privacy,
      this.image,
      this.location,
      this.address});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    mobile = json['mobile'];
    guardian = json['guardian'];
    verified = json['verified'];
    score = json['score'];
    iV = json['__v'];
    privacy = json['privacy'];
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
    data['guardian'] = guardian;
    data['verified'] = verified;
    data['score'] = score;
    data['__v'] = iV;
    data['privacy'] = privacy;
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
