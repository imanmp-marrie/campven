import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static const String _wsUrl = 'ws://192.168.1.6:8080';
  WebSocketChannel? _channel;
  bool _isConnected = false;

  // Callback saat ada perubahan event
  Function? onEventChanged;

  // Connect ke WebSocket server
  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _isConnected = true;
      print('WebSocket terhubung ke $_wsUrl');

      // Listen pesan dari server
      _channel!.stream.listen(
        (message) {
          print('WebSocket pesan diterima: $message');
          try {
            final data = jsonDecode(message);
            final type = data['type'];

            // Kalau ada perubahan event, refresh data
            if (type == 'create' || type == 'update' || type == 'delete') {
              if (onEventChanged != null) {
                onEventChanged!();
              }
            }
          } catch (e) {
            print('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          print('WebSocket connection closed');
          _isConnected = false;
        },
      );
    } catch (e) {
      print('WebSocket gagal connect: $e');
      _isConnected = false;
    }
  }

  // Kirim event ke WebSocket server
  void sendEvent(String type, dynamic data) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(jsonEncode({
          'type': type,
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
        }));
        print('WebSocket event terkirim: $type');
      } catch (e) {
        print('Error sending WebSocket event: $e');
      }
    }
  }

  // Disconnect
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    print('WebSocket disconnected');
  }

  bool get isConnected => _isConnected;
}