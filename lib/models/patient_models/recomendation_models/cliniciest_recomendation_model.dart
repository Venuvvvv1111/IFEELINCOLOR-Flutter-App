import 'dart:convert';

DoctorRecomendationsModel doctorRecomendationsModelFromJson(String str) =>
    DoctorRecomendationsModel.fromJson(json.decode(str));

String doctorRecomendationsModelToJson(DoctorRecomendationsModel data) =>
    json.encode(data.toJson());

class DoctorRecomendationsModel {
  String? status;
  List<Body>? body;
  String? message;

  DoctorRecomendationsModel({this.status, this.body, this.message});

  DoctorRecomendationsModel.fromJson(Map<String, dynamic> json) {
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
  String? category;
  String? recommendation;
  RelatedMedia? relatedMedia;
  RecommendedBy? recommendedBy;
  String? type;
  String? timestamp;
  int? iV;

  Body(
      {this.sId,
      this.category,
      this.recommendation,
      this.relatedMedia,
      this.recommendedBy,
      this.type,
      this.timestamp,
      this.iV});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    recommendation = json['recommendation'];
    relatedMedia = json['relatedMedia'] != null
        ? RelatedMedia.fromJson(json['relatedMedia'])
        : null;
    recommendedBy = json['recommendedBy'] != null
        ? RecommendedBy.fromJson(json['recommendedBy'])
        : null;
    type = json['type'];
    timestamp = json['timestamp'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['category'] = category;
    data['recommendation'] = recommendation;
    if (relatedMedia != null) {
      data['relatedMedia'] = relatedMedia!.toJson();
    }
    if (recommendedBy != null) {
      data['recommendedBy'] = recommendedBy!.toJson();
    }
    data['type'] = type;
    data['timestamp'] = timestamp;
    data['__v'] = iV;
    return data;
  }
}

class RelatedMedia {
  List<Images>? images;
  List<Documents>? documents;
  List<Vedios>? videos;
  String? sId;

  RelatedMedia({this.images, this.documents, this.videos, this.sId});

  RelatedMedia.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <Vedios>[];
      json['videos'].forEach((v) {
        videos!.add(Vedios.fromJson(v));
      });
    }
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    return data;
  }
}

class Images {
  String? url;
  String? publicId;
  String? sId;

  Images({this.url, this.publicId, this.sId});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['public_id'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['public_id'] = publicId;
    data['_id'] = sId;
    return data;
  }
}

class Documents {
  String? url;
  String? publicId;
  String? sId;

  Documents({this.url, this.publicId, this.sId});

  Documents.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['public_id'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['public_id'] = publicId;
    data['_id'] = sId;
    return data;
  }
}

class Vedios {
  String? url;
  String? publicId;
  String? sId;

  Vedios({this.url, this.publicId, this.sId});

  Vedios.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['public_id'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['public_id'] = publicId;
    data['_id'] = sId;
    return data;
  }
}

class RecommendedBy {
  String? experience;
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

  RecommendedBy(
      {this.experience,
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
      this.ratings});

  RecommendedBy.fromJson(Map<String, dynamic> json) {
    experience = json['experience'];
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
