class EventModel {
  String id;
  String title;
  String description;
  String location;
  String date;
  String category;
  String createdBy;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.category,
    required this.createdBy,
  });

  // Dari Realtime Database ke objek Dart
  factory EventModel.fromMap(Map<String, dynamic> map, String id) {
    return EventModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      category: map['category'] ?? '',
      createdBy: map['createdBy'] ?? '',
    );
  }

  // Dari objek Dart ke Realtime Database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'category': category,
      'createdBy': createdBy,
    };
  }
}
// EventModel - v1.0
