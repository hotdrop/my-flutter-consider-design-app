import 'package:logger/logger.dart';

class AppLogger {
  const AppLogger._();

  static final _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }
}
