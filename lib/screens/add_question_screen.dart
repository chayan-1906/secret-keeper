import 'package:diary_app/framework/widgets/skywa_alert_dialog.dart';
import 'package:diary_app/framework/widgets/skywa_appbar.dart';
import 'package:diary_app/framework/widgets/skywa_auto_size_text.dart';
import 'package:diary_app/framework/widgets/skywa_outlined_button.dart';
import 'package:diary_app/framework/widgets/skywa_snackbar.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../framework/widgets/skywa_bottom_sheet.dart';
import '../framework/widgets/skywa_elevated_button.dart';
import '../framework/widgets/skywa_radio_group.dart';
import '../framework/widgets/skywa_text.dart';
import '../framework/widgets/skywa_textformfield.dart';
import '../models/folder_model.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';

class AddQuestionScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function fetchAllQuestions;
  final QuestionModel questionModel;

  const AddQuestionScreen({
    Key key,
    @required this.folderModel,
    @required this.fetchAllQuestions,
    this.questionModel,
  }) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  FolderModel folderModel;
  QuestionModel questionModel;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _questionTypeController = TextEditingController();
  TextEditingController _questionTypeAnswerController = TextEditingController();
  List<dynamic> questions = [];
  bool isRequired = false;
  List<String> availableQuestionTypes = [
    'Text', // 0
    'Name', // 1
    'Email', // 2
    'Phone', // 3
    'Number', // 4
    'Url', // 5
    'Multiline', // 6
    'Date', // 7
    'Address', // 8
    'Chip', // 9
    'Switch', // 10
    'DropDown', // 11
    'Slider', // 12
    'Image', // 13
    'File', // 14
  ];
  bool isLoading = false;

  Widget buildQuestionTypeAnswerWidget() {
    print(_questionTypeController.text);
    if (_questionTypeController.text == availableQuestionTypes[0]) {
      /// text
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[1]) {
      /// name
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[2]) {
      /// email
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[3]) {
      /// phone
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[4]) {
      /// number
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[5]) {
      /// url
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[6]) {
      /// multiline
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[7]) {
      /// date
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[8]) {
      /// address
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[9]) {
      /// chip
      /*return Wrap(
        spacing: 5.0,
        runSpacing: 3.0,
        alignment: WrapAlignment.spaceAround,
        children: List.generate(
          genders.length,
          (index) {
            return InputChip(
              label: SkywaText(text: genders[index], color: Colors.white),
              selected: selectedChoice == genders[index],
              elevation: 8.0,
              pressElevation: 20.0,
              checkmarkColor: Colors.white,
              shadowColor: CupertinoColors.systemGrey3,
              backgroundColor: ColorThemes.accentColor,
              selectedColor: ColorThemes.primaryDarkColor,
              onSelected: (bool selected) {
                setState(() {
                  selectedChoice = genders[index];
                });
                print(genders[index]);
              },
            );
          },
        ),
      );*/
      return SkywaTextFormField.multiline(
        textEditingController: _questionTypeAnswerController,
        labelText: 'Answers',
        hintText:
            'Options for Chip separated by new line. Spaces are not allowed.',
      );
    } else if (_questionTypeController.text == availableQuestionTypes[10]) {
      /// switch
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[11]) {
      /// dropdown
      return SkywaTextFormField.multiline(
        textEditingController: _questionTypeAnswerController,
        labelText: 'Answers',
        hintText:
            'Options for Dropdown separated by new line. Spaces are not allowed.',
      );
    } else if (_questionTypeController.text == availableQuestionTypes[12]) {
      /// slider
      return SkywaTextFormField.multiline(
        textEditingController: _questionTypeAnswerController,
        labelText: 'Answers',
        hintText: 'Min & Max values for Slider separated by new line',
      );
    } else if (_questionTypeController.text == availableQuestionTypes[13]) {
      /// image
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[14]) {
      /// file
      return Container();
    }
    return Container();
  }

  Future<void> saveQuestion() async {
    if (_questionController.text.isEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Question is required',
      );
      return;
    } else if (_questionTypeController.text.isEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Question Type is required',
      );
      return;
    } else {
      if ((_questionTypeController.text == 'Chip' ||
              _questionTypeController.text == 'DropDown' ||
              _questionTypeController.text == 'Slider') &&
          _questionTypeAnswerController.text.isEmpty) {
        SkywaSnackBar.error(
          context: context,
          snackbarText: 'Answers field can\'t be empty',
        );
        return;
      } else {
        List<String> validAnswers = [];
        validAnswers = _questionTypeAnswerController.text.isNotEmpty
            ? _questionTypeAnswerController.text.split('\n').toList()
            : [];
        if ((_questionTypeController.text == 'Chip' ||
                _questionTypeController.text == 'DropDown' ||
                _questionTypeController.text == 'Slider') &&
            validAnswers.length < 2) {
          if (_questionTypeController.text == 'Chip' ||
              _questionTypeController.text == 'DropDown') {
            SkywaSnackBar.error(
              context: context,
              snackbarText: 'Minimum two options are required',
            );
          } else if (_questionTypeController.text == 'Slider') {
            SkywaSnackBar.error(
              context: context,
              snackbarText: 'Minimum & Maximum both values are required',
            );
          }
          return;
        }

        /// everything is valid
        setState(() {
          isLoading = true;
        });
        String questionId = GlobalMethods.generateUniqueId();
        String questionCreationDate = DateTime.now().toString();
        /*QuestionModel questionModel = QuestionModel(
          questionId: questionId,
          questionText: _questionController.text,
          isRequired: isRequired,
          questionCreationDate: questionCreationDate,
          questionType: _questionTypeController.text,
          questionTypeAnswer: _questionTypeAnswerController.text,
        );*/
        Map<String, dynamic> questionToBeAdded = {
          'questionId': questionId,
          'questionText': _questionController.text,
          'isRequired': isRequired,
          'questionCreationDate': questionCreationDate,
          'questionType': _questionTypeController.text,
          'questionTypeAnswer': validAnswers,
        };
        setState(() {
          questions.add(questionToBeAdded);
        });
        folderReference
            .doc(folderModel.folderId)
            .update({'questions': questions}).then((value) {
          print('Question added: $questionToBeAdded');
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          setState(() {
            widget.fetchAllQuestions();
          });
        });
      }
    }
  }

  Future<void> editQuestion() async {
    if (_questionController.text.isEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Question is required',
      );
      return;
    } else if (_questionTypeController.text.isEmpty) {
      SkywaSnackBar.error(
        context: context,
        snackbarText: 'Question Type is required',
      );
      return;
    } else {
      if ((_questionTypeController.text == 'Chip' ||
              _questionTypeController.text == 'DropDown' ||
              _questionTypeController.text == 'Slider') &&
          _questionTypeAnswerController.text.isEmpty) {
        SkywaSnackBar.error(
          context: context,
          snackbarText: 'Answers field can\'t be empty',
        );
        return;
      } else {
        List<String> validAnswers = [];
        validAnswers = _questionTypeAnswerController.text.isNotEmpty
            ? _questionTypeAnswerController.text.split('\n').toList()
            : [];
        if ((_questionTypeController.text == 'Chip' ||
                _questionTypeController.text == 'DropDown' ||
                _questionTypeController.text == 'Slider') &&
            validAnswers.length < 2) {
          if (_questionTypeController.text == 'Chip' ||
              _questionTypeController.text == 'DropDown') {
            SkywaSnackBar.error(
              context: context,
              snackbarText: 'Minimum two options are required',
            );
          } else if (_questionTypeController.text == 'Slider') {
            SkywaSnackBar.error(
              context: context,
              snackbarText: 'Minimum & Maximum both values are required',
            );
          }
          return;
        }

        /// everything is valid
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> questionToBeEdited = {
          'questionId': questionModel.questionId,
          'questionText': _questionController.text,
          'isRequired': isRequired,
          'questionCreationDate': questionModel.questionCreationDate,
          'questionType': _questionTypeController.text,
          'questionTypeAnswer': validAnswers,
        };
        for (var ques in questions) {
          if (ques['questionId'] == questionModel.questionId) {
            setState(() {
              questions[questions.indexOf(ques)] = questionToBeEdited;
            });
          }
        }
        folderReference
            .doc(folderModel.folderId)
            .update({'questions': questions}).then((value) {
          print('Question edited: $questionToBeEdited');
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          setState(() {
            widget.fetchAllQuestions();
          });
        });
      }
    }
  }

  void showPopAlertDialog() {
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
        // constraints: BoxConstraints(
        //   minHeight: Device.screenHeight * 0.08,
        //   maxHeight: Device.screenHeight * 0.55,
        // ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkywaText(
              text: 'Do you want to discard?',
              color: Colors.black.withOpacity(0.60),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*/// no
                SkywaTextButton(
                  text: 'No',
                  buttonColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 10.0),

                /// yes
                SkywaTextButton(
                  text: 'Yes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),*/
                SkywaOutlinedButton(
                    text: 'NO',
                    onTap: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 10.0),
                SkywaElevatedButton.save(
                    text: 'YES',
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

  void populateFields() {
    _questionController =
        TextEditingController(text: questionModel.questionText);
    isRequired = questionModel.isRequired;
    _questionTypeController =
        TextEditingController(text: questionModel.questionType);
    String answers = '';
    for (int i = 0; i < questionModel.questionTypeAnswer.length; i++) {
      print('quesTypeAns: ${questionModel.questionTypeAnswer[i]}');
      answers = answers +
          questionModel.questionTypeAnswer[i] +
          (i == questionModel.questionTypeAnswer.length - 1 ? '' : '\n');
      _questionTypeAnswerController = TextEditingController(text: answers);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    questions = folderModel.questions;
    questionModel = widget.questionModel;
    if (questionModel != null) populateFields();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_questionController.text.isNotEmpty ||
            isRequired ||
            _questionTypeController.text.isNotEmpty ||
            _questionTypeAnswerController.text.isNotEmpty)
          showPopAlertDialog();
        else
          Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SkywaAppBar(
            appbarText: 'Add Question',
            backIconButton: IconButton(
              onPressed: () {
                if (_questionController.text.isNotEmpty ||
                    isRequired ||
                    _questionTypeController.text.isNotEmpty ||
                    _questionTypeAnswerController.text.isNotEmpty)
                  showPopAlertDialog();
                else
                  Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            ),
            actions: [
              if (_questionController.text.isNotEmpty &&
                  _questionTypeController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _questionController;
                    });
                    if (questionModel == null) // when adding question
                      saveQuestion();
                    else // when editing question
                      editQuestion();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8.0),
                    child: SkywaAutoSizeText(
                      text: 'Save',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        body: isLoading
            ? const LoadingWidget()
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: Device.screenWidth * 0.04,
                  vertical: 20.0,
                ),
                children: [
                  /// multiline textformfield
                  SkywaTextFormField.multiline(
                    textEditingController: _questionController,
                    labelText: 'Question',
                    hintText: 'Enter your question',
                    onChanged: (value) {
                      setState(() {
                        _questionController;
                      });
                    },
                    suffixIcon: _questionController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _questionController.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: ColorThemes.primaryColor,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 10.0),

                  /// required switch
                  SwitchListTile(
                    title: SkywaText(text: 'Required'),
                    value: isRequired,
                    onChanged: (value) {
                      setState(() {
                        isRequired = value;
                      });
                    },
                    activeColor: ColorThemes.primaryColor,
                  ),
                  const SizedBox(height: 10.0),

                  /// question type textformfield & bottom sheet
                  GestureDetector(
                    onTap: () {
                      SkywaBottomSheet(
                        context: context,
                        // color: Colors.transparent,
                        content: ListView(
                          shrinkWrap: true,
                          children: [
                            SkywaRadioGroup(
                              texts: availableQuestionTypes,
                              selectedValue: _questionTypeController.text,
                              backgroundColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  _questionTypeController.text = value;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: SkywaTextFormField.none(
                      textEditingController: _questionTypeController,
                      labelText: 'Question Type',
                      hintText: 'Choose question type...',
                      enabled: false,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  buildQuestionTypeAnswerWidget(),
                ],
              ),
      ),
    );
  }
}
