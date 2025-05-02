class Announcement {
  String id;
  String title;
  String content;
  String media;
  DateTime startDate;
  DateTime endDate;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.media,
    required this.startDate,
    required this.endDate,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      media: json['media'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
