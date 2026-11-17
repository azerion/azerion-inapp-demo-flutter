import 'package:bluestack_flutter_demo/app.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global ProviderContainer
final globalContainer = ProviderContainer();

void main() {
  LoggerService.instance.initialize(globalContainer);

  runApp(
    UncontrolledProviderScope(
      container: globalContainer, // Use the global container
      child: BlueStackApp(),
    ),
  );
}
