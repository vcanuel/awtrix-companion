import 'package:flutter/material.dart';

class SliderControl extends StatefulWidget {
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
  State<SliderControl> createState() => _SliderControlState();
}

class _SliderControlState extends State<SliderControl> {
  late double _localValue;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(SliderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mettre à jour la valeur locale seulement si on n'est pas en train de glisser
    if (!_isSliding && widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  void _handleValueChange(double newValue) {
    setState(() {
      _localValue = newValue;
      _isSliding = true;
    });
  }

  void _handleValueChangeEnd(double newValue) {
    setState(() {
      _localValue = newValue;
      _isSliding = false;
    });
    // Envoyer la valeur finale à l'API
    widget.onChanged(newValue);
  }

  void _handleButtonPress(double newValue) {
    setState(() {
      _localValue = newValue;
    });
    // Pour les boutons +/-, envoyer immédiatement
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    // S'assurer que la valeur est dans les limites
    final clampedValue = _localValue.clamp(widget.min, widget.max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    if (clampedValue > widget.min) {
                      final newValue = (clampedValue - 1).clamp(
                        widget.min,
                        widget.max,
                      );
                      _handleButtonPress(newValue);
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
                    if (clampedValue < widget.max) {
                      final newValue = (clampedValue + 1).clamp(
                        widget.min,
                        widget.max,
                      );
                      _handleButtonPress(newValue);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Slider(
          value: clampedValue,
          min: widget.min,
          max: widget.max,
          onChanged: _handleValueChange,
          onChangeEnd: _handleValueChangeEnd,
          activeColor: Colors.white,
          inactiveColor: Colors.grey.shade700,
        ),
      ],
    );
  }
}
