import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_appbar.dart';
import 'package:diary_app/framework/widgets/skywa_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../framework/widgets/skywa_bottom_sheet.dart';
import '../framework/widgets/skywa_button.dart';
import '../framework/widgets/skywa_radio_group.dart';
import '../framework/widgets/skywa_text.dart';
import '../framework/widgets/skywa_textformfield.dart';
import '../models/folder_model.dart';
import '../models/question_model.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';

class AddQuestionScreen extends StatefulWidget {
  final FolderModel folderModel;
  const AddQuestionScreen({
    Key key,
    @required this.folderModel,
  }) : super(key: key);

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  FolderModel folderModel;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _questionTypeController = TextEditingController();
  final TextEditingController _questionTypeAnswerController =
      TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference _questionReference;
  bool isRequired = false;

  List<String> availableQuestionTypes = [
    'Text',
    'Name',
    'Email',
    'Phone',
    'Url',
    'Multiline',
    'Date',
    'Address',
    'Chip',
    'Switch',
    'DropDown',
    'Slider',
  ];
  // List<String> genders = ['Male', 'Female', 'Others'];
  // String selectedChoice = '';

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
      /// url
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[5]) {
      /// multiline
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[6]) {
      /// date
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[7]) {
      /// address
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[8]) {
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
        maxLines: null,
        labelText: 'Answers',
        hintText: 'Options for Chip separated by new line',
      );
    } else if (_questionTypeController.text == availableQuestionTypes[9]) {
      /// switch
      return Container();
    } else if (_questionTypeController.text == availableQuestionTypes[10]) {
      /// dropdown
      return SkywaTextFormField.multiline(
        textEditingController: _questionTypeAnswerController,
        maxLines: null,
        labelText: 'Answers',
        hintText: 'Options for Dropdown separated by new line',
      );
    } else if (_questionTypeController.text == availableQuestionTypes[11]) {
      /// slider
      return SkywaTextFormField.multiline(
        textEditingController: _questionTypeAnswerController,
        maxLines: null,
        labelText: 'Answers',
        hintText: 'Min & Max values for Slider separated by new line',
      );
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
        /// everything is valid
        String questionId = GlobalMethods.generateUniqueId();
        String questionCreationDate = DateTime.now().toString();
        QuestionModel questionModel = QuestionModel(
          questionId: questionId,
          questionText: _questionController.text,
          isRequired: isRequired,
          questionCreationDate: questionCreationDate,
          questionType: _questionTypeController.text,
          questionTypeAnswer: _questionTypeAnswerController.text,
        );
        print(questionModel);
        Navigator.pop(context);
        await _questionReference
            .doc(questionId)
            .set(questionModel.toMap())
            .then((value) {
          print('Question added: $questionModel');
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    _questionReference = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('folders')
        .doc(folderModel.folderId)
        .collection('questions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(
          appbarText: 'Add Question',
          actions: [
            if (_questionController.text.isNotEmpty &&
                _questionTypeController.text.isNotEmpty)
              SkywaButton.save(
                  text: 'Save',
                  onTap: () {
                    setState(() {
                      _questionController;
                    });
                    saveQuestion();
                  }),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
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
                color: Colors.transparent,
                content: SkywaRadioGroup(
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
    );
  }
}