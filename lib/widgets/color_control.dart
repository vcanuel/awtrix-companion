import 'package:flutter/material.dart';

class ColorControl extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ColorControl({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade700, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
