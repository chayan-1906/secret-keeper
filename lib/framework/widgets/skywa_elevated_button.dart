import 'package:flutter/material.dart';

import '../../services/color_themes.dart';
import 'skywa_text.dart';

class SkywaElevatedButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final String text;
  final double fontSize;
  final Function onTap;
  final Color buttonColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  SkywaElevatedButton.info({
    Key key,
    this.iconData,
    this.iconSize,
    @required this.text,
    this.fontSize = 18.0,
    @required this.onTap,
    this.padding,
    this.margin,
  })  : buttonColor = ColorThemes.secondaryColor,
        assert(text != null),
        assert(onTap != null),
        super(key: key);

  SkywaElevatedButton.save({
    Key key,
    this.iconData,
    this.iconSize,
    @required this.text,
    this.fontSize = 18.0,
    @required this.onTap,
    this.padding,
    this.margin,
  })  : buttonColor = ColorThemes.primaryColor,
        assert(text != null),
        assert(onTap != null),
        super(key: key);

  SkywaElevatedButton.delete({
    Key key,
    this.iconData,
    this.iconSize,
    @required this.text,
    this.fontSize = 18.0,
    @required this.onTap,
    this.padding,
    this.margin,
  })  : buttonColor = ColorThemes.errorColor,
        assert(text != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: padding ??
                const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
            margin: margin ?? const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8.0),
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
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
