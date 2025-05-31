import 'dart:convert';

PatientsRecomendationsModel patientsRecomendationsModelFromJson(String str) =>
    PatientsRecomendationsModel.fromJson(json.decode(str));

String patientsRecomendationsModelToJson(PatientsRecomendationsModel data) =>
    json.encode(data.toJson());

class PatientsRecomendationsModel {
  String? status;
  List<Body>? body;
  String? message;

  PatientsRecomendationsModel({this.status, this.body, this.message});

  PatientsRecomendationsModel.fromJson(Map<String, dynamic> json) {
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
  String? recommendation;
  RelatedMedia? relatedMedia;
  RecommendedBy? recommendedBy;
  String? recommendedTo;
  String? type;
  String? timestamp;
  int? iV;

  Body(
      {this.sId,
      this.recommendation,
      this.relatedMedia,
      this.recommendedBy,
      this.recommendedTo,
      this.type,
      this.timestamp,
      this.iV});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recommendation = json['recommendation'];
    relatedMedia = json['relatedMedia'] != null
        ? RelatedMedia.fromJson(json['relatedMedia'])
        : null;
    recommendedBy = json['recommendedBy'] != null
        ? RecommendedBy.fromJson(json['recommendedBy'])
        : null;
    recommendedTo = json['recommendedTo'];
    type = json['type'];
    timestamp = json['timestamp'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['recommendation'] = recommendation;
    if (relatedMedia != null) {
      data['relatedMedia'] = relatedMedia!.toJson();
    }
    if (recommendedBy != null) {
      data['recommendedBy'] = recommendedBy!.toJson();
    }
    data['recommendedTo'] = recommendedTo;
    data['type'] = type;
    data['timestamp'] = timestamp;
    data['__v'] = iV;
    return data;
  }
}

class RelatedMedia {
  List<Images>? images;
  List<Documents>? documents;
  List<Videos>? videos;
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
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
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

class Videos {
  String? url;
  String? publicId;
  String? sId;

  Videos({this.url, this.publicId, this.sId});

  Videos.fromJson(Map<String, dynamic> json) {
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

  String? about;
  String? services;
  String? verified;
  String? licenseImage;
  int? iV;
  String? image;

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
      this.about,
      this.services,
      this.verified,
      this.licenseImage,
      this.iV,
      this.image,
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

    about = json['about'];
    services = json['services'];
    verified = json['verified'];
    licenseImage = json['licenseImage'];
    iV = json['__v'];
    image = json['image'];

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

    data['about'] = about;
    data['services'] = services;
    data['verified'] = verified;
    data['licenseImage'] = licenseImage;
    data['__v'] = iV;
    data['image'] = image;

    data['experince'] = experince;
    data['highlights'] = highlights;
    data['location'] = location;
    data['ratings'] = ratings;
    return data;
  }
}
