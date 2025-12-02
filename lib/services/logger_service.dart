import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogEntry {
  final String message;
  final DateTime timestamp;

  LogEntry(this.message) : timestamp = DateTime.now();

  @override
  String toString() {
    return '$timestamp:\n$message';
  }
}

// StateNotifier to manages the list of logs
class LoggerNotifier extends StateNotifier<List<LogEntry>> {
  LoggerNotifier() : super([]); // start with empty list

  void addLog(String message) {
    final logEntry = LogEntry(message);
    state = [...state, logEntry]; // add new log to the state
  }

  void clearLogs() {
    state = [];
  }
}

// StateNotifierProvider to provides access to the LoggerNotifier
final loggerProvider =
    StateNotifierProvider<LoggerNotifier, List<LogEntry>>((ref) {
  return LoggerNotifier();
});

// singleton LoggerService
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  late LoggerNotifier _loggerNotifier;

  /// singleton instance of LoggerService.
  LoggerService._internal();
  static LoggerService get instance => _instance;

  /// initialize
  void initialize(ProviderContainer container) {
    _loggerNotifier = container.read(loggerProvider.notifier);
  }

  static void log(String message) {
    _instance._loggerNotifier.addLog(message);
    debugPrint('${DateTime.now()}: $message');
  }

  static void showLog(State state, String message) {
    if (!state.mounted) return;

    final context = state.context;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );

    log(message);
  }

  static void clear() {
    _instance._loggerNotifier.clearLogs();
  }
}
