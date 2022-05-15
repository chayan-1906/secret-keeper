import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class SkywaBottomSheet {
  final BuildContext context;
  final bool isDismissible;
  final Color color;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;

  SkywaBottomSheet({
    @required this.context,
    this.isDismissible = true,
    this.color = Colors.white,
    @required this.content,
    this.contentPadding,
  })  : assert(context != null),
        assert(content != null) {
    displayBottomSheet();
  }

  void displayBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: Device.screenHeight * 0.04,
                horizontal: Device.screenWidth * 0.03,
              ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
          ),
          child: content,
        );
      },
    );
  }
}
