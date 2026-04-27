class QuestionResponse {
  String? status;
  QuestionNode? body;

  QuestionResponse({this.status, this.body});

  QuestionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    body = json['body'] != null
        ? QuestionNode.fromJson(json['body'])
        : null;
  }
}

class QuestionNode {
  String? key;
  String? label;
  String? type;
  String? colorGroup;
  HexCode? hexCode;
  String? question;
  List<QuestionNode>? options;

  QuestionNode({
    this.key,
    this.label,
    this.type,
    this.colorGroup,
    this.hexCode,
    this.question,
    this.options,
  });

  QuestionNode.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    type = json['type'];
    colorGroup = json['colorGroup'];
    hexCode =
        json['hexCode'] != null ? HexCode.fromJson(json['hexCode']) : null;
    question = json['question'];
   options = (json['options'] as List?)
    ?.map((e) => QuestionNode.fromJson(e))
    .toList() ?? [];
  }
}

class HexCode {
  String? inner;
  String? middle;
  String? outer;

  HexCode({this.inner, this.middle, this.outer});

  HexCode.fromJson(Map<String, dynamic> json) {
    inner = json['inner'];
    middle = json['middle'];
    outer = json['outer'];
  }
}