import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  late WebSocketService _wsService;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Inisialisasi WebSocket
  void initWebSocket() {
    _wsService = WebSocketService();
    _wsService.connect();
    _wsService.onEventChanged = () {
      fetchEvents();
    };
  }

  // Ambil semua event dari API
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _events = await ApiService.getEvents();
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat event: $e';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Tambah event baru
  Future<bool> addEvent(EventModel event) async {
    try {
      final result = await ApiService.createEvent(event);
      if (result['status'] == 'success') {
        await fetchEvents();
        // Broadcast ke WebSocket
        _wsService.sendEvent('create', result['data']);
        return true;
      }
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan event: $e';
      notifyListeners();
      return false;
    }
  }

  // Update event
  Future<bool> updateEvent(EventModel event) async {
    try {
      final result = await ApiService.updateEvent(event);
      if (result['status'] == 'success') {
        await fetchEvents();
        // Broadcast ke WebSocket
        _wsService.sendEvent('update', event.toMap());
        return true;
      }
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal mengupdate event: $e';
      notifyListeners();
      return false;
    }
  }

  // Hapus event
  Future<bool> deleteEvent(String id) async {
    try {
      final result = await ApiService.deleteEvent(int.parse(id));
      if (result['status'] == 'success') {
        await fetchEvents();
        // Broadcast ke WebSocket
        _wsService.sendEvent('delete', {'id': id});
        return true;
      }
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Gagal menghapus event: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }
}