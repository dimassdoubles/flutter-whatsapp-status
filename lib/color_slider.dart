import 'package:flutter/material.dart';

class ColorSlider extends StatefulWidget {
  final void Function(Color selectedColor)? _onColorChanged;
  const ColorSlider({
    super.key,
    void Function(Color selectedColor)? onColorChanged,
  }) : _onColorChanged = onColorChanged;

  @override
  State<ColorSlider> createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider> {
  double _sliderValue = 0.0;

  void _updateColor(double value) {
    int index = (value * (timelineColors.length - 1)).round();
    setState(() {
      _sliderValue = value;
      widget._onColorChanged?.call(timelineColors[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        width: 200,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2),
          gradient: LinearGradient(
            colors: timelineColors,
            stops: timelineStops,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            thumbShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            value: _sliderValue,
            onChanged: _updateColor,
            min: 0,
            max: 1,
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

List<Color> timelineColors = [
  Colors.white,
  Colors.black,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.red,
];

List<double> timelineStops = [
  0.14,
  0.28,
  0.42,
  0.56,
  0.70,
  0.84,
  1,
];
