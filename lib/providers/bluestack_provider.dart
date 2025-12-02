import 'package:bluestack_demo_flutter/config/app_config.dart';
import 'package:bluestack_demo_flutter/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart'; // Import the BlueStack SDK
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluestackInitializedProvider = StateProvider<bool>((ref) => false);

class BlueStackService {
  static Future<void> initialize(WidgetRef ref) async {
    _setupInitializeCallbacks(ref);
    await BlueStackInitializer.initialize(
        appId: AppConfig.appId, enableDebug: true);
  }

  static void _setupInitializeCallbacks(WidgetRef ref) {
    // BlueStack Initializer load callbacks
    BlueStackInitializer.setEventListener(InitializationEventListener(
      onInitializationSuccess: (Map<String, AdapterStatus> adapterStatus) {
        LoggerService.log(
            'BlueStack SDK initialized with App ID: ${AppConfig.appId}');
        ref.read(bluestackInitializedProvider.notifier).state = true;
      },
      onInitializationFail: (error) {
        LoggerService.log('BlueStack SDK failed to initialize: $error');
      },
    ));
  }
}
