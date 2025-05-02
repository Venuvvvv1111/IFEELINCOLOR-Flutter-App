import 'dart:convert';

import 'package:ifeelin_color/models/patient_models/Mood_info_models/body_questions_model.dart';

GetAssesmentQuestionsModel getAssesmentQuestionsModelFromJson(String str) =>
    GetAssesmentQuestionsModel.fromJson(json.decode(str));

String getAssesmentQuestionsModelToJson(GetAssesmentQuestionsModel data) =>
    json.encode(data.toJson());

class GetAssesmentQuestionsModel {
  String? status;
  List<Body>? body;
  String? message;

  GetAssesmentQuestionsModel({this.status, this.body, this.message});

  GetAssesmentQuestionsModel.fromJson(Map<String, dynamic> json) {
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
  String? question;
  String? answer;
  String? type;
  int? score;
  String? media;
  int? iV;
  Category? category; // Updated to Category
  List<McqOptions>? mcqOptions;

  Body(
      {this.sId,
      this.question,
      this.answer,
      this.type,
      this.score,
      this.media,
      this.iV,
      this.category,
      this.mcqOptions});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    answer = json['answer'];
    type = json['type'];
    score = json['score'];
    media = json['media'];
    iV = json['__v'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['mcqOptions'] != null) {
      mcqOptions = <McqOptions>[];
      json['mcqOptions'].forEach((v) {
        mcqOptions!.add(McqOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    data['answer'] = answer;
    data['type'] = type;
    data['score'] = score;
    data['media'] = media;
    data['__v'] = iV;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (mcqOptions != null) {
      data['mcqOptions'] = mcqOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? sId;
  String? mood;
  String? hexColor;
  String? description;
  int? iV;

  Category({this.sId, this.mood, this.hexColor, this.description, this.iV});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mood = json['mood'];
    hexColor = json['hexColor'];
    description = json['description'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mood'] = mood;
    data['hexColor'] = hexColor;
    data['description'] = description;
    data['__v'] = iV;
    return data;
  }
}
