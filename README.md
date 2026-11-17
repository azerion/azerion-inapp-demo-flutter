# BlueStack Flutter Demo

A Flutter app that shows how to integrate the [BlueStack Flutter SDK](https://pub.dev/packages/bluestack_sdk_flutter) (`bluestack_sdk_flutter` on pub.dev) and its ad formats.

## What the app shows

- **Home:** SDK initialisation and an MREC banner.
- **BlueStack Ads:** banner, interstitial and rewarded ads, each loaded and shown on demand.
- **Banners:** every banner size in its own tab: Standard, Full, Large, Leaderboard and MREC.
- **Settings:** the app ID in use, debug logging, and clearing the log.
- **Log drawer:** the SDK's ad events as they happen, opened from the app bar.

Mediation runs through the BlueStack adapters for Google, Equativ, BidMachine and AppLovin. The adapters are declared in `android/app/build.gradle` and `ios/Podfile`. No network keys are needed in the app: the networks are configured in the BlueStack account.

## Requirements

- Flutter 3.35.x (3.35.7 is pinned in `.fvmrc` for [FVM](https://fvm.app)). Newer Flutter releases need Gradle 8.14 or newer.
- Android: minSdk 24 (the AppLovin adapter needs it), compileSdk 36
- iOS: 15.0 or newer, Xcode 27 with CocoaPods 1.16 or newer
- A device, emulator or simulator

## Run it

```bash
flutter pub get
flutter run
```

The SDK comes from pub.dev; `pubspec.lock` records the exact version this demo was tested with.

On iOS the project signs with Azerion's development team. To run it on your own device, choose your team and a bundle ID of your own under *Signing & Capabilities* in Xcode.

## Integration points

| What | Where |
|---|---|
| SDK initialisation and privacy settings | `lib/providers/bluestack_provider.dart` |
| App IDs and request options (placement IDs are built from the app ID where each ad loads) | `lib/config/app_config.dart` |
| Banner ads | `lib/components/bluestack/banner_ad_menu.dart`, `lib/screens/banner_screen.dart` |
| Interstitial ads | `lib/components/bluestack/interstitial_ad_menu.dart` |
| Rewarded ads | `lib/components/bluestack/rewarded_ad_menu.dart` |
| Android mediation adapters and AdMob app ID | `android/app/build.gradle`, `android/app/src/main/AndroidManifest.xml` |
| iOS mediation adapters and AdMob app ID | `ios/Podfile`, `ios/Runner/Info.plist` |

The app uses [Riverpod](https://riverpod.dev) for state and [go_router](https://pub.dev/packages/go_router) for navigation; neither is required by the SDK.

## License

This project is licensed under the MIT License; see [LICENSE.md](LICENSE.md).
