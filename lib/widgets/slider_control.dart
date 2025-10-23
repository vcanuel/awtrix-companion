import 'package:flutter/material.dart';

class SliderControl extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const SliderControl({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // S'assurer que la valeur est dans les limites
    final clampedValue = value.clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    if (clampedValue > min) {
                      onChanged((clampedValue - 1).clamp(min, max));
                    }
                  },
                ),
                Text(
                  clampedValue.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (clampedValue < max) {
                      onChanged((clampedValue + 1).clamp(min, max));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Slider(
          value: clampedValue,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.white,
          inactiveColor: Colors.grey.shade700,
        ),
      ],
    );
  }
}
