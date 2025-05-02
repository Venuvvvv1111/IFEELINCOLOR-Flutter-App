import 'dart:convert';

Level2QuestionModel level2QuestionModelFromJson(String str) =>
    Level2QuestionModel.fromJson(json.decode(str));

class Level2QuestionModel {
  String? status;
  List<Level2Body>? body;
  String? message;

  Level2QuestionModel({this.status, this.body, this.message});

  Level2QuestionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['body'] != null) {
      body = <Level2Body>[];
      json['body'].forEach((v) {
        body!.add(Level2Body.fromJson(v));
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

class Level2Body {
  String? sId;
  String? question;
  List<Answer>? answer;
  String? type;
  int? iV;

  Level2Body({this.sId, this.question, this.answer, this.type, this.iV});

  Level2Body.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    if (json['answer'] != null) {
      answer = <Answer>[];
      json['answer'].forEach((v) {
        answer!.add(Answer.fromJson(v));
      });
    }
    type = json['type'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    if (answer != null) {
      data['answer'] = answer!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['__v'] = iV;
    return data;
  }
}

class Answer {
  String? option;
  String? sId;

  Answer({this.option, this.sId});

  Answer.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['option'] = option;
    data['_id'] = sId;
    return data;
  }
}
