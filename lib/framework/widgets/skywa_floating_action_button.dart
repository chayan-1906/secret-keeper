import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../services/color_themes.dart';

class SkywaFloatingActionButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Function onTap;

  const SkywaFloatingActionButton({
    @required this.iconData,
    this.iconSize = 45.0,
    @required this.onTap,
  })  : assert(iconData != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Device.screenHeight * 0.08,
      // width: Device.screenHeight * 0.08,
      margin: EdgeInsets.all(Device.screenHeight * 0.02),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          /// bottom right
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(5, 5),
          ),

          /// top left
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(-5, -5),
          ),

          /// top right
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(5, -5),
          ),

          /// bottom left
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(-5, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        iconSize: iconSize,
        icon: Icon(
          iconData,
          color: ColorThemes.primaryColor,
          // size: Device.screenHeight * 0.07,
        ),
      ),
    );
  }
}
