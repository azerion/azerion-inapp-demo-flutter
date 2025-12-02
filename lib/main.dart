import 'package:bluestack_demo_flutter/app.dart';
import 'package:bluestack_demo_flutter/services/logger_service.dart';
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
