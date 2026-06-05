import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref('events');
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Ambil semua event (Real-time)
  void fetchEvents() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _db.onValue.listen(
      (event) {
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
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Gagal memuat event: $error';
        notifyListeners();
      },
    );
  }

  // Tambah event baru
  Future<bool> addEvent(EventModel event) async {
    try {
      final newRef = _db.push();
      event.id = newRef.key!;
      await newRef.set(event.toMap());
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan event: $e';
      notifyListeners();
      return false;
    }
  }

  // Update event
  Future<bool> updateEvent(EventModel event) async {
    try {
      await _db.child(event.id).update(event.toMap());
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengupdate event: $e';
      notifyListeners();
      return false;
    }
  }

  // Hapus event
  Future<bool> deleteEvent(String id) async {
    try {
      await _db.child(id).remove();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus event: $e';
      notifyListeners();
      return false;
    }
  }

  // Reset error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}