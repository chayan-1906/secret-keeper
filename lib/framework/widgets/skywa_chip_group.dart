/*
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../services/color_themes.dart';

class SkywaChip extends StatefulWidget {
  final String label;
  final double fontSize;
  // final bool selected;
  final ValueChanged<bool> onSelected;
  final bool isSelected;
  final WrapAlignment wrapAlignment;
  final Color backgroundColor;

  SkywaChip({
    Key key,
    @required this.label,
    this.fontSize = 17.0,
    // this.selected = false,
    this.isSelected,
    this.wrapAlignment = WrapAlignment.spaceAround,
    @required this.onSelected,
    this.backgroundColor,
  })  : assert(!isStringInvalid(text: label)),
        assert(onSelected != null),
        super(key: key);

  @override
  State<SkywaChip> createState() => _SkywaChipState();
}

class _SkywaChipState extends State<SkywaChip> {
  String label;
  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    label = widget.label;
    isSelected = widget.isSelected ?? widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Device.screenWidth,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
        boxShadow: widget.backgroundColor == null
            ? [
                /// bottom right
                BoxShadow(
                  offset: const Offset(5, 5),
                  spreadRadius: 2.0,
                  blurRadius: 6.0,
                  color: Colors.grey.shade300,
                ),

                /// top left
                BoxShadow(
                  offset: const Offset(-5, -5),
                  spreadRadius: 5.0,
                  blurRadius: 2.0,
                  color: Colors.grey.shade200,
                ),
              ]
            : [],
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: widget.wrapAlignment,
        children: [
          Container(
            width: Device.screenWidth * 0.40,
            alignment: Alignment.center,
            child: InputChip(
              label: SkywaText(text: widget.label, color: Colors.white),
              elevation: 8.0,
              pressElevation: 20.0,
              checkmarkColor: Colors.white,
              shadowColor: CupertinoColors.systemGrey3,
              backgroundColor: ColorThemes.accentColor,
              selectedColor: ColorThemes.primaryDarkColor,
              selected: widget.isSelected,
              onSelected: widget.onSelected,
            ),
          ),
        ],
      ),
    );
  }
}
*/
