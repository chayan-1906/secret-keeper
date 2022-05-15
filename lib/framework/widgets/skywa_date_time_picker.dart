import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/color_themes.dart';

class SkywaDateTimePicker {
  final BuildContext context;
  final bool use24hFormat;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final int minimumYear;
  final int maximumYear;

  SkywaDateTimePicker.dateAndTime({
    @required this.context,
    @required this.onDateTimeChanged,
    this.use24hFormat = false,
    this.initialDateTime,
    this.minimumDate,
    this.minimumYear,
    this.maximumDate,
    this.maximumYear,
  })  : assert(context != null),
        assert(onDateTimeChanged != null) {
    showSkywaDateTimePicker();
  }

  SkywaDateTimePicker.date({
    @required this.context,
    @required this.onDateTimeChanged,
    this.use24hFormat = false,
    this.initialDateTime,
    this.minimumDate,
    this.minimumYear,
    this.maximumDate,
    this.maximumYear,
  })  : assert(context != null),
        assert(onDateTimeChanged != null) {
    showSkywaDatePicker();
  }

  SkywaDateTimePicker.time({
    @required this.context,
    @required this.onDateTimeChanged,
    this.use24hFormat = false,
    this.initialDateTime,
    this.minimumDate,
    this.minimumYear,
    this.maximumDate,
    this.maximumYear,
  })  : assert(context != null),
        assert(onDateTimeChanged != null) {
    showSkywaTimePicker();
  }

  DateTime now = DateTime.now();

  void showSkywaDateTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          onDateTimeChanged: onDateTimeChanged,
          initialDateTime: initialDateTime ?? now,
          use24hFormat: use24hFormat,
          backgroundColor: ColorThemes.primaryColor.withOpacity(0.2),
          minimumDate: minimumDate ?? now,
          minimumYear: minimumYear ?? now.year,
          maximumDate:
              maximumDate ?? DateTime(now.year, now.month, now.day + 30),
          maximumYear: maximumYear ?? now.year + 1,
        );
      },
    );
  }

  void showSkywaDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: onDateTimeChanged,
          initialDateTime: initialDateTime ?? now,
          use24hFormat: use24hFormat,
          backgroundColor: ColorThemes.primaryColor.withOpacity(0.2),
          minimumDate: minimumDate ?? now,
          minimumYear: minimumYear ?? now.year,
          maximumDate:
              maximumDate ?? DateTime(now.year, now.month, now.day + 30),
          maximumYear: maximumYear ?? now.year + 1,
        );
      },
    );
  }

  void showSkywaTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: onDateTimeChanged,
          initialDateTime: DateTime.now(),
          use24hFormat: use24hFormat,
          backgroundColor: ColorThemes.primaryColor.withOpacity(0.2),
        );
      },
    );
  }
}
