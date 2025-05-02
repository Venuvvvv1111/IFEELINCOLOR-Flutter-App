import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  String? status;
  List<Body>? body;
  String? message;

  NotificationsModel({this.status, this.body, this.message});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
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
  Recipient? recipient;
  Recipient? sender;
  String? sId;
  String? type;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Body(
      {this.recipient,
      this.sender,
      this.sId,
      this.type,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Body.fromJson(Map<String, dynamic> json) {
    recipient = json['recipient'] != null
        ? Recipient.fromJson(json['recipient'])
        : null;
    sender = json['sender'] != null ? Recipient.fromJson(json['sender']) : null;
    sId = json['_id'];
    type = json['type'];
    message = json['message'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recipient != null) {
      data['recipient'] = recipient!.toJson();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    data['_id'] = sId;
    data['type'] = type;
    data['message'] = message;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Recipient {
  String? id;
  String? model;

  Recipient({this.id, this.model});

  Recipient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    return data;
  }
}
