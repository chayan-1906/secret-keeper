import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../framework/widgets/skywa_text.dart';
import '../services/color_themes.dart';

class GlassMorphicLoader extends StatefulWidget {
  final String text;

  const GlassMorphicLoader({
    Key key,
    this.text = 'Please wait...',
  }) : super(key: key);

  @override
  _GlassMorphicLoaderState createState() => _GlassMorphicLoaderState();
}

class _GlassMorphicLoaderState extends State<GlassMorphicLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Device.screenHeight,
          width: Device.screenWidth,
          decoration: BoxDecoration(color: Colors.transparent),
        ),
        Container(
          alignment: Alignment.center,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              height: 100.0,
              width: Device.screenWidth * 0.70,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  width: 2.0,
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: ColorThemes.primaryDarkColor),
                  SizedBox(height: 10.0),
                  SkywaText(
                    text: widget.text,
                    fontWeight: FontWeight.w500,
                    color: ColorThemes.primaryDarkColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
