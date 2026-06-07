import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class ApiService {
  // Ganti dengan IP laptop kamu
  static const String baseUrl = 'http://192.168.1.6/campven_api';

  // Kalau pakai HP fisik, ganti dengan IP WiFi laptop
  // Contoh: static const String baseUrl = 'http://192.168.1.4/campven_api';

  // ─── AUTH ────────────────────────────────────────────

  // Register
  static Future<Map<String, dynamic>> register(
      String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Koneksi gagal: $e'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Koneksi gagal: $e'};
    }
  }

  // ─── EVENTS ──────────────────────────────────────────

  // Get semua event
  static Future<List<EventModel>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events.php?action=get_all'),
      );
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final List events = data['data'];
        return events.map((e) => EventModel.fromMap(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getEvents: $e');
      return [];
    }
  }

  // Tambah event
  static Future<Map<String, dynamic>> createEvent(EventModel event) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events.php?action=create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.toMap()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Koneksi gagal: $e'};
    }
  }

  // Update event
  static Future<Map<String, dynamic>> updateEvent(EventModel event) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events.php?action=update&id=${event.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.toMap()),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Koneksi gagal: $e'};
    }
  }

  // Hapus event
  static Future<Map<String, dynamic>> deleteEvent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events.php?action=delete&id=$id'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Koneksi gagal: $e'};
    }
  }
}