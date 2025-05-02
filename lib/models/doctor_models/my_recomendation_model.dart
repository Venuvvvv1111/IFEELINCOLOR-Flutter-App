import 'dart:convert';

MyRecomendedPatientsModel myRecomendedPatientsModelFromJson(String str) =>
    MyRecomendedPatientsModel.fromJson(json.decode(str));

class MyRecomendedPatientsModel {
  String? status;
  List<MyRecomendations>? body;
  String? message;

  MyRecomendedPatientsModel({this.status, this.body, this.message});

  MyRecomendedPatientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <MyRecomendations>[];
      json['body'].forEach((v) {
        body!.add(MyRecomendations.fromJson(v));
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

class MyRecomendations {
  Patient? patient;
  List<Recommendations>? recommendations;

  MyRecomendations({this.patient, this.recommendations});

  MyRecomendations.fromJson(Map<String, dynamic> json) {
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
    if (json['recommendations'] != null) {
      recommendations = <Recommendations>[];
      json['recommendations'].forEach((v) {
        recommendations!.add(Recommendations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    if (recommendations != null) {
      data['recommendations'] =
          recommendations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Patient {
  String? sId;
  String? userName;
  String? email;
  String? dateOfBirth;
  String? mobile;

  Patient({this.sId, this.userName, this.email, this.dateOfBirth, this.mobile});

  Patient.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['email'] = email;
    data['dateOfBirth'] = dateOfBirth;
    data['mobile'] = mobile;
    return data;
  }
}

class Recommendations {
  String? sId;
  String? recommendation;
  RelatedMedia? relatedMedia;
  RecommendedBy? recommendedBy;
  String? recommendedTo;
  String? type;
  String? timestamp;

  Recommendations(
      {this.sId,
      this.recommendation,
      this.relatedMedia,
      this.recommendedBy,
      this.recommendedTo,
      this.type,
      this.timestamp});

  Recommendations.fromJson(Map<String, dynamic> json) {
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

class RecommendedBy {
  String? sId;
  String? name;

  RecommendedBy({this.sId, this.name});

  RecommendedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
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
