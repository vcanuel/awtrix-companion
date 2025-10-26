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

<div align="center">
  <img width="300" height="300" alt="AWTRIX Companion Screenshot" src="https://github.com/user-attachments/assets/ad899266-666c-4e1d-a00d-ad9b3af84f07" />
</div>

## Features

### 🎯 Core Features
- **Live Display Preview**: Real-time visualization of your 32x8 LED matrix
- **Device Discovery** (v1.3.0): Automatic detection of AWTRIX devices on your local network
  - Scan local network for AWTRIX devices
  - Display device name (hostname) and IP address
  - Manual IP entry with validation
  - Instant connection switching without app restart
- **Custom Messages**: Send custom text messages to your AWTRIX display
  - Choose from hundreds of icons from [LaMetric](https://developer.lametric.com/icons)
  - Automatic icon download and upload to your device
  - Customize text color with color picker
  - Set message duration
  - Send immediately to your display
- **Full Device Control**:
  - Matrix on/off toggle
  - Brightness adjustment (0-255)
  - Text color customization with color picker
  - Auto-transition settings
  - Transition speed control
  - Transition effect selection
  - Uppercase text toggle
  - App display time configuration
- **App Navigation**: Switch between previous and next apps with smooth transitions
- **Battery Monitoring**: Visual battery indicator for your AWTRIX device
- **Internationalization** (v1.2.0): Full French and English language support
- **Cross-Platform**: Works on iOS, Android, Web, macOS, Windows, and Linux
- **Dark Theme**: Modern dark UI optimized for visibility

## Screenshots

| | | | |
|---|---|---|---|
| ![awtrix 1](https://github.com/user-attachments/assets/32891916-f0f9-4698-a0e3-63a357f91ddc) | ![awtrix 2](https://github.com/user-attachments/assets/88c357ed-4595-4c33-8c7a-9e7c3a40c070) | ![awtrix 3](https://github.com/user-attachments/assets/18d3369b-d370-4cbc-807b-3ddaed59c2f2) | ![awtrix 4](https://github.com/user-attachments/assets/9cb327c8-f0f5-42ce-90a4-1a37b7ad63ac) |


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
3. **Navigate between tabs**:
   - **Général**: View live display, control device settings, navigate between apps
   - **Messages**: Send custom messages with icons to your display
4. **Send a custom message**:
   - Go to the "Messages" tab
   - Enter your message text
   - Tap "Choisir une icône" to select from LaMetric icons
   - Customize text color and duration
   - Tap "Envoyer" to display your message

### API Endpoints

The app communicates with your AWTRIX device using these HTTP endpoints:
- `GET /api/screen` - Retrieves current display pixels (RGB888 JSON format)
- `GET /api/settings` - Fetches device settings
- `POST /api/settings` - Updates device configuration
- `GET /api/stats` - Gets device statistics (battery, current app, etc.)
- `POST /api/custom?name=companion` - Sends custom messages to display
- `POST /api/notify` - Sends notifications
- `POST /api/nextapp` - Switches to next app
- `POST /api/previousapp` - Switches to previous app
- `POST /ICON` - Uploads icon files (JPG format)

## Development

### Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/                        # Data models
│   ├── awtrix_settings.dart       # Device settings model
│   ├── app_settings.dart          # App configuration model
│   └── screen_data.dart           # LED matrix data model
├── screens/                       # App screens
│   ├── main_navigation_screen.dart # Bottom navigation
│   ├── home_screen.dart           # Main control screen
│   ├── custom_app_screen.dart     # Custom messages screen
│   └── settings_screen.dart       # Configuration screen
├── services/                      # Business logic
│   ├── awtrix_service.dart        # AWTRIX API client
│   └── app_settings_service.dart  # Local settings persistence
└── widgets/                       # Reusable UI components
    ├── led_screen_display.dart    # LED matrix visualization
    ├── controls_section.dart      # Settings controls
    ├── battery_indicator.dart     # Battery UI
    ├── app_selector.dart          # App navigation
    ├── app_drawer.dart            # Navigation drawer
    └── ...                        # Control widgets
```

### Architecture

- **Model-First Architecture**: All device settings and display data use immutable data models
- **RGB888 JSON Format**: LED matrix data received as RGB888 JSON array from AWTRIX API
- **Service Layer**: Separation of HTTP API calls and business logic
- **Widget Composition**: Modular, reusable UI components
- **LaMetric Integration**: Automatic icon download from LaMetric with format conversion (PNG→JPG)

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
- **Network Discovery**: [network_info_plus](https://pub.dev/packages/network_info_plus) 6.0.2
- **Color Picker**: [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) 1.1.0
- **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences) 2.2.2
- **Image Processing**: [image](https://pub.dev/packages/image) 4.3.0
- **File Picker**: [file_picker](https://pub.dev/packages/file_picker) 8.1.6

## AWTRIX Device

This app is designed to work with [AWTRIX](https://blueforcer.github.io/awtrix3/) LED matrix displays. AWTRIX is an open-source project that turns a 32x8 LED matrix into a smart display with customizable apps, notifications, and more.

## Release History

### Version 1.3.0 (2024-10-26)
**Device Discovery & UX Improvements**
- 🔍 **Automatic Device Discovery**: Scan your local network to find AWTRIX devices
  - Network scanner detects devices via `/api/stats` endpoint
  - Identifies AWTRIX devices by hostname pattern (awtrix_*)
  - Shows device name and IP address in discovery list
- 📱 **Improved Device Management**:
  - Display device name (uid) in app title bar and drawer
  - Clean IP display without `http://` prefix
  - Simplified IP entry (just enter IP, no protocol needed)
  - IP validation with regex for both IPv4 and hostnames
  - Instant device switching without app restart
- 🔄 **Auto-save & Reconnection**: Selecting a discovered device automatically saves and connects
- 🌐 **Network Permissions**: Added required permissions for Android and iOS

### Version 1.2.0
**Internationalization & UI Improvements**
- 🌍 **Multi-language Support**: Full French and English translations
- 🎨 **UI Polish**: Improved drawer layout and visibility
- 🔧 **Settings Persistence**: Better handling of app settings across sessions

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
