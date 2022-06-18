import 'package:flutter/material.dart';

import '../../services/is_string_invalid.dart';
import 'skywa_text.dart';

class SkywaTextButton extends StatefulWidget {
  final String text;
  final Function onTap;
  final Color buttonColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  SkywaTextButton({
    Key key,
    @required this.text,
    @required this.onTap,
    this.buttonColor,
    this.padding,
    this.margin,
    this.textColor,
    this.fontSize = 18.0,
    this.fontWeight,
  })  : assert(!isStringInvalid(text: text)),
        assert(onTap != null),
        super(key: key);

  @override
  State<SkywaTextButton> createState() => _SkywaTextButtonState();
}

class _SkywaTextButtonState extends State<SkywaTextButton> {
  /*bool isPressed = false;*/

  @override
  Widget build(BuildContext context) {
    /*print(isPressed);*/
    return GestureDetector(
      onTap: () {
        /*setState(() {
          isPressed = true;
        });*/
        widget.onTap();
        /*setState(() {
          isPressed = false;
        });*/
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            /*padding: padding != null
                ? padding
                : const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            margin: margin != null ? margin : const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8.0),
            ),*/
            child: Card(
              /*elevation: isPressed ? 8.0 : 1.0,*/
              elevation: 1.0,
              margin: widget.margin != null
                  ? widget.margin
                  : const EdgeInsets.all(0.0),
              color: widget.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: widget.padding != null
                    ? widget.padding
                    : const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 25.0),
                child: SkywaText(
                  text: widget.text,
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
