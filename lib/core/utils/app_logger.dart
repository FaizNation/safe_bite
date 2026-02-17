import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static void debug(String message, {String name = 'SafeBite'}) {
    developer.log(message, name: name, level: 500);
  }

  static void info(String message, {String name = 'SafeBite'}) {
    developer.log(message, name: name, level: 800);
  }

  static void warning(String message, {String name = 'SafeBite'}) {
    developer.log(message, name: name, level: 900);
  }

  static void error(
    String message, {
    String name = 'SafeBite',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
