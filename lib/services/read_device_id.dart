/*import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_settings_constants.dart';

Future<String> readDeviceID(
    {@required SharedPreferences sharedPreferences}) async {
  UserSettings userSettings = UserSettings();
  String deviceID;
  deviceID = sharedPreferences.getString(userSettings.deviceID.key);
  if (deviceID == null) {
    print('Device ID not found');
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceID = build.androidId; // UUID for android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceID = data.identifierForVendor; // UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    print('DeviceID generated: $deviceID');
    return deviceID;
  } else {
    print('DeviceID found: $deviceID');
    return deviceID;
    //  DeviceID found: 658f7d221125e695 for Pixel 3 before 19th May morning wipe data
  }
}*/
