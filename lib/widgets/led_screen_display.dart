import 'package:flutter/material.dart';
import '../models/screen_data.dart';

class LedScreenDisplay extends StatelessWidget {
  final ScreenData? screenData;
  final double height;

  const LedScreenDisplay({
    super.key,
    required this.screenData,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    if (screenData == null) {
      return Container(
        height: height,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey.shade800, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: CustomPaint(
          key: ValueKey(screenData.hashCode),
          painter: LedMatrixPainter(screenData!),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class LedMatrixPainter extends CustomPainter {
  final ScreenData screenData;

  LedMatrixPainter(this.screenData);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelWidth = size.width / screenData.width;
    final pixelHeight = size.height / screenData.height;
    final pixelSize = pixelWidth < pixelHeight ? pixelWidth : pixelHeight;

    // Centrer la matrice si nécessaire
    final offsetX = (size.width - (pixelSize * screenData.width)) / 2;
    final offsetY = (size.height - (pixelSize * screenData.height)) / 2;

    // Dessiner chaque pixel
    for (int y = 0; y < screenData.height; y++) {
      for (int x = 0; x < screenData.width; x++) {
        final color = screenData.getPixel(x, y);

        // Dessiner le pixel comme un petit carré avec un léger espace
        final pixelPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        final pixelRect = Rect.fromLTWH(
          offsetX + (x * pixelSize) + (pixelSize * 0.1),
          offsetY + (y * pixelSize) + (pixelSize * 0.1),
          pixelSize * 0.8,
          pixelSize * 0.8,
        );

        // Dessiner un cercle pour simuler les LED
        canvas.drawCircle(
          Offset(
            pixelRect.left + pixelRect.width / 2,
            pixelRect.top + pixelRect.height / 2,
          ),
          pixelRect.width / 2,
          pixelPaint,
        );

        // Ajouter un effet de brillance si le pixel est allumé
        if (color.computeLuminance() > 0.1) {
          final glowPaint = Paint()
            ..color = color.withValues(alpha: 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

          canvas.drawCircle(
            Offset(
              pixelRect.left + pixelRect.width / 2,
              pixelRect.top + pixelRect.height / 2,
            ),
            pixelRect.width / 2 + 1,
            glowPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(LedMatrixPainter oldDelegate) {
    return oldDelegate.screenData != screenData;
  }
}
