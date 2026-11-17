# Changelog

All notable changes to this project are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [6.1.0] 2026-11-16

### Added

- BidMachine and AppLovin mediation adapters (Android 6.1.0.1 / 6.1.0.0, iOS 6.1.1 / 6.1.0).
- Banners screen with a tab for each banner size and a loading indicator while the SDK initializes.

### Changed

- BlueStack Flutter SDK 6.1.0 (Android core 6.1.3, iOS core 6.1.0).
- Mediation adapters: Bidding 6.0.6.2 / 6.1.0, Google 6.1.0.1 / 6.1.0, Equativ 6.0.0.4 / 6.0.1 (Android / iOS).
- Package `bluestack_flutter_demo`; Android application ID and iOS bundle ID `com.azerion.ads.testapp.flutterdemo`.
- Privacy settings default to `isAgeRestrictedUser: false`, so AppLovin initializes.
- Android minSdk is 24 for AppLovin.
- Android compiles against SDK 36; iOS deployment target 15.0, the minimum Xcode 27 builds for.
- Flutter 3.35.7, Android Gradle Plugin 8.11.1 with Gradle 8.13.
- New app icon.
