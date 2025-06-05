import 'dart:convert';

DoctorAppSubscribedSubscriptionsModel
    doctorAppSubscribedSubscriptionsModelFromJson(String str) =>
        DoctorAppSubscribedSubscriptionsModel.fromJson(json.decode(str));

String mySubscriptionsModelToJson(DoctorAppSubscribedSubscriptionsModel data) =>
    json.encode(data.toJson());

class DoctorAppSubscribedSubscriptionsModel {
  String? status;
  List<Body>? body;
  String? message;

  DoctorAppSubscribedSubscriptionsModel({this.status, this.body, this.message});

  DoctorAppSubscribedSubscriptionsModel.fromJson(Map<String, dynamic> json) {
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
  double? price;
  String? startDate;
  String? endDate;
  int? validity;
  bool? renewal;
  bool? active;
  Plan? plan;
  String? createdAt;
  String? updatedAt;

  Body(
      {this.sId,
      this.price,
      this.startDate,
      this.endDate,
      this.validity,
      this.renewal,
      this.active,
      this.plan,
      this.createdAt,
      this.updatedAt});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    final rawPrice = json['price'];
     if (rawPrice is int) {
    price = rawPrice.toDouble();
  } else if (rawPrice is double) {
    price = rawPrice;
  }
    startDate = json['startDate'];
    endDate = json['endDate'];
    validity = json['validity'];
    renewal = json['renewal'];
    active = json['active'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['price'] = price;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['validity'] = validity;
    data['renewal'] = renewal;
    data['active'] = active;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Plan {
  String? sId;
  String? name;
  double? price;
  String? details;
  int? validity;
  String? planType;
  bool? active;

  Plan(
      {this.sId,
      this.name,
      this.price,
      this.details,
      this.validity,
      this.planType,
      this.active});

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
    planType = json["planType"];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['details'] = details;
    data['validity'] = validity;
    data['active'] = active;
    data["planType"] = planType;
    return data;
  }
}
