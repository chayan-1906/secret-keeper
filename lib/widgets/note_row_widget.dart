import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/services/global_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../framework/widgets/skywa_text.dart';
import '../models/note_model.dart';
import '../services/is_string_invalid.dart';

class NoteRowWidget extends StatelessWidget {
  final FolderModel folderModel;
  final NoteModel noteModel;

  const NoteRowWidget({
    Key key,
    @required this.folderModel,
    @required this.noteModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                text: 'Q: ${questionTexts[noteAnswerKeyIndex]}',
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
              text: 'creation date: ${noteModel.noteCreationDate.toString()}'),
        ],
      ),
    );
  }
}
