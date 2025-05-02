import 'dart:convert';

BodyQuestionsModel bodyQuestionsModelFromJson(String str) =>
    BodyQuestionsModel.fromJson(json.decode(str));

String bodyQuestionsModelToJson(BodyQuestionsModel data) =>
    json.encode(data.toJson());

class BodyQuestionsModel {
  String? status;
  List<Body>? body;
  String? message;

  BodyQuestionsModel({this.status, this.body, this.message});

  BodyQuestionsModel.fromJson(Map<String, dynamic> json) {
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
  String? category;
  String? part;
  String? media;
  List<McqOptions>? mcqOptions;
  int? iV;

  Body(
      {this.sId,
      this.question,
      this.answer,
      this.type,
      this.score,
      this.category,
      this.part,
      this.media,
      this.mcqOptions,
      this.iV});

  Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    answer = json['answer'];
    type = json['type'];
    score = json['score'];
    category = json['category'];
    part = json['part'];
    media = json['media'];
    if (json['mcqOptions'] != null) {
      mcqOptions = <McqOptions>[];
      json['mcqOptions'].forEach((v) {
        mcqOptions!.add(McqOptions.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    data['answer'] = answer;
    data['type'] = type;
    data['score'] = score;
    data['category'] = category;
    data['part'] = part;
    data['media'] = media;
    if (mcqOptions != null) {
      data['mcqOptions'] = mcqOptions!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    return data;
  }
}

class McqOptions {
  String? text;
  bool? isCorrect;
  String? sId;

  McqOptions({this.text, this.isCorrect, this.sId});

  McqOptions.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    isCorrect = json['isCorrect'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['isCorrect'] = isCorrect;
    data['_id'] = sId;
    return data;
  }
}
