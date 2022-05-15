import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_alert_dialog.dart';
import 'package:diary_app/framework/widgets/skywa_appbar.dart';
import 'package:diary_app/framework/widgets/skywa_bottom_sheet.dart';
import 'package:diary_app/framework/widgets/skywa_button.dart';
import 'package:diary_app/framework/widgets/skywa_floating_action_button.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/screens/add_question_screen.dart';
import 'package:diary_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import '../framework/widgets/skywa_radio_group.dart';
import '../services/color_themes.dart';
import '../widgets/question_row_widget.dart';
import 'view_all_folders_screen.dart';

class ViewAllQuestionsScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function refreshViewAllFolders;

  const ViewAllQuestionsScreen({
    Key key,
    @required this.folderModel,
    @required this.refreshViewAllFolders,
  }) : super(key: key);

  @override
  State<ViewAllQuestionsScreen> createState() => _ViewAllQuestionsScreenState();
}

class _ViewAllQuestionsScreenState extends State<ViewAllQuestionsScreen> {
  FolderModel folderModel;
  bool isLoading = false;

  Widget questionShimmer() {
    return ListView.builder(
      itemCount: Device.screenHeight ~/ 80.0,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: Device.screenWidth,
          height: 80.0,
          margin: EdgeInsets.symmetric(
            horizontal: Device.screenWidth * 0.03,
            vertical: 10.0,
          ),
          child: Shimmer.fromColors(
            highlightColor: Colors.grey,
            baseColor: Colors.white38,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteQuestion({@required QuestionModel questionModel}) async {
    setState(() {
      isLoading = true;
    });
    folderModel.questions.removeWhere(
      (_question) => questionModel.questionId == _question['questionId'],
    );
    folderReference
        .doc(folderModel.folderId)
        .update({'questions': folderModel.questions}).then((value) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        widget.refreshViewAllFolders;
      });
      // fetchAllQuestions();
    });
  }

  Future<void> fetchAllQuestions() async {
    print('fetchAllQuestions called');
    setState(() {
      folderModel.questions;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    // questions = folderModel.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(
          appbarText: 'All Questions',
        ),
      ),
      body: isLoading
          ? questionShimmer()
          : folderModel.questions.isNotEmpty
              ? Container(
                  height: Device.screenHeight,
                  width: Device.screenWidth,
                  child: Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: folderModel.questions.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> _question =
                              folderModel.questions[index];
                          QuestionModel questionModel = QuestionModel(
                            questionId: _question['questionId'],
                            questionText: _question['questionText'],
                            isRequired: _question['isRequired'],
                            questionCreationDate:
                                _question['questionCreationDate'],
                            questionType: _question['questionType'],
                            questionTypeAnswer: _question['questionTypeAnswer'],
                          );
                          return Slidable(
                            direction: Axis.horizontal,
                            actionPane: const SlidableStrechActionPane(),
                            actionExtentRatio: 0.20,
                            secondaryActions: [
                              IconButton(
                                onPressed: () {
                                  SkywaAlertDialog.error(
                                    context: context,
                                    titleText: 'Delete Question',
                                    titlePadding: const EdgeInsets.all(15.0),
                                    icon: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.white,
                                    ),
                                    content: Container(
                                      width: Device.screenWidth,
                                      height: 130.0,
                                      padding: const EdgeInsets.all(20.0),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          SkywaText(
                                            text:
                                                'Do you want to delete this question?',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SkywaButton.save(
                                                text: 'Cancel',
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              const SizedBox(width: 20.0),
                                              SkywaButton.delete(
                                                text: 'Delete',
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  deleteQuestion(
                                                      questionModel:
                                                          questionModel);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: ColorThemes.errorColor,
                                ),
                              ),
                            ],
                            child:
                                QuestionRowWidget(questionModel: questionModel),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: SkywaFloatingActionButton(
                          iconData: Icons.add_rounded,
                          onTap: () {
                            // showAlertDialog();
                            Navigator.push(
                              context,
                              PageTransition(
                                child: AddQuestionScreen(
                                  folderModel: folderModel,
                                  fetchAllQuestions: fetchAllQuestions,
                                ),
                                type: PageTransitionType.rippleRightUp,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: Device.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkywaFloatingActionButton(
                        iconData: Icons.add_rounded,
                        onTap: () {
                          // showAlertDialog();
                          Navigator.push(
                            context,
                            PageTransition(
                              child: AddQuestionScreen(
                                folderModel: folderModel,
                                fetchAllQuestions: fetchAllQuestions,
                              ),
                              type: PageTransitionType.rippleRightUp,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
                      SkywaText(
                        text: 'Add New Question',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
      /*body: Container(
        height: Device.screenHeight,
        child: StreamBuilder(
            stream: _questionReference
                .orderBy('questionCreationDate', descending: false)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Stack(
                  children: [
                    Container(),

                    /// loading
                    Positioned(
                      top: 0.0,
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: questionShimmer(),
                    ),
                  ],
                );
              }
              _questions = snapshot.data.docs.map((question) {
                return QuestionModel.fromJson(question);
              }).toList();
              return _questions.isNotEmpty
                  ? Stack(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            QuestionModel questionModel = _questions[index];
                            return Slidable(
                              direction: Axis.horizontal,
                              actionPane: const SlidableStrechActionPane(),
                              actionExtentRatio: 0.20,
                              secondaryActions: [
                                IconButton(
                                  onPressed: () {
                                    SkywaAlertDialog.error(
                                      context: context,
                                      titleText: 'Delete Question',
                                      titlePadding: const EdgeInsets.all(15.0),
                                      icon: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.white,
                                      ),
                                      content: Container(
                                        width: Device.screenWidth,
                                        height: 130.0,
                                        padding: const EdgeInsets.all(20.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            SkywaText(
                                              text:
                                                  'Do you want to delete this question?',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            const SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SkywaButton.save(
                                                  text: 'Cancel',
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                const SizedBox(width: 20.0),
                                                SkywaButton.delete(
                                                  text: 'Delete',
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    deleteQuestion(
                                                        questionModel:
                                                            questionModel);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    color: ColorThemes.errorColor,
                                  ),
                                ),
                              ],
                              child: QuestionRowWidget(
                                  questionModel: questionModel),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: SkywaFloatingActionButton(
                            iconData: Icons.add_rounded,
                            onTap: () {
                              // showAlertDialog();
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: AddQuestionScreen(
                                      folderModel: folderModel),
                                  type: PageTransitionType.rippleRightUp,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: Device.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkywaFloatingActionButton(
                            iconData: Icons.add_rounded,
                            onTap: () {
                              // showAlertDialog();
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: AddQuestionScreen(
                                      folderModel: folderModel),
                                  type: PageTransitionType.rippleRightUp,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          SkywaText(
                            text: 'Add New Question',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
            }),
      ),*/
    );
  }
}
