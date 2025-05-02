import 'dart:convert';

PrivacyPolicyModel privacyPolicyModelFromJson(String str) =>
    PrivacyPolicyModel.fromJson(json.decode(str));

String privacyPolicyModelToJson(PrivacyPolicyModel data) =>
    json.encode(data.toJson());

class PrivacyPolicyModel {
  String? status;
  Body? body;
  String? message;

  PrivacyPolicyModel({this.status, this.body, this.message});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? content;
  String? updatedAt;
  int? iV;

  Body({this.sId, this.title, this.content, this.updatedAt, this.iV});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['content'] = content;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
