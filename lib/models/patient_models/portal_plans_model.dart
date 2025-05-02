import 'dart:convert';

PortalPlansModel portalPlansModelFromJson(String str) =>
    PortalPlansModel.fromJson(json.decode(str));

String portalPlansModelToJson(PortalPlansModel data) =>
    json.encode(data.toJson());

class PortalPlansModel {
  String? status;
  List<Body>? body;
  String? message;

  PortalPlansModel({this.status, this.body, this.message});

  PortalPlansModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? price;
  String? details;
  int? validity;

  String? createdBy;
  String? planType;
  // String? createdAt;
  // String? updatedAt;
  // int? iV;

  Body({
    this.sId,
    this.name,
    this.price,
    this.details,
    this.validity,
    // this.status,
    this.createdBy,
    this.planType,
    // this.createdAt,
    // this.updatedAt,
    // this.iV
  });

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    details = json['details'];
    validity = json['validity'];
    // status = json['status'];
    createdBy = json['createdBy'];
    planType = json['planType'];
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['details'] = details;
    data['validity'] = validity;
    // data['status'] = this.status;
    data['createdBy'] = createdBy;
    data['planType'] = planType;
    // data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    return data;
  }
}
