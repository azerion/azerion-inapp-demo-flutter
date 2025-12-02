# BlueStack Flutter SDK Demo

A Flutter demo app showcasing ad integration and key features of the BlueStack Flutter SDK.

## Features

- Navigation drawer with multiple screens
- BlueStack SDK integration
- Banner, Interstitial, and Rewarded ads support
- Settings management
- Log viewer functionality

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode for mobile development
- A physical device or emulator

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd bluestack-demo-flutter
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── app.dart                    # Main app configuration and routing
├── main.dart                   # Entry point
├── components/                 # Reusable UI components
│   ├── bluestack/
│   │   ├── banner_ad_menu.dart
│   │   ├── interstitial_ad_menu.dart
│   │   └── rewarded_ad_menu.dart
│   └── drawer/
│       ├── log_drawer.dart
│       └── menu_drawer.dart
├── config/
│   └── app_config.dart         # App configuration constants
├── providers/
│   └── bluestack_provider.dart # State management
├── screens/                    # App screens
│   ├── home_screen.dart
│   ├── bluestack_screen.dart
│   └── settings_screen.dart
├── services/
│   └── logger_service.dart     # Logging functionality
└── src/
    └── localization/
        └── app_en.arb          # Localization strings
```

## State Management

The app uses Flutter Riverpod for state management, providing a clean and efficient way to handle app state and dependencies.

## Navigation

Navigation is handled using Go Router, providing a declarative routing approach with support for deep linking and nested navigation.

## Assets

The `assets` directory has images, fonts, and any other files you want to include with your application.
The `assets/images` directory contains [resolution-aware images](https://flutter.dev/to/resolution-aware-images).

## Localization

This project generates localized messages based on arb files found in the `lib/src/localization` directory.
To support additional languages, please visit the tutorial on [Internationalizing Flutter apps](https://flutter.dev/to/internationalization).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
