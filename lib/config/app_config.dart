import 'dart:io' show Platform;
import 'package:bluestack_sdk_flutter/bluestack_sdk_flutter.dart';

class AppConfig {
  static const String iosAppId = '1259479'; //3180317
  static const String androidAppId = '1259479'; //5180317

  static String get appId {
    if (Platform.isIOS) {
      return iosAppId;
    } else if (Platform.isAndroid) {
      return androidAppId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Configures the [RequestOptions] with user and
  /// content targeting parameters.
  static RequestOptions getRequestOptions() {
    final options = RequestOptions()
      ..setAge(25)
      ..setLanguage('en')
      ..setGender(Gender.unknown)
      ..setKeyword('testbrand=myBrand;category=sport')
      ..setLocation(
          Location(
              latitude: 37.7749,
              longitude: -122.4194,
              provider: LocationProvider.gps),
          1)
      ..setContentUrl('https://developers.bluestack.app/');
    return options;
  }
}
