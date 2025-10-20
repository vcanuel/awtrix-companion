import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:awtrix/models/screen_data.dart';

void main() {
  group('ScreenData.fromRgb565List', () {
    test('converts RGB565 data to RGB888 colors correctly', () {
      // RGB565 format: RRRRR GGGGGG BBBBB
      // Red: 0xF800 (11111 000000 00000) -> RGB(255, 0, 0)
      // Green: 0x07E0 (00000 111111 00000) -> RGB(0, 255, 0)
      // Blue: 0x001F (00000 000000 11111) -> RGB(0, 0, 255)

      final data = [
        0xF8, 0x00, // Red pixel
        0x07, 0xE0, // Green pixel
        0x00, 0x1F, // Blue pixel
      ];

      final screenData = ScreenData.fromRgb565List(data);

      expect(screenData.width, 32);
      expect(screenData.height, 8);
      expect(screenData.pixels.length, 3);

      // Check red pixel
      expect((screenData.pixels[0].r * 255.0).round() & 0xff, 255);
      expect((screenData.pixels[0].g * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[0].b * 255.0).round() & 0xff, 0);

      // Check green pixel
      expect((screenData.pixels[1].r * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[1].g * 255.0).round() & 0xff, 255);
      expect((screenData.pixels[1].b * 255.0).round() & 0xff, 0);

      // Check blue pixel
      expect((screenData.pixels[2].r * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[2].g * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[2].b * 255.0).round() & 0xff, 255);
    });

    test('handles white and black colors correctly', () {
      final data = [
        0xFF, 0xFF, // White (11111 111111 11111)
        0x00, 0x00, // Black (00000 000000 00000)
      ];

      final screenData = ScreenData.fromRgb565List(data);

      expect(screenData.pixels.length, 2);

      // Check white pixel
      expect((screenData.pixels[0].r * 255.0).round() & 0xff, 255);
      expect((screenData.pixels[0].g * 255.0).round() & 0xff, 255);
      expect((screenData.pixels[0].b * 255.0).round() & 0xff, 255);

      // Check black pixel
      expect((screenData.pixels[1].r * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[1].g * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[1].b * 255.0).round() & 0xff, 0);
    });

    test('handles custom width and height', () {
      final data = [0xF8, 0x00, 0x07, 0xE0];

      final screenData = ScreenData.fromRgb565List(
        data,
        width: 16,
        height: 16,
      );

      expect(screenData.width, 16);
      expect(screenData.height, 16);
      expect(screenData.pixels.length, 2);
    });

    test('handles odd-length data by ignoring last byte', () {
      final data = [0xF8, 0x00, 0xFF]; // 3 bytes (odd)

      final screenData = ScreenData.fromRgb565List(data);

      // Should only process the first 2 bytes
      expect(screenData.pixels.length, 1);
      expect((screenData.pixels[0].r * 255.0).round() & 0xff, 255);
      expect((screenData.pixels[0].g * 255.0).round() & 0xff, 0);
      expect((screenData.pixels[0].b * 255.0).round() & 0xff, 0);
    });

    test('handles empty data', () {
      final data = <int>[];

      final screenData = ScreenData.fromRgb565List(data);

      expect(screenData.width, 32);
      expect(screenData.height, 8);
      expect(screenData.pixels.isEmpty, true);
    });

    test('converts intermediate RGB565 values correctly', () {
      // Test a medium gray-ish color
      // RGB565: 0x8410 (10000 100000 10000)
      // Expected: R=132, G=130, B=132 (approximately)
      final data = [0x84, 0x10];

      final screenData = ScreenData.fromRgb565List(data);

      expect(screenData.pixels.length, 1);

      final color = screenData.pixels[0];
      // RGB565 conversion formula:
      // R: (16 * 255 / 31) ≈ 132
      // G: (32 * 255 / 63) ≈ 129
      // B: (16 * 255 / 31) ≈ 132
      expect((color.r * 255.0).round() & 0xff, closeTo(132, 1));
      expect((color.g * 255.0).round() & 0xff, closeTo(129, 1));
      expect((color.b * 255.0).round() & 0xff, closeTo(132, 1));
    });

    test('creates correct pixel data for full 32x8 AWTRIX screen', () {
      // AWTRIX screen is 32x8 = 256 pixels = 512 bytes
      final data = List<int>.generate(512, (i) => i % 256);

      final screenData = ScreenData.fromRgb565List(data);

      expect(screenData.width, 32);
      expect(screenData.height, 8);
      expect(screenData.pixels.length, 256);
    });
  });

  group('ScreenData.getPixel', () {
    late ScreenData screenData;

    setUp(() {
      // Create a simple 2x2 screen with known colors
      final data = [
        0xF8, 0x00, // Red
        0x07, 0xE0, // Green
        0x00, 0x1F, // Blue
        0xFF, 0xFF, // White
      ];
      screenData = ScreenData.fromRgb565List(data, width: 2, height: 2);
    });

    test('returns correct pixel at valid coordinates', () {
      expect((screenData.getPixel(0, 0).r * 255.0).round() & 0xff, 255); // Red
      expect((screenData.getPixel(1, 0).g * 255.0).round() & 0xff, 255); // Green
      expect((screenData.getPixel(0, 1).b * 255.0).round() & 0xff, 255); // Blue
      expect((screenData.getPixel(1, 1).r * 255.0).round() & 0xff, 255); // White
    });

    test('returns black for out-of-bounds negative coordinates', () {
      final color = screenData.getPixel(-1, 0);
      expect(color, const Color(0xFF000000));
    });

    test('returns black for out-of-bounds coordinates exceeding dimensions', () {
      final color = screenData.getPixel(2, 2);
      expect(color, const Color(0xFF000000));
    });

    test('returns black for coordinates exceeding pixel array', () {
      final smallData = ScreenData(
        width: 10,
        height: 10,
        pixels: [const Color(0xFFFF0000)], // Only 1 pixel
      );

      final color = smallData.getPixel(5, 5); // Valid coords but no pixel data
      expect(color, const Color(0xFF000000));
    });
  });
}
