class IntakeDetailsModel {
  String id;
  String patientId;
  List<QuestionAnswer> treatmentHistory;
  List<QuestionAnswer> socialInformation;

  IntakeDetailsModel({
    required this.id,
    required this.patientId,
    required this.treatmentHistory,
    required this.socialInformation,
  });

  factory IntakeDetailsModel.fromJson(Map<String, dynamic> json) {
    return IntakeDetailsModel(
      id: json['_id'],
      patientId: json['patientId'],
      treatmentHistory: (json['treatmentHistory'] as List)
          .map((item) => QuestionAnswer.fromJson(item))
          .toList(),
      socialInformation: (json['socialInformation'] as List)
          .map((item) => QuestionAnswer.fromJson(item))
          .toList(),
    );
  }
}

class QuestionAnswer {
  String question;
  String answer;

  QuestionAnswer({
    required this.question,
    required this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class AssessmentInfo {
  String mood;
  String moodLevel;
  DateTime updatedAt;

  AssessmentInfo({
    required this.mood,
    required this.moodLevel,
    required this.updatedAt,
  });

  factory AssessmentInfo.fromJson(Map<String, dynamic> json) {
    return AssessmentInfo(
      mood: json['mood'],
      moodLevel: json['moodLevel'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
