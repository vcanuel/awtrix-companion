# AWTRIX Companion

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

A beautiful cross-platform Flutter application to control your AWTRIX LED matrix displays (32x8 pixels).

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Development](#development) • [Contributing](#contributing)

</div>

## About

AWTRIX Companion is a modern mobile and desktop application that allows you to control and monitor your AWTRIX LED matrix displays. Built with Flutter, it provides a seamless experience across iOS, Android, Web, macOS, Windows, and Linux platforms.

## Features

- **Live Display Preview**: Real-time visualization of your 32x8 LED matrix
- **Full Device Control**:
  - Matrix on/off toggle
  - Brightness adjustment (0-255)
  - Text color customization with color picker
  - Auto-transition settings
  - Transition speed control
  - Transition effect selection
  - Uppercase text toggle
  - App display time configuration
- **Battery Monitoring**: Visual battery indicator for your AWTRIX device
- **App Management**: Browse and control custom apps on your AWTRIX
- **Cross-Platform**: Works on iOS, Android, Web, macOS, Windows, and Linux
- **Dark Theme**: Modern dark UI optimized for visibility

## Screenshots

<!-- Add screenshots here when available -->

## Installation

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- An AWTRIX device connected to your local network

### Download

#### Pre-built Releases
Download the latest release for your platform from the [Releases](https://github.com/vcanuel/awtrix-companion/releases) page.

#### Build from Source

1. Clone the repository:
```bash
git clone https://github.com/vcanuel/awtrix-companion.git
cd awtrix-companion
```

2. Install dependencies:
```bash
flutter pub get
```

3. Build for your platform:

**iOS/Android:**
```bash
flutter build apk          # Android
flutter build ios          # iOS (requires macOS and Xcode)
```

**Desktop:**
```bash
flutter build macos        # macOS
flutter build windows      # Windows
flutter build linux        # Linux
```

**Web:**
```bash
flutter build web
```

## Usage

1. **Launch the app** on your device
2. **Configure your AWTRIX device**:
   - Open the settings (drawer menu)
   - Enter your AWTRIX device IP address
3. **Start controlling**: The home screen displays your LED matrix and provides controls for all device settings

### API Endpoints

The app communicates with your AWTRIX device using these HTTP endpoints:
- `GET /api/screen` - Retrieves current display pixels (RGB565 format)
- `GET /api/settings` - Fetches device settings
- `POST /api/settings` - Updates device configuration
- `GET /api/stats` - Gets device statistics (battery, etc.)
- `GET /api/applist` - Lists available apps

## Development

### Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/                    # Data models
│   ├── awtrix_settings.dart   # Device settings model
│   ├── app_settings.dart      # App configuration model
│   └── screen_data.dart       # LED matrix data model
├── screens/                   # App screens
│   ├── home_screen.dart       # Main control screen
│   └── settings_screen.dart   # Configuration screen
├── services/                  # Business logic
│   ├── awtrix_service.dart    # AWTRIX API client
│   └── app_settings_service.dart  # Local settings persistence
└── widgets/                   # Reusable UI components
    ├── led_screen_display.dart    # LED matrix visualization
    ├── controls_section.dart      # Settings controls
    ├── battery_indicator.dart     # Battery UI
    ├── app_selector.dart          # App list
    └── ...                        # Control widgets
```

### Architecture

- **Model-First Architecture**: All device settings and display data use immutable data models
- **RGB565 to RGB888 Conversion**: Automatic color format conversion for display rendering
- **Service Layer**: Separation of HTTP API calls and business logic
- **Widget Composition**: Modular, reusable UI components

### Running Tests

```bash
flutter test                           # Run all tests
flutter test test/widget_test.dart     # Run specific test
```

### Code Quality

```bash
flutter analyze                        # Static analysis
flutter format lib/                    # Format code
```

### Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code:
- Follows the existing code style
- Passes all tests (`flutter test`)
- Passes static analysis (`flutter analyze`)
- Is properly documented

## Technology Stack

- **Framework**: [Flutter](https://flutter.dev) 3.9.2+
- **Language**: [Dart](https://dart.dev) 3.9.2+
- **HTTP Client**: [http](https://pub.dev/packages/http) 1.2.0
- **Color Picker**: [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) 1.1.0
- **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences) 2.2.2

## AWTRIX Device

This app is designed to work with [AWTRIX](https://blueforcer.github.io/awtrix3/) LED matrix displays. AWTRIX is an open-source project that turns a 32x8 LED matrix into a smart display with customizable apps, notifications, and more.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [AWTRIX Project](https://github.com/Blueforcer/awtrix3) for the amazing LED matrix platform
- Flutter team for the excellent cross-platform framework
- [Claude Code](https://claude.com/claude-code) for development assistance
- All contributors who help improve this project

## Support

- **Issues**: [GitHub Issues](https://github.com/vcanuel/awtrix-companion/issues)
- **Discussions**: [GitHub Discussions](https://github.com/vcanuel/awtrix-companion/discussions)

---

<div align="center">
Made with ❤️ using Flutter
</div>
