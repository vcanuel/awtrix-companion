import 'dart:ui';

class ScreenData {
  final int width;
  final int height;
  final List<Color> pixels;

  ScreenData({
    required this.width,
    required this.height,
    required this.pixels,
  });

  factory ScreenData.fromRgb565List(List<int> data, {int width = 32, int height = 8}) {
    final pixels = <Color>[];

    for (int i = 0; i < data.length; i += 2) {
      if (i + 1 < data.length) {
        final rgb565 = (data[i] << 8) | data[i + 1];

        // Convert RGB565 to RGB888
        final r = ((rgb565 >> 11) & 0x1F) * 255 ~/ 31;
        final g = ((rgb565 >> 5) & 0x3F) * 255 ~/ 63;
        final b = (rgb565 & 0x1F) * 255 ~/ 31;

        pixels.add(Color.fromARGB(255, r, g, b));
      }
    }

    return ScreenData(
      width: width,
      height: height,
      pixels: pixels,
    );
  }

  Color getPixel(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return const Color(0xFF000000);
    }
    final index = y * width + x;
    if (index >= pixels.length) {
      return const Color(0xFF000000);
    }
    return pixels[index];
  }
}
