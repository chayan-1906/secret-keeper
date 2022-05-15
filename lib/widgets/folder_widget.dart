import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/screens/view_all_questions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class FolderWidget extends StatefulWidget {
  final FolderModel folderModel;

  const FolderWidget({
    Key key,
    @required this.folderModel,
  }) : super(key: key);

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  FolderModel folderModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Device.screenWidth / 2,
      margin: EdgeInsets.symmetric(
        horizontal: Device.screenWidth * 0.03,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          /// bottom right
          const BoxShadow(
            color: Colors.grey,
            offset: Offset(5, 5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),

          /// top left
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(-5, -5),
            blurRadius: 1.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              Icons.folder_rounded,
              size: 90.0,
              color: Colors.grey.shade800,
            ),
            const SizedBox(height: 5.0),
            SkywaText(
              text: folderModel.folderName,
              fontSize: 19.0,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
