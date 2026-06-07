class EventModel {
  int? id;
  String title;
  String description;
  String location;
  String date;
  String category;
  String createdBy;
  int? userId;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.category,
    required this.createdBy,
    this.userId,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] is String ? int.tryParse(map['id']) : map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      category: map['category'] ?? '',
      createdBy: map['created_by'] ?? '',
      userId: map['user_id'] is String
          ? int.tryParse(map['user_id'])
          : map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'category': category,
      'created_by': createdBy,
      'user_id': userId,
    };
  }
}