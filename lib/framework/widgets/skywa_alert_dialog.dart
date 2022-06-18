import 'package:diary_app/services/color_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'skywa_text.dart';

class SkywaAlertDialog {
  final BuildContext context;
  // final bool barrierDismissible;
  final String titleText;
  final EdgeInsetsGeometry titlePadding;
  final double fontSize;
  final Widget content;
  final Color color;
  final Widget icon;
  final List<Widget> actions;

  SkywaAlertDialog.success({
    @required this.context,
    // this.barrierDismissible = true,
    this.titleText = '',
    this.titlePadding,
    this.fontSize = 18.0,
    @required this.content,
    this.color = ColorThemes.secondaryDarkColor,
    this.icon,
    this.actions,
  })  : assert(context != null),
        assert(content != null) {
    displayAlertDialog();
  }

  SkywaAlertDialog.info({
    @required this.context,
    // this.barrierDismissible = true,
    this.titleText = '',
    this.titlePadding,
    this.fontSize = 18.0,
    @required this.content,
    this.color = ColorThemes.primaryColor,
    this.icon,
    this.actions,
  })  : assert(context != null),
        assert(content != null) {
    displayAlertDialog();
  }

  SkywaAlertDialog.error({
    @required this.context,
    // this.barrierDismissible = true,
    this.titleText = '',
    this.titlePadding,
    this.fontSize = 18.0,
    @required this.content,
    this.color = ColorThemes.errorColor,
    this.icon,
    this.actions,
  })  : assert(context != null),
        assert(content != null) {
    displayAlertDialog();
  }

  void displayAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0.0),
            titlePadding: const EdgeInsets.all(0.0),
            /*title: !isStringInvalid(text: titleText)
                ? Container(
                    width: Device.screenWidth * 0.65,
                    padding: titlePadding ??
                        EdgeInsets.only(
                          top: Device.screenHeight * 0.01,
                          bottom: Device.screenHeight * 0.01,
                          left: Device.screenWidth * 0.05,
                          right: Device.screenWidth * 0.01,
                        ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: icon == null
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        SkywaText(
                          text: titleText,
                          fontSize: fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        if (icon != null) icon,
                      ],
                    ),
                  )
                : Container(),
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: isStringInvalid(text: titleText)
                      ? const Radius.circular(12.0)
                      : const Radius.circular(0.0),
                  topRight: isStringInvalid(text: titleText)
                      ? Radius.circular(12.0)
                      : Radius.circular(0.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: content,
            ),*/
            content: Container(
              // height: 100.0,
              width: Device.screenWidth,
              constraints: BoxConstraints(
                minHeight: Device.screenHeight * 0.08,
                maxHeight: Device.screenHeight * 0.50,
              ),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  /// close icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: ColorThemes.errorColor,
                        ),
                      ),
                    ],
                  ),

                  icon ?? Container(),
                  Center(
                    child: SkywaText(
                      text: titleText,
                      fontSize: fontSize + 5.0,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),

                  /// content
                  content,
                ],
              ),
            ),
            actions: actions,
          );
        });
  }
}
