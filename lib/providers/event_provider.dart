import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('events');
  List<EventModel> _events = [];

  List<EventModel> get events => _events;

  // Ambil semua event (Real-time)
  void fetchEvents() {
    _db.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final map = Map<String, dynamic>.from(data as Map);
        _events = map.entries
            .map((e) => EventModel.fromMap(
                Map<String, dynamic>.from(e.value as Map), e.key))
            .toList();
      } else {
        _events = [];
      }
      notifyListeners();
    });
  }

  // Tambah event baru
  Future<void> addEvent(EventModel event) async {
    final newRef = _db.push();
    event.id = newRef.key!;
    await newRef.set(event.toMap());
  }

  // Update event
  Future<void> updateEvent(EventModel event) async {
    await _db.child(event.id).update(event.toMap());
  }

  // Hapus event
  Future<void> deleteEvent(String id) async {
    await _db.child(id).remove();
  }
}
// EventProvider - v1.0
