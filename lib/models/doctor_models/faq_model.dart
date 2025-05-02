// models/faq_model.dart
class FAQModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final int order;
  final bool isActive;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
    required this.isActive,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['_id'],
      question: json['question'],
      answer: json['answer'],
      category: json['category'],
      order: json['order'],
      isActive: json['isActive'],
    );
  }
}
