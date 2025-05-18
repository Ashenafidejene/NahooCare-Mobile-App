import 'package:flutter/material.dart';

class DistanceIndicator extends StatefulWidget {
  final int currentDistance;
  final ValueChanged<int> onChanged;

  const DistanceIndicator({
    Key? key,
    required this.currentDistance,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<DistanceIndicator> createState() => _DistanceIndicatorState();
}

class _DistanceIndicatorState extends State<DistanceIndicator> {
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.currentDistance.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search radius: ${_currentSliderValue.round()} km'),
        Slider(
          value: _currentSliderValue,
          min: 1,
          max: 100,
          divisions: 99,
          label: _currentSliderValue.round().toString(),
          onChanged: (value) {
            setState(() {
              _currentSliderValue = value;
            });
            widget.onChanged(value.round());
          },
        ),
      ],
    );
  }
}
