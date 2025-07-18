// lib/services/log_service.dart
class LogService {
  static final List<String> _logs = [];

  static void add(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _logs.insert(0, '[$timestamp] $message');
  }

  static void clear() => _logs.clear();

  static List<String> get all => List.unmodifiable(_logs);
}
