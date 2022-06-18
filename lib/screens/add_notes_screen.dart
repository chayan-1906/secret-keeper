import 'dart:io';
import 'dart:ui';

import 'package:diary_app/framework/widgets/skywa_bottom_sheet.dart';
import 'package:diary_app/framework/widgets/skywa_cached_network_image.dart';
import 'package:diary_app/framework/widgets/skywa_choice_chip_group.dart';
import 'package:diary_app/framework/widgets/skywa_date_time_picker.dart';
import 'package:diary_app/framework/widgets/skywa_dropdown_button.dart';
import 'package:diary_app/framework/widgets/skywa_slider.dart';
import 'package:diary_app/framework/widgets/skywa_snackbar.dart';
import 'package:diary_app/framework/widgets/skywa_switch.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/models/note_model.dart';
import 'package:diary_app/screens/image_view_screen.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../framework/widgets/skywa_alert_dialog.dart';
import '../framework/widgets/skywa_appbar.dart';
import '../framework/widgets/skywa_auto_size_text.dart';
import '../framework/widgets/skywa_elevated_button.dart';
import '../models/folder_model.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';
import '../widgets/glassmorphic_loader.dart';

class AddNotesScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function fetchAllNotes;
  final NoteModel noteModel;
  final int index;

  const AddNotesScreen({
    Key key,
    @required this.folderModel,
    @required this.fetchAllNotes,
    this.noteModel,
    this.index,
  }) : super(key: key);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FolderModel folderModel;
  int noteIndexToBeEdited;
  NoteModel noteModel;
  List<dynamic> questions;
  List<String> questionIds;
  List<String> questionTexts;
  Map<String, dynamic> answerMap;
  List<NoteModel> notes;
  Map<String, TextEditingController> qIdTextEditingController = {};
  List<dynamic> dbNotesList = [];
  bool isLoading = false;
  double uploadProgress = 0.0;
  bool allowPop = true;

  /*void showLoadingAlertDialog({@required BuildContext context}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(color: ColorThemes.primaryColor),
                  SizedBox(height: 15.0),
                  Text('Please wait...')
                ],
              ),
            ),
          );
        });
  }*/

  Widget buildNotesAnswerWidget(
      {@required BuildContext context, @required int index}) {
    uploadProgress = 0.0;
    String questionType = questions[index]['questionType'];
    String questionText = questions[index]['questionText'];
    String questionId = questions[index]['questionId'];
    bool isRequired = questions[index]['isRequired'];
    if (questionType == 'Text') {
      return SkywaTextFormField.text(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Name') {
      return SkywaTextFormField.name(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Email') {
      return SkywaTextFormField.emailAddress(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Phone') {
      return SkywaTextFormField.phone(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Number') {
      return SkywaTextFormField.numberWithOptions(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Url') {
      return SkywaTextFormField.url(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Multiline') {
      return SkywaTextFormField.multiline(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        maxLines: null,
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Date') {
      return GestureDetector(
        onTap: () {
          SkywaDateTimePicker.date(
            context: context,
            onDateTimeChanged: (DateTime _date) {
              setState(() {
                qIdTextEditingController[questionId].text =
                    _date.toString().substring(0, 10);
              });
            },
            initialDateTime: !isStringInvalid(
                    text: qIdTextEditingController[questionId].text)
                ? DateTime.parse(qIdTextEditingController[questionId].text)
                : DateTime.now(),
            minimumYear: 1950,
            minimumDate: DateTime(1900, 01, 01),
            maximumYear: 2050,
            maximumDate: DateTime(2050, 12, 31),
          );
        },
        child: SkywaTextFormField.datetime(
          textEditingController: qIdTextEditingController[questionId],
          labelText: questionText,
          hintText: 'Enter $questionText...',
          readOnly: true,
          enabled: false,
          validator: isRequired
              ? (value) {
                  if (value.isEmpty) {
                    return 'Mandatory field can\'t be empty';
                  }
                }
              : null,
          onChanged: (String value) {
            setState(() {
              qIdTextEditingController[questionId];
            });
          },
          onDateTimeChanged: (DateTime value) {},
        ),
      );
    } else if (questionType == 'Address') {
      return SkywaTextFormField.streetAddress(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
        validator: isRequired
            ? (value) {
                if (value.isEmpty) {
                  return 'Mandatory field can\'t be empty';
                }
              }
            : null,
        onChanged: (String value) {
          setState(() {
            qIdTextEditingController[questionId];
          });
        },
        suffixIcon: qIdTextEditingController[questionId].text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    qIdTextEditingController[questionId].clear();
                  });
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorThemes.primaryColor,
                ),
              )
            : null,
      );
    } else if (questionType == 'Chip') {
      // if (qIdTextEditingController[questionId].text.isEmpty)
      // qIdTextEditingController[questionId].text = '0';
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            // enabled: false,
            readOnly: true,
            showDecoration: false,
            validator: isRequired
                ? (value) {
                    if (value.isEmpty) {
                      return 'Mandatory field can\'t be empty';
                    }
                  }
                : null,
          ),
          Container(
            width: Device.screenWidth,
            // color: Colors.redAccent,
            child: SkywaChoiceChipGroup(
              selectedValue: qIdTextEditingController[questionId].text,
              choiceChips: questions[index]['questionTypeAnswer'],
              onSelected: (value) {
                setState(() {
                  /*qIdTextEditingController[questionId].text = questions[index]['questionTypeAnswer'][value];*/
                  qIdTextEditingController[questionId].text = value.toString();
                });
                print('value: $value');
              },
              wrapAlignment: WrapAlignment.spaceAround,
              padding: EdgeInsets.all(0.0),
            ),
          ),
        ],
      );
    } else if (questionType == 'Switch') {
      if (qIdTextEditingController[questionId].text.isEmpty)
        qIdTextEditingController[questionId].text = 'false';
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            // enabled: false,
            readOnly: true,
            /*validator: isRequired
                ? (value) {
                    if (value.isEmpty) {
                      return 'Mandatory field can\'t be empty';
                    }
                  }
                : null,*/
            showDecoration: false,
          ),
          SkywaSwitch(
            value: qIdTextEditingController[questionId].text == 'true'
                ? true
                : false,
            onChanged: (bool value) {
              setState(() {
                qIdTextEditingController[questionId].text = value.toString();
              });
            },
            title: questionText,
          ),
        ],
      );
    } else if (questionType == 'DropDown') {
      if (qIdTextEditingController[questionId].text.isEmpty)
        qIdTextEditingController[questionId].text =
            questions[index]['questionTypeAnswer'][0];
      return SkywaDropdownButton(
        items: questions[index]['questionTypeAnswer'],
        onChanged: (value) {
          setState(() {
            qIdTextEditingController[questionId].text = value.toString();
          });
        },
        selectedValue: qIdTextEditingController[questionId].text,
      );
    } else if (questionType == 'Slider') {
      double value;
      print('try catch');
      try {
        value = double.parse(qIdTextEditingController[questionId].text);
        print('try: $value');
      } catch (error) {
        value = double.parse(questions[index]['questionTypeAnswer'][0]) +
            (double.parse(questions[index]['questionTypeAnswer'][1]) -
                    double.parse(questions[index]['questionTypeAnswer'][0])) /
                2;
        print('catch: $value');
      }
      qIdTextEditingController[questionId].text = value.toString();
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            // enabled: false,
            readOnly: true,
            showDecoration: false,
            /*validator: isRequired
                ? (value) {
                    if (value.isEmpty) {
                      return 'Mandatory field can\'t be empty';
                    }
                  }
                : null,*/
          ),
          SkywaSlider(
            value: value,
            allowDivisions: true,
            onChanged: (double _value) {
              setState(() {
                value = _value;
                qIdTextEditingController[questionId].text = value.toString();
              });
              print(value);
            },
            minValue: double.parse(questions[index]['questionTypeAnswer'][0]),
            maxValue: double.parse(questions[index]['questionTypeAnswer'][1]),
          ),
        ],
      );
    } else if (questionType == 'Image') {
      File pickedImageFile;
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            // enabled: false,
            readOnly: true,
            showDecoration: false,
            validator: isRequired
                ? (value) {
                    if (value.isEmpty) {
                      return 'Mandatory field can\'t be empty';
                    }
                  }
                : null,
          ),
          if (isStringInvalid(text: qIdTextEditingController[questionId].text))
            SkywaElevatedButton.save(
              text: 'Pick Image',
              onTap: () {
                /// show modal bottom sheet for image picker
                SkywaBottomSheet(
                  context: context,
                  contentPadding: EdgeInsets.all(8.0),
                  content: Container(
                    // color: Colors.redAccent,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        /// camera
                        ListTile(
                          leading: Icon(Icons.camera_alt_rounded),
                          title: SkywaText(text: 'Camera'),
                          onTap: () async {
                            Navigator.pop(context);
                            pickImage(
                              imageSource: ImageSource.camera,
                              pickedImageFile: pickedImageFile,
                              questionId: questionId,
                            );
                          },
                        ),

                        /// gallery
                        ListTile(
                          leading: Icon(Icons.image_rounded),
                          title: SkywaText(text: 'Gallery'),
                          onTap: () async {
                            Navigator.pop(context);
                            pickImage(
                              imageSource: ImageSource.gallery,
                              pickedImageFile: pickedImageFile,
                              questionId: questionId,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ImageViewScreen(
                          imageUrl: qIdTextEditingController[questionId].text,
                        ),
                        type: PageTransitionType.rippleRightUp,
                      ),
                    );
                  },
                  child: SkywaCachedNetworkImage.clipRRect(
                    imageUrl: qIdTextEditingController[questionId].text,
                    height: 250.0,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10.0),
                SkywaElevatedButton.save(
                  text: 'Pick Image',
                  onTap: () {
                    /// show modal bottom sheet for image picker
                    SkywaBottomSheet(
                      context: context,
                      contentPadding: EdgeInsets.all(8.0),
                      content: Container(
                        // color: Colors.redAccent,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            /// camera
                            ListTile(
                              leading: Icon(Icons.camera_alt_rounded),
                              title: SkywaText(text: 'Camera'),
                              onTap: () async {
                                Navigator.pop(context);
                                pickImage(
                                  imageSource: ImageSource.camera,
                                  pickedImageFile: pickedImageFile,
                                  questionId: questionId,
                                );
                              },
                            ),

                            /// gallery
                            ListTile(
                              leading: Icon(Icons.image_rounded),
                              title: SkywaText(text: 'Gallery'),
                              onTap: () async {
                                Navigator.pop(context);
                                pickImage(
                                  imageSource: ImageSource.gallery,
                                  pickedImageFile: pickedImageFile,
                                  questionId: questionId,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      );
    } else if (questionType == 'File') {
      File pickedFile;
      String fileName = GlobalMethods.getFilenameFromUrl(
          url: qIdTextEditingController[questionId].text);
      Icon fileIcon = GlobalMethods.getFileIcon(fileName: fileName);
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            // enabled: false,
            readOnly: true,
            showDecoration: false,
            validator: isRequired
                ? (value) {
                    if (value.isEmpty) {
                      return 'Mandatory field can\'t be empty';
                    }
                  }
                : null,
          ),
          if (isStringInvalid(text: qIdTextEditingController[questionId].text))
            SkywaElevatedButton.save(
              text: 'Pick File',
              onTap: () {
                pickFile(pickedFile: pickedFile, questionId: questionId);
              },
            )
          else
            Column(
              children: [
                ListTile(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    GlobalMethods.downloadAndOpenFile(
                            url: qIdTextEditingController[questionId].text)
                        .then((value) {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    });
                    // print(qIdTextEditingController[questionId].text);
                    // print(qIdTextEditingController[questionId]
                    //     .text
                    //     .split('%2Ffiles%2F')[1]
                    //     .replaceAll('%20', ' ')
                    //     .split('?alt=media&token=')[0]);
                  },
                  leading: fileIcon,
                  title: SkywaText(
                    text: GlobalMethods.getFilenameFromUrl(
                        url: qIdTextEditingController[questionId].text),
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 10.0),
                SkywaElevatedButton.save(
                  text: 'Pick File',
                  onTap: () {
                    pickFile(pickedFile: pickedFile, questionId: questionId);
                  },
                )
              ],
            ),
        ],
      );
    }
    return Container();
  }

  /*Future<void> downloadAndOpenFile({@required String url}) async {
    String filename = url
        .split('%2Ffiles%2F')[1]
        .replaceAll('%20', ' ')
        .split('?alt=media&token=')[0];
    final directory = await getExternalStorageDirectory();
    File saveFileName = File('${directory.path}/$filename');
    setState(() {
      isLoading = true;
    });
    await Dio().download(
      url,
      saveFileName.path,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).then((value) async {
      setState(() {
        isLoading = false;
      });
      await OpenFile.open(saveFileName.path);
    });
  }*/

  Future<void> saveNote({@required BuildContext context}) async {
    bool allFieldsEmpty = true;

    /// don't let user to save note without filling any of the questions
    for (int i = 0; i < questionIds.length; i++) {
      if (!isStringInvalid(
          text: qIdTextEditingController[questionIds[i]].text)) {
        allFieldsEmpty = false;
      }
    }
    if (allFieldsEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Please enter at least one field',
      );
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      answerMap.clear();
      String noteId = GlobalMethods.generateUniqueId();
      String noteCreationDate = DateTime.now().toString();
      for (int i = 0; i < questionIds.length; i++) {
        answerMap.addEntries(
          [
            MapEntry(
              questionIds[i],
              qIdTextEditingController[questionIds[i]].text,
            ),
          ],
        );
      }
      print('answers: $answerMap');
      NoteModel noteToBeAdded = NoteModel(
        noteId: noteId,
        noteAnswer: answerMap,
        noteCreationDate: noteCreationDate,
      );
      dbNotesList.add(noteToBeAdded.toMap());
      folderReference.doc(folderModel.folderId).update({
        'notes': dbNotesList,
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        widget.fetchAllNotes();
      });
    }
  }

  Future<void> editNote({@required BuildContext context}) async {
    bool allFieldsEmpty = true;

    /// don't let user to save note without filling any of the questions
    for (int i = 0; i < questionIds.length; i++) {
      if (!isStringInvalid(
          text: qIdTextEditingController[questionIds[i]].text)) {
        allFieldsEmpty = false;
      }
    }
    if (allFieldsEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Please enter at least one field',
      );
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      for (int i = 0; i < questionIds.length; i++) {
        if (!dbNotesList[noteIndexToBeEdited]['noteAnswer']
            .containsKey(questionIds[i])) {
          dbNotesList[noteIndexToBeEdited]['noteAnswer'].addEntries([
            MapEntry(
              questionIds[i],
              qIdTextEditingController[questionIds[i]].text,
            )
          ]);
        } else {
          dbNotesList[noteIndexToBeEdited]['noteAnswer'].update(questionIds[i],
              (value) {
            return qIdTextEditingController[questionIds[i]].text;
          });
        }
      }
      print('683: ${dbNotesList[noteIndexToBeEdited]['noteAnswer']}');
      folderReference.doc(folderModel.folderId).update({
        'notes': dbNotesList,
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        widget.fetchAllNotes();
      });
    }
  }

  void populateFields() {
    for (var question in questions) {
      qIdTextEditingController[question['questionId']] = TextEditingController(
          text: noteModel.noteAnswer[question['questionId']]);
    }
  }

  void showPopAlertDialog({@required BuildContext context}) {
    SkywaAlertDialog.error(
      context: context,
      titleText: 'Warning',
      icon: Icon(
        Icons.warning_amber_rounded,
        color: ColorThemes.errorColor,
        size: 40.0,
      ),
      titlePadding: EdgeInsets.only(
        top: Device.screenHeight * 0.025,
        bottom: Device.screenHeight * 0.025,
        left: Device.screenWidth * 0.05,
        right: Device.screenWidth * 0.05,
      ),
      fontSize: 22.0,
      content: Container(
        // height: 100.0,
        width: Device.screenWidth,
        // color: Colors.teal,
        // constraints: BoxConstraints(
        //   minHeight: Device.screenHeight * 0.08,
        //   maxHeight: Device.screenHeight * 0.55,
        // ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkywaText(text: 'Do you want to discard?'),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkywaElevatedButton.info(
                    text: 'No',
                    onTap: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 10.0),
                SkywaElevatedButton.info(
                    text: 'Yes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage({
    @required ImageSource imageSource,
    @required File pickedImageFile,
    @required String questionId,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    String downloadUrl = '';
    try {
      final _pickedImage = await imagePicker.pickImage(
        source: imageSource,
        imageQuality: 99,
      );
      if (_pickedImage != null) {
        pickedImageFile = File(_pickedImage.path);
        setState(() {
          isLoading = true;
        });
        UploadTask snapshot = firebaseStorage
            .ref()
            .child(
                '${firebaseAuth.currentUser.uid}/images/${basename(pickedImageFile.path)}')
            .putFile(pickedImageFile);
        snapshot.snapshotEvents.listen((event) async {
          uploadProgress = ((event.bytesTransferred.toDouble() /
                      event.totalBytes.toDouble()) *
                  100)
              .roundToDouble();
          print('uploadProgress: $uploadProgress');
          if (uploadProgress == 100.0) {
            downloadUrl = await event.ref.getDownloadURL();
            print('downloadUrl: $downloadUrl');
            if (mounted) {
              setState(() {
                isLoading = false;
                qIdTextEditingController[questionId].text = downloadUrl;
              });
            }
          }
        });
      } else {
        print('No image selected');
      }
    } catch (error) {
      print('Error in image picker: $error');
      print('catch: No image picked');
    }
  }

  Future<void> pickFile({
    @required File pickedFile,
    @required String questionId,
  }) async {
    String downloadUrl = '';
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );
      if (result != null) {
        pickedFile = File(result.files.single.path);
        setState(() {
          isLoading = true;
        });
        UploadTask snapshot = firebaseStorage
            .ref()
            .child(
                '${firebaseAuth.currentUser.uid}/files/${basename(pickedFile.path)}')
            .putFile(pickedFile);
        snapshot.snapshotEvents.listen((event) async {
          uploadProgress = ((event.bytesTransferred.toDouble() /
                      event.totalBytes.toDouble()) *
                  100)
              .roundToDouble();
          print('uploadProgress: $uploadProgress');
          if (uploadProgress == 100.0) {
            downloadUrl = await event.ref.getDownloadURL();
            print('downloadUrl: $downloadUrl');
            setState(() {
              isLoading = false;
              qIdTextEditingController[questionId].text = downloadUrl;
            });
          }
        });
      } else {
        print('No files selected');
      }
    } catch (error) {
      print('Error in file picker: $error');
      print('catch: No file picked');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    questions = folderModel.questions;
    questionIds = [];
    questionTexts = [];
    answerMap = {};
    for (var question in questions) {
      qIdTextEditingController.addEntries([
        MapEntry(question['questionId'], TextEditingController()),
      ]);
      questionIds.add(question['questionId']);
      questionTexts.add(question['questionText']);
    }
    dbNotesList = folderModel.notes;
    noteModel = widget.noteModel;
    noteIndexToBeEdited = widget.index;
    if (noteModel != null) populateFields();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        qIdTextEditingController.entries.forEach((element) {
          if (element.value.text.isNotEmpty) allowPop = false;
        });
        if (!allowPop)
          showPopAlertDialog(context: context);
        else
          Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SkywaAppBar(
            appbarText: 'Add Notes',
            backIconButton: IconButton(
              onPressed: () {
                qIdTextEditingController.entries.forEach((element) {
                  if (element.value.text.isNotEmpty) allowPop = false;
                });
                if (!allowPop)
                  showPopAlertDialog(context: context);
                else
                  Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            actions: [
              if (qIdTextEditingController.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      qIdTextEditingController;
                    });
                    if (noteModel == null)
                      saveNote(context: context);
                    else
                      editNote(context: context);
                  },
                  icon: SkywaAutoSizeText(
                    text: 'Save',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Device.screenWidth * 0.04,
                  vertical: 20.0,
                ),
                itemCount: questions.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// if question type not switch then only show question text
                      if (questions[index]['questionType'] != 'Switch')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: questions[index]['questionText'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (questions[index]['isRequired'])
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: Offset(0.0, -2.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: '  *',
                                            style: TextStyle(
                                                color: ColorThemes.errorColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        ),
                      buildNotesAnswerWidget(context: context, index: index),
                      const SizedBox(height: 20.0),
                    ],
                  );
                },
              ),
            ),
            if (isLoading) GlassMorphicLoader(),
          ],
        ),
      ),
    );
  }
}
