import 'dart:convert';

PortalRecomendationModel portalRecomendationModelFromJson(String str) =>
    PortalRecomendationModel.fromJson(json.decode(str));

String portalRecomendationModelToJson(PortalRecomendationModel data) =>
    json.encode(data.toJson());

class PortalRecomendationModel {
  String? status;
  List<Body>? body;
  String? message;

  PortalRecomendationModel({this.status, this.body, this.message});

  PortalRecomendationModel.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? timestamp;
  int? iV;

  Body(
      {this.sId,
      this.category,
      this.recommendation,
      this.relatedMedia,
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
