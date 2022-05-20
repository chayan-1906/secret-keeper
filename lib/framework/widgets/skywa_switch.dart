import 'package:flutter/material.dart';

import '../../services/color_themes.dart';
import '../../services/is_string_invalid.dart';
import 'skywa_text.dart';

class SkywaSwitch extends StatelessWidget {
  final bool value;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final ValueChanged<bool> onChanged;

  SkywaSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    @required this.title,
    this.fontSize,
    this.fontWeight,
  })  : assert(value != null),
        assert(onChanged != null),
        assert(!isStringInvalid(text: title)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: ColorThemes.primaryColor,
      title: SkywaText(text: title, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
