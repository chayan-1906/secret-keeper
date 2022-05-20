import 'package:diary_app/services/color_themes.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:flutter/material.dart';

class SkywaSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double minValue;
  final double maxValue;
  final bool allowDivisions;

  SkywaSlider({
    Key key,
    @required this.value,
    @required this.onChanged,
    @required this.minValue,
    @required this.maxValue,
    this.allowDivisions = false,
  })  : assert(value != null),
        assert(onChanged != null),
        assert(minValue != null),
        assert(maxValue != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slider.adaptive(
      value: value,
      onChanged: onChanged,
      label: value.toString(),
      activeColor: ColorThemes.primaryColor,
      inactiveColor: Colors.grey.shade600,
      divisions: allowDivisions ? (maxValue - minValue).round() : null,
      thumbColor: ColorThemes.primaryColor,
      min: minValue,
      max: maxValue,
    );
  }
}
