import 'package:diary_app/framework/widgets/skywa_cached_network_image.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/screens/image_view_screen.dart';
import 'package:diary_app/services/global_methods.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../framework/widgets/skywa_text.dart';
import '../models/note_model.dart';
import '../services/is_string_invalid.dart';
import 'expandable_container.dart';
import 'glassmorphic_loader.dart';

class NoteRowWidget extends StatefulWidget {
  final FolderModel folderModel;
  final NoteModel noteModel;
  final bool expanded;

  const NoteRowWidget({
    Key key,
    @required this.folderModel,
    @required this.noteModel,
    this.expanded = true,
  }) : super(key: key);

  @override
  State<NoteRowWidget> createState() => _NoteRowWidgetState();
}

class _NoteRowWidgetState extends State<NoteRowWidget> {
  bool expanded;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expanded = widget.expanded;
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      width: Device.screenWidth,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
            child: Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: noteModel.noteAnswer.entries.length,
                  itemBuilder: (BuildContext context, int noteAnswerKeyIndex) {
                    List questionIds = [];
                    List questionTexts = [];
                    List questionTypes = [];
                    List answerTexts = [];
                    for (MapEntry noteAnsEntry
                        in noteModel.noteAnswer.entries) {
                      questionIds.add(noteAnsEntry.key);
                      answerTexts.add(noteAnsEntry.value);
                    }
                    for (String quesId in questionIds) {
                      for (var question in folderModel.questions) {
                        if (quesId == question['questionId']) {
                          questionTexts.add(question['questionText']);
                          questionTypes.add(question['questionType']);
                        }
                      }
                    }
                    // print('95: ${questionTexts}');
                    // print('96: ${questionTypes}');

                    return !isStringInvalid(
                            text: answerTexts[noteAnswerKeyIndex])
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// question
                              SkywaText(
                                text: '${questionTexts[noteAnswerKeyIndex]}',
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                              SizedBox(height: 10.0),

                              /// answer
                              if (questionTypes[noteAnswerKeyIndex] == 'Image')
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      answerTexts[noteAnswerKeyIndex],
                                      // 'https://firebasestorage.googleapis.com/v0/b/diary-app-chayan19062000.appspot.com/o/Gg4AUbfFxUPRzo9Rj2BlutTjUX73%2Fimages%2Fscaled_image_picker5802639931423379316.jpg?alt=media&token=66f078b5-4533-4d2f-b7ed-66a53c6dab21',
                                      width: Device.screenWidth,
                                      height: Device.screenHeight * 0.40,
                                    ),
                                  ),
                                )
                              else if (questionTypes[noteAnswerKeyIndex] ==
                                  'File')
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: ListTile(
                                      leading: GlobalMethods.getFileIcon(
                                          url: answerTexts[noteAnswerKeyIndex]),
                                      title: SkywaText(
                                        text: GlobalMethods.getFilenameFromUrl(
                                            url: answerTexts[
                                                noteAnswerKeyIndex]),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SkywaText(
                                  text: 'A: ${answerTexts[noteAnswerKeyIndex]}',
                                  maxLines: 1,
                                ),
                              SizedBox(height: 25.0),
                            ],
                          )
                        : Container();
                  },
                ),

                /// info icon button
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.info_outline_rounded),
                  ),
                ),
              ],
            ),
          ),
          SkywaText(
            text: 'creation date: ${noteModel.noteCreationDate.toString()}',
          ),
        ],
      ),
    );*/
    return Stack(
      children: [
        ExpandableContainer(
          expanded: expanded,
          collapsedChild: Container(
            width: Device.screenWidth,
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // itemCount: widget.noteModel.noteAnswer.entries.length,
              itemCount: 1,
              itemBuilder: (BuildContext context, int noteAnswerKeyIndex) {
                List questionIds = [];
                List questionTexts = [];
                List questionTypes = [];
                List answerTexts = [];
                int indexToBeShown = 0;
                for (MapEntry noteAnsEntry
                    in widget.noteModel.noteAnswer.entries) {
                  questionIds.add(noteAnsEntry.key);
                  answerTexts.add(noteAnsEntry.value);
                }
                for (String quesId in questionIds) {
                  for (var question in widget.folderModel.questions) {
                    if (quesId == question['questionId']) {
                      questionTexts.add(question['questionText']);
                      questionTypes.add(question['questionType']);
                    }
                  }
                }
                // print('95: ${questionTexts}');
                // print('96: ${questionTypes}');
                for (int index = 0;
                    index < widget.noteModel.noteAnswer.entries.length;
                    index++) {
                  if (!isStringInvalid(text: answerTexts[index])) {
                    indexToBeShown = index;
                    break;
                  }
                }

                return !isStringInvalid(text: answerTexts[indexToBeShown])
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// question
                          Row(
                            children: [
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.pan_tool_alt_rounded),
                              ),
                              SizedBox(width: 5.0),
                              SkywaText(
                                text: questionTexts[indexToBeShown],
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),

                          /// answer
                          if (questionTypes[indexToBeShown] == 'Image')
                            /*Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  answerTexts[indexToBeShown],
                                  width: Device.screenWidth,
                                  height: Device.screenHeight * 0.40,
                                ),
                              ),
                            )*/
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ImageViewScreen(
                                        imageUrl: answerTexts[indexToBeShown],
                                      ),
                                      type: PageTransitionType.rippleRightUp,
                                    ),
                                  );
                                },
                                child: SkywaCachedNetworkImage.clipRRect(
                                  imageUrl: answerTexts[indexToBeShown],
                                  height: 250.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          else if (questionTypes[indexToBeShown] == 'File')
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    GlobalMethods.downloadAndOpenFile(
                                            url: answerTexts[indexToBeShown])
                                        .then((value) {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                                  },
                                  leading: GlobalMethods.getFileIcon(
                                      url: answerTexts[indexToBeShown]),
                                  title: SkywaText(
                                    text: GlobalMethods.getFilenameFromUrl(
                                        url: answerTexts[indexToBeShown]),
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                            )
                          else
                            Row(
                              children: [
                                SizedBox(width: 5.0),
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                ),
                                SizedBox(width: 15.0),
                                SkywaText(
                                  text: answerTexts[indexToBeShown],
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          SizedBox(height: 25.0),
                        ],
                      )
                    : Container();
              },
            ),
          ),
          expandedChild: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.noteModel.noteAnswer.entries.length,
              itemBuilder: (BuildContext context, int noteAnswerKeyIndex) {
                List questionIds = [];
                List questionTexts = [];
                List questionTypes = [];
                List answerTexts = [];
                for (MapEntry noteAnsEntry
                    in widget.noteModel.noteAnswer.entries) {
                  questionIds.add(noteAnsEntry.key);
                  answerTexts.add(noteAnsEntry.value);
                }
                for (String quesId in questionIds) {
                  for (var question in widget.folderModel.questions) {
                    if (quesId == question['questionId']) {
                      questionTexts.add(question['questionText']);
                      questionTypes.add(question['questionType']);
                    }
                  }
                }

                return !isStringInvalid(text: answerTexts[noteAnswerKeyIndex])
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// question
                          Row(
                            children: [
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(Icons.pan_tool_alt_rounded),
                              ),
                              SizedBox(width: 5.0),
                              SkywaText(
                                text: '${questionTexts[noteAnswerKeyIndex]}',
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),

                          /// answer
                          if (questionTypes[noteAnswerKeyIndex] == 'Image')
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ImageViewScreen(
                                        imageUrl:
                                            answerTexts[noteAnswerKeyIndex],
                                      ),
                                      type: PageTransitionType.rippleRightUp,
                                    ),
                                  );
                                },
                                child: SkywaCachedNetworkImage.clipRRect(
                                  imageUrl: answerTexts[noteAnswerKeyIndex],
                                  height: 250.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          else if (questionTypes[noteAnswerKeyIndex] == 'File')
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    GlobalMethods.downloadAndOpenFile(
                                            url:
                                                answerTexts[noteAnswerKeyIndex])
                                        .then((value) {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    });
                                  },
                                  leading: GlobalMethods.getFileIcon(
                                      url: answerTexts[noteAnswerKeyIndex]),
                                  title: SkywaText(
                                    text: GlobalMethods.getFilenameFromUrl(
                                        url: answerTexts[noteAnswerKeyIndex]),
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                            )
                          else
                            Row(
                              children: [
                                SizedBox(width: 5.0),
                                Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                ),
                                SizedBox(width: 15.0),
                                SkywaText(
                                  text: answerTexts[noteAnswerKeyIndex],
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          SizedBox(height: 25.0),
                        ],
                      )
                    : Container();
              },
            ),
          ),
        ),

        /// info & collapse/expand icon button
        Positioned(
          top: 20.0,
          right: 20.0,
          child: Row(
            children: [
              Container(
                // color: Colors.lightBlueAccent,
                child: Tooltip(
                  message:
                      'Creation Date: ${widget.noteModel.noteCreationDate.toString().substring(0, 16)}',
                  triggerMode: TooltipTriggerMode.tap,
                  // showDuration: Duration(seconds: 2),
                  // waitDuration: Duration(seconds: 2),
                  child: Icon(Icons.info_outline_rounded),
                ),
              ),
              SizedBox(width: 5.0),
              !expanded
                  ? Container(
                      // color: Colors.redAccent,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            expanded = true;
                          });
                          // print(expanded);
                        },
                        icon: Icon(EvaIcons.expand),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          expanded = false;
                        });
                        // print(expanded);
                      },
                      icon: Icon(EvaIcons.collapse),
                    ),
            ],
          ),
        ),

        if (isLoading) GlassMorphicLoader(),
      ],
    );
  }
}
