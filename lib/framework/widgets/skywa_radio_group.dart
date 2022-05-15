import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../services/color_themes.dart';
import 'skywa_text.dart';

class SkywaRadioGroup extends StatefulWidget {
  final List<String> texts;
  final double fontSize;
  final ValueChanged<String> onChanged;
  final String selectedValue;
  final WrapAlignment wrapAlignment;
  final Color backgroundColor;

  const SkywaRadioGroup({
    Key key,
    @required this.texts,
    this.fontSize = 17.0,
    this.selectedValue,
    this.wrapAlignment = WrapAlignment.spaceAround,
    @required this.onChanged,
    this.backgroundColor,
  })  : assert(texts != null && texts.length != 0),
        assert(onChanged != null),
        super(key: key);

  @override
  State<SkywaRadioGroup> createState() => _SkywaRadioGroupState();
}

class _SkywaRadioGroupState extends State<SkywaRadioGroup> {
  List<String> texts;
  String selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    texts = widget.texts;
    selectedValue = widget.selectedValue ?? widget.texts[0];
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
          for (int i = 0; i < widget.texts.length; i++)
            Container(
              width: Device.screenWidth * 0.40,
              alignment: Alignment.center,
              // color: Colors.redAccent,
              child: RadioListTile(
                contentPadding: EdgeInsets.zero,
                // value: i.toString(),
                value: widget.texts[i],
                visualDensity: VisualDensity.adaptivePlatformDensity,
                activeColor: ColorThemes.primaryColor,
                title: SkywaText(
                  text: widget.texts[i],
                  fontWeight: FontWeight.w400,
                  fontSize: widget.fontSize,
                ),
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    widget.onChanged(value);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
