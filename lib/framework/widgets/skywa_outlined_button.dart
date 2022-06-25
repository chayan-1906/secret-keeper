import 'package:diary_app/services/color_themes.dart';
import 'package:flutter/material.dart';

import '../../services/is_string_invalid.dart';
import 'skywa_text.dart';

class SkywaOutlinedButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double iconSize;
  final Function onTap;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  SkywaOutlinedButton({
    Key key,
    @required this.text,
    this.iconData,
    this.iconSize,
    @required this.onTap,
    this.borderColor = ColorThemes.primaryColor,
    this.padding,
    this.margin,
    this.textColor = Colors.black,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.w500,
  })  : assert(!isStringInvalid(text: text)),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 25.0,
            ),
        margin: margin ?? const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            if (iconData != null)
              Icon(
                iconData,
                color: Colors.white,
                size: iconSize ?? IconTheme.of(context).size,
              ),
            if (iconData != null) const SizedBox(width: 10.0),
            SkywaText(
              text: text,
              fontSize: fontSize,
              color: textColor,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}
