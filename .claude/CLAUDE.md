# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for controlling AWTRIX LED matrix displays (32x8 pixels). The app communicates with AWTRIX devices via their HTTP API and provides a user interface to control display settings, view the screen output, and manage transitions.

## Development Commands

### Running the app
```bash
flutter run                    # Run on connected device/emulator
flutter run -d chrome          # Run in Chrome browser
flutter run -d macos           # Run on macOS
```

### Building
```bash
flutter build apk              # Build Android APK
flutter build ios              # Build iOS app
flutter build macos            # Build macOS app
flutter build web              # Build web version
```

### Testing
```bash
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run specific test file
```

### Code Quality
```bash
flutter analyze                # Run static analysis
dart format .                  # Format all Dart code
dart format --output=none --set-exit-if-changed .  # Check formatting without modifying
```

**Code Formatting Guidelines:**
- Always generate code that follows Dart formatting conventions
- Use trailing commas for better automatic formatting
- Respect ~80 character line length limits
- Use 2-space indentation
- Run `dart format .` after generating or modifying code to ensure consistency
- **All code comments must be written in English** (not French or other languages)

### Dependencies
```bash
flutter pub get                # Install dependencies
flutter pub upgrade            # Upgrade dependencies
```

## Architecture

### Models Layer
The app uses a model-first architecture with two core data models:

1. **AwtrixSettings** (`lib/models/awtrix_settings.dart`):
   - Represents device configuration (matrix on/off, brightness, text color, transitions)
   - Implements JSON serialization mapping to AWTRIX API format (e.g., 'MAT', 'BRI', 'TCOLOR')
   - Uses `copyWith` pattern for immutable state updates
   - All settings sync with device via HTTP API

2. **ScreenData** (`lib/models/screen_data.dart`):
   - Represents the 32x8 LED matrix display buffer
   - Converts RGB565 (16-bit) format from AWTRIX API to Flutter Color objects (RGB888)
   - Factory constructor `fromRgb565List()` handles binary data parsing
   - Provides `getPixel(x, y)` for safe pixel access with boundary checking

### AWTRIX API Integration
The app communicates with AWTRIX devices using these key endpoints:
- `GET /api/screen` - Returns RGB565 pixel data for display visualization
- `GET /api/settings` - Retrieves current device settings
- `POST /api/settings` - Updates device settings

### Color Format Conversion
AWTRIX uses RGB565 (5 bits red, 6 bits green, 5 bits blue) for efficient LED control. The ScreenData model handles conversion:
```
RGB565 → RGB888
R: (value & 0x1F) * 255 / 31
G: ((value >> 5) & 0x3F) * 255 / 63
B: ((value >> 11) & 0x1F) * 255 / 31
```

## Key Dependencies

- **http** (^1.2.0) - HTTP client for AWTRIX API communication
- **flutter_colorpicker** (^1.1.0) - Color picker UI for text color selection
- **flutter_localizations** - Internationalization support
- **intl** - Internationalization and localization utilities

## Development Notes

### Demo Mode
The app includes a demo mode that mocks API calls for development without requiring an actual AWTRIX device. When implementing API services, ensure demo mode generates realistic data for testing UI components.

### State Management
No state management library is currently implemented. When adding state management, consider using Provider or Riverpod for reactive updates between settings changes and the UI.

### Display Rendering
The LED matrix display (32x8) should be rendered with visual fidelity to the actual hardware. Consider using CustomPainter to draw individual pixels as small squares with proper spacing.

### Internationalization (i18n)
The app supports multiple languages (French and English). When creating new screens or widgets:
- **NEVER** hardcode user-facing strings directly in the code
- **ALWAYS** add new strings to both `lib/l10n/app_en.arb` and `lib/l10n/app_fr.arb`
- Use `AppLocalizations.of(context)!` to access translations in widgets
- For strings with dynamic content, use placeholders in ARB files:
  ```json
  "error": "Error: {message}",
  "@error": {
    "placeholders": {
      "message": {"type": "String"}
    }
  }
  ```
- After adding new strings, run `flutter gen-l10n` or build the app to regenerate localization files
- The app uses device locale by default but allows manual override via `LocaleService`

### Settings Keys
When working with AWTRIX API, use these setting keys:
- MAT: Matrix on/off
- TCOLOR: Text color (as integer color value)
- BRI: Brightness (0-255)
- ATRANS: Auto transition enabled
- TSPEED: Transition speed in milliseconds
- TEFF: Transition effect name
- UPPERCASE: Uppercase letters enabled
- ATIME: App display time in seconds

## Platform Support

This app targets all Flutter platforms: iOS, Android, Web, macOS, Windows, and Linux. The AWTRIX device is typically accessed via local network, so ensure HTTP requests work on the target platform.
