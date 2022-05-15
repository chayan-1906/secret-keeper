import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../services/color_themes.dart';
import '../../services/is_string_invalid.dart';
import 'skywa_text.dart';

class SkywaAppBar extends StatelessWidget {
  final String appbarText;
  final bool centerTitle;
  IconButton backIconButton;
  final double size;
  final List<Widget> actions;

  SkywaAppBar({
    Key key,
    @required this.appbarText,
    this.centerTitle = true,
    this.backIconButton,
    this.size,
    this.actions,
  })  : assert(!isStringInvalid(text: appbarText)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (backIconButton == null && Navigator.canPop(context)) {
      backIconButton = IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      elevation: 0.0,
      backgroundColor: ColorThemes.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(Device.screenHeight * 0.02),
        ),
      ),
      leading: backIconButton,
      title: SkywaText(
        text: appbarText,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      actions: actions ?? [],
    );
  }
}
