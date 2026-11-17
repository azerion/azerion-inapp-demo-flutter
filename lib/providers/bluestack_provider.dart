import 'package:bluestack_flutter_demo/config/app_config.dart';
import 'package:bluestack_flutter_demo/services/logger_service.dart';
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart'; // Import the BlueStack SDK
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluestackInitializedProvider = StateProvider<bool>((ref) => false);

class BlueStackService {
  static Future<void> initialize(WidgetRef ref) async {
    await _setupPrivacySettings();
    _setupInitializeCallbacks(ref);
    await BlueStackInitializer.initialize(
      appId: AppConfig.appId,
      enableDebug: true,
    );
  }

  /// Set global privacy settings for BlueStack (optional).
  ///
  /// Marking the user as age-restricted stops some mediation networks, such
  /// as AppLovin, from initialising, so the demo leaves it off.
  static Future<void> _setupPrivacySettings() async {
    await PrivacySettings.setIsUserOptOut(isUserOptOut: false);
    await PrivacySettings.setIsAgeRestrictedUser(isAgeRestrictedUser: false);
  }

  static void _setupInitializeCallbacks(WidgetRef ref) {
    // BlueStack Initializer load callbacks
    BlueStackInitializer.setEventListener(
      InitializationEventListener(
        onInitializationSuccess: (Map<String, AdapterStatus> adapterStatus) {
          LoggerService.log(
            'BlueStack SDK initialized with App ID: ${AppConfig.appId}',
          );
          ref.read(bluestackInitializedProvider.notifier).state = true;
        },
        onInitializationFail: (error) {
          LoggerService.log('BlueStack SDK failed to initialize: $error');
        },
      ),
    );
  }
}
