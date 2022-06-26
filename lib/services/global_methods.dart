import 'dart:io';

import 'package:diary_app/framework/widgets/skywa_alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nanoid/nanoid.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../framework/widgets/skywa_outlined_button.dart';
import '../framework/widgets/skywa_text.dart';
import 'color_themes.dart';
import 'is_string_invalid.dart';

class GlobalMethods {
  static Future<void> customDialog(BuildContext context, String title,
      String subtitle, Function function) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                function();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> authErrorDialog(
    BuildContext context,
    String title,
    String subtitle,
  ) async {
    return SkywaAlertDialog.error(
      context: context,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: ColorThemes.errorColor,
        size: 40.0,
      ),
      titleText: title,
      titlePadding: EdgeInsets.only(
        top: Device.screenHeight * 0.025,
        bottom: Device.screenHeight * 0.030,
        left: Device.screenWidth * 0.07,
        right: Device.screenWidth * 0.07,
      ),
      fontSize: 22.0,
      content: Column(
        children: [
          SizedBox(height: 10.0),
          /// subtitle
          SkywaText(
            text: subtitle,
            maxLines: 4,
            fontSize: 18.0,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 25.0),

          /// actions button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SkywaOutlinedButton(
                  text: 'OKAY',
                  textColor: ColorThemes.primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> signOutDialog(
    BuildContext context,
    String title,
    String subtitle,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                await FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static String getInitialLetter({@required String text}) {
    String initialLetter = '';
    if (!isStringInvalid(text: text)) {
      initialLetter = text.substring(0, 1);
    }
    return initialLetter;
  }

  static String generateUniqueId() {
    String id = nanoid(20);
    return id;
  }

  static String getFilenameFromUrl({@required String url}) {
    String _filename = '';
    if (!isStringInvalid(text: url)) {
      _filename = url
          .split('%2Ffiles%2F')[1]
          .replaceAll('%20', ' ')
          .split('?alt=media&token=')[0];
    }
    return _filename;
  }

  static Future<void> downloadAndOpenFile({@required String url}) async {
    String fileName = getFilenameFromUrl(url: url);
    final directory = await getExternalStorageDirectory();
    File saveFileName = File('${directory.path}/${fileName}');
    if (saveFileName.existsSync()) {
      await OpenFile.open(saveFileName.path);
      return;
    }
    await Dio().download(
      url,
      saveFileName.path,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    );
    await OpenFile.open(saveFileName.path);
  }

  static Icon getFileIcon({String fileName, String url}) {
    Icon icon;
    if (isStringInvalid(text: fileName) && !isStringInvalid(text: url)) {
      fileName = getFilenameFromUrl(url: url);
    }
    if (fileName.contains('pdf')) {
      icon = Icon(
        MaterialIcons.picture_as_pdf,
        color: CupertinoColors.systemRed,
      );
    } else if (fileName.contains('doc') || fileName.contains('docx')) {
      icon = Icon(
        MaterialCommunityIcons.file_document_box,
        size: 30.0,
        color: Color(0xFF4285F4),
      );
    } else if (fileName.contains('xls') || fileName.contains('xlsx')) {
      icon = Icon(
        MaterialCommunityIcons.file_excel_box,
        size: 30.0,
        color: Color(0xFF34A853),
      );
    }
    return icon;
  }
}
