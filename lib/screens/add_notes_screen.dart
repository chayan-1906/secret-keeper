import 'package:diary_app/framework/widgets/skywa_choice_chip_group.dart';
import 'package:diary_app/framework/widgets/skywa_date_time_picker.dart';
import 'package:diary_app/framework/widgets/skywa_dropdown_button.dart';
import 'package:diary_app/framework/widgets/skywa_slider.dart';
import 'package:diary_app/framework/widgets/skywa_switch.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/models/note_model.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../framework/widgets/skywa_appbar.dart';
import '../framework/widgets/skywa_auto_size_text.dart';
import '../framework/widgets/skywa_button.dart';
import '../models/folder_model.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';

class AddNotesScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function fetchAllNotes;

  const AddNotesScreen({
    Key key,
    @required this.folderModel,
    @required this.fetchAllNotes,
  }) : super(key: key);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  FolderModel folderModel;
  List<dynamic> questions;
  List<String> questionIds;
  List<String> questionTexts;
  // List<String> answers;
  Map<String, dynamic> answers;
  List<NoteModel> notes;
  Map<String, TextEditingController> qIdTextEditingController = {};
  List<dynamic> dbNotesList = [];
  bool isLoading = false;

  Widget buildNotesAnswerWidget({@required int index}) {
    String questionType = questions[index]['questionType'];
    String questionText = questions[index]['questionText'];
    String questionId = questions[index]['questionId'];
    if (questionType == 'Text') {
      return SkywaTextFormField.text(
        textEditingController: qIdTextEditingController[questionId],
        labelText: questionText,
        hintText: 'Enter $questionText...',
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
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            enabled: false,
            readOnly: true,
            showDecoration: false,
          ),
          Container(
            width: Device.screenWidth,
            // color: Colors.redAccent,
            child: SkywaChoiceChipGroup(
              selectedValue: isStringInvalid(
                      text: qIdTextEditingController[questionId].text)
                  ? 0
                  : int.parse(qIdTextEditingController[questionId].text),
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
      return Stack(
        children: [
          SkywaTextFormField.none(
            textEditingController: qIdTextEditingController[questionId],
            labelText: '',
            hintText: '',
            contentPadding: EdgeInsets.all(0.0),
            enabled: false,
            readOnly: true,
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
            enabled: false,
            readOnly: true,
            showDecoration: false,
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
    }
    return Container();
  }

  Future<void> saveNote() async {
    setState(() {
      isLoading = true;
    });
    String noteId = GlobalMethods.generateUniqueId();
    String noteCreationDate = DateTime.now().toString();
    for (int i = 0; i < questionIds.length; i++) {
      answers.addEntries(
        [
          MapEntry(
            questionTexts[i],
            qIdTextEditingController[questionIds[i]].text,
          ),
        ],
      );
    }
    print(answers);
    NoteModel noteToBeAdded = NoteModel(
      noteId: noteId,
      noteAnswer: answers,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    questions = folderModel.questions;
    questionIds = [];
    questionTexts = [];
    answers = {};
    for (var question in questions) {
      qIdTextEditingController.addEntries([
        MapEntry(question['questionId'], TextEditingController()),
      ]);
      questionIds.add(question['questionId']);
      questionTexts.add(question['questionText']);
    }
    dbNotesList = folderModel.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(
          appbarText: 'Add Notes',
          actions: [
            // if (_questionController.text.isNotEmpty && _questionTypeController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  qIdTextEditingController;
                });
                // TODO: FOR CHOICE CHIP qIdTextEditingController[questionId].text IS ASSIGNED TO CORRESPONDING INDEX VALUE. IF REQUIRED, GET THE STRING VALUE FROM THE questions[index]['questionTypeAnswer'][SELECTED INDEX]
                /*for (var question in questions) {
                    print(
                        qIdTextEditingController[question['questionId']].text);
                  }*/
                saveNote();
              },
              // icon: Icon(Icons.check_rounded),
              icon: SkywaAutoSizeText(text: 'Save', color: Colors.white),
            ),
          ],
        ),
      ),
      body: ListView.builder(
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
              if (questions[index]['questionType'] != 'Switch')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SkywaText(
                        text:
                            '${questions[index]['questionText']} ${questions[index]['isRequired']}'),
                    const SizedBox(height: 15.0),
                  ],
                ),
              buildNotesAnswerWidget(index: index),
              const SizedBox(height: 20.0),
            ],
          );
        },
      ),
    );
  }
}
