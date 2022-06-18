import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/generated/assets.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/screens/view_all_questions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class FolderWidget extends StatelessWidget {
  final FolderModel folderModel;
  final bool isSelected;
  final Function refreshViewAllFolders;
  final Function showAddFolderAlertDialog;

  const FolderWidget({
    Key key,
    @required this.folderModel,
    @required this.isSelected,
    @required this.refreshViewAllFolders,
    this.showAddFolderAlertDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Device.screenWidth / 2,
      margin: EdgeInsets.symmetric(
        horizontal: Device.screenWidth * 0.03,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          /// bottom right
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(5, 5),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),

          /// top left
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(-5, -5),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Image.asset(Assets.imagesFolderIcon),
            ),
            // const SizedBox(height: 2.0),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      // color: Colors.redAccent,
                      padding: const EdgeInsets.only(left: 14.0),
                      child: SkywaText(
                        text: folderModel.folderName,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: !isSelected
                        ? IconButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              String updatedFolderName;
                              updatedFolderName = showAddFolderAlertDialog(
                                folderModel: folderModel,
                                mode: 'edit',
                              );
                              print(updatedFolderName);
                            },
                            icon: Icon(Icons.edit_rounded),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
