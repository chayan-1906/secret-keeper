import 'package:diary_app/framework/widgets/skywa_auto_size_text.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/generated/assets.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/screens/add_question_screen.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/services/color_themes.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';

import '../framework/widgets/skywa_alert_dialog.dart';
import '../framework/widgets/skywa_appbar.dart';
import '../framework/widgets/skywa_button.dart';
import '../framework/widgets/skywa_floating_action_button.dart';
import '../models/note_model.dart';
import '../models/question_model.dart';
import '../services/search.dart';
import '../widgets/note_row_widget.dart';
import '../widgets/question_row_widget.dart';
import 'add_notes_screen.dart';

class NotesQuestionTabBarScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function refreshViewAllFolders;

  const NotesQuestionTabBarScreen({
    Key key,
    @required this.folderModel,
    @required this.refreshViewAllFolders,
  }) : super(key: key);

  @override
  State<NotesQuestionTabBarScreen> createState() =>
      _NotesQuestionTabBarScreenState();
}

class _NotesQuestionTabBarScreenState extends State<NotesQuestionTabBarScreen>
    with SingleTickerProviderStateMixin {
  FolderModel folderModel;
  TabController tabController;
  TextEditingController _searchController = TextEditingController();
  bool isNoteSearching = false;
  bool isQuestionSearching = false;
  List searchedNotes = [];
  List searchedQuestions = [];
  bool isLoading = false;
  String searchHint;

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

  Future<void> fetchAllNotes() async {
    print('fetchAllNotes called');
    setState(() {
      folderModel.notes;
    });
  }

  Future<void> fetchAllQuestions() async {
    print('fetchAllQuestions called');
    setState(() {
      folderModel.questions;
    });
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
      /// once after deleting a question, delete that question from all notes/responses
      folderModel.notes.forEach((note) {
        note['noteAnswer'].remove(questionModel.questionId);
      });
      folderReference
          .doc(folderModel.folderId)
          .update({'notes': folderModel.notes}).then((value) {
        setState(() {
          widget.refreshViewAllFolders;
        });
      });
    });
  }

  Future<void> editQuestion({@required QuestionModel questionModel}) async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rippleRightUp,
        child: AddQuestionScreen(
          folderModel: folderModel,
          fetchAllQuestions: fetchAllQuestions,
          questionModel: questionModel,
        ),
      ),
    ).then((value) {
      widget.refreshViewAllFolders();
      fetchAllQuestions();
    });
  }

  Future<void> deleteNote({@required NoteModel noteModel}) async {
    setState(() {
      isLoading = true;
    });
    folderModel.notes.removeWhere(
      (_note) => noteModel.noteId == _note['noteId'],
    );
    folderReference
        .doc(folderModel.folderId)
        .update({'notes': folderModel.notes}).then((value) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        widget.refreshViewAllFolders;
      });
      fetchAllNotes();
    });
  }

  Future<void> editNote(
      {@required NoteModel noteModel, @required int index}) async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rippleRightUp,
        child: AddNotesScreen(
          folderModel: folderModel,
          fetchAllNotes: fetchAllNotes,
          noteModel: noteModel,
          index: index,
        ),
      ),
    ).then((value) {
      widget.refreshViewAllFolders();
      fetchAllNotes();
    });
  }

  Widget buildNotesList() {
    return isLoading
        ? questionShimmer()
        : ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: isNoteSearching
                ? searchedNotes.length
                : folderModel.notes.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> _note = {};
              if (isNoteSearching) {
                _note = searchedNotes[index];
              } else {
                _note = folderModel.notes[index];
              }
              // print('82: ${_note}');
              NoteModel noteModel = NoteModel(
                noteId: _note['noteId'],
                noteAnswer: _note['noteAnswer'],
                noteCreationDate: _note['noteCreationDate'],
              );
              // print('45: ${noteModel.noteAnswer}');
              List answerTexts = [];
              for (MapEntry noteAnswer in noteModel.noteAnswer.entries) {
                if (!isStringInvalid(text: noteAnswer.value))
                  answerTexts.add(noteAnswer.value);
              }
              // print('answerTexts: $answerTexts');
              return Slidable(
                key: ValueKey(0),
                direction: Axis.horizontal,
                closeOnScroll: true,
                actionPane: const SlidableBehindActionPane(),
                actionExtentRatio: 0.20,
                secondaryActions: [
                  /// delete question
                  IconButton(
                    onPressed: () {
                      SkywaAlertDialog.error(
                        context: context,
                        titleText: 'Delete Question',
                        titlePadding: const EdgeInsets.all(15.0),
                        icon: const Icon(
                          Icons.warning_amber_rounded,
                          color: ColorThemes.errorColor,
                          size: 45.0,
                        ),
                        content: Container(
                          width: Device.screenWidth,
                          // height: 150.0,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkywaText(
                                text: 'Do you want to delete this response?',
                                fontSize: 18.0,
                                maxLines: 2,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                      deleteNote(noteModel: noteModel);
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
                child: answerTexts.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          /// edit question
                          editNote(noteModel: noteModel, index: index);
                        },
                        child: NoteRowWidget(
                          folderModel: folderModel,
                          noteModel: noteModel,
                          expanded: false,
                        ),
                      )
                    :

                    /// empty note
                    Container(
                        margin: EdgeInsets.all(16.0),
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
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SkywaText(
                            text: 'Empty Note',
                            fontWeight: FontWeight.w600,
                            fontSize: 25.0,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
              );
            },
          );
  }

  Widget buildQuestionsList() {
    return isLoading
        ? questionShimmer()
        : isQuestionSearching &&
                _searchController.text.isNotEmpty &&
                searchedQuestions.isEmpty
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.imagesNotFound),
                    SizedBox(height: 30.0),
                    SkywaText(
                      text: 'We\'re sorry',
                      fontWeight: FontWeight.bold,
                      fontSize: 27.0,
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Device.screenWidth * 0.09),
                      child: SkywaText(
                        text:
                            'We\'ve searched all the questions, but did not match any document',
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        color: Colors.grey,
                        maxLines: 4,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: isQuestionSearching
                    ? searchedQuestions.length
                    : folderModel.questions.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> _question = {};
                  folderModel.questions[index];
                  if (isQuestionSearching) {
                    _question = searchedQuestions[index];
                  } else {
                    _question = folderModel.questions[index];
                  }
                  QuestionModel questionModel = QuestionModel(
                    questionId: _question['questionId'],
                    questionText: _question['questionText'],
                    isRequired: _question['isRequired'],
                    questionCreationDate: _question['questionCreationDate'],
                    questionType: _question['questionType'],
                    questionTypeAnswer: _question['questionTypeAnswer'],
                  );
                  return Slidable(
                    direction: Axis.horizontal,
                    actionPane: const SlidableStrechActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: [
                      /// delete question
                      IconButton(
                        onPressed: () {
                          SkywaAlertDialog.error(
                            context: context,
                            titleText: 'Delete Question',
                            titlePadding: const EdgeInsets.all(15.0),
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: ColorThemes.errorColor,
                              size: 45.0,
                            ),
                            content: Container(
                              width: Device.screenWidth,
                              // height: 200.0,
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SkywaAutoSizeText(
                                    text:
                                        'Do you want to delete this question?\nThis question will be deleted from all your responses.',
                                    // fontSize: 18.0,
                                    maxLines: 4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                              questionModel: questionModel);
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
                    child: GestureDetector(
                        onTap: () {
                          /// edit question
                          editQuestion(questionModel: questionModel);
                        },
                        child: QuestionRowWidget(questionModel: questionModel)),
                  );
                },
              );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (tabController.index == 0) {
        searchHint = 'Search response...';
      } else if (tabController.index == 1) {
        searchHint = 'Search question...';
      }
    });

    return WillPopScope(
      onWillPop: () {
        if (isNoteSearching || isQuestionSearching) {
          setState(() {
            isNoteSearching = false;
            isQuestionSearching = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: !isNoteSearching && !isQuestionSearching
              ? SkywaAppBar(
                  appbarText: folderModel.folderName,
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (tabController.index == 0)
                            isNoteSearching = true;
                          else if (tabController.index == 1)
                            isQuestionSearching = true;
                          /*folderModel.questions.forEach((question) {
                              print('question: ${question.toString()}');
                              stringsToBeEliminated.add(question.toString());
                            });
                            folderModel.notes.forEach((note) {
                              if (stringsToBeEliminated
                                  .contains(note.toString().toLowerCase()))
                                stringsToBeEliminated.remove(note.toString());
                            });
                            folderModel.questions.forEach((question) {
                              stringsToBeEliminated.add(question);
                            });
                            stringsToBeEliminated.add('noteAnswer');
                            stringsToBeEliminated.add('noteCreationDate');
                            stringsToBeEliminated.add('noteId');*/
                        });
                      },
                      icon: Icon(Icons.search_rounded),
                    ),
                  ],
                )
              : AppBar(
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  title: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_searchText) {
                      print(_searchText);
                      if (isNoteSearching) {
                        searchedNotes = Search.noteSearch(
                          searchText: _searchController.text,
                          notes: folderModel.notes,
                        );
                      } else if (isQuestionSearching) {
                        searchedQuestions = Search.questionSearch(
                          searchText: _searchController.text,
                          questions: folderModel.questions,
                        );
                      }
                      setState(() {});
                      print('notes: $searchedNotes');
                    },
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: searchHint,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                              icon: Icon(Icons.close_rounded,
                                  color: Colors.black),
                            )
                          : null,
                    ),
                  ),
                ),
        ),
        body: Column(
          children: [
            Container(
              height: Device.screenHeight * 0.085,
              color: ColorThemes.primaryColor,
              child: TabBar(
                indicatorWeight: Device.screenHeight * 0.005,
                controller: tabController,
                labelColor: Colors.redAccent,
                indicatorColor: ColorThemes.primaryDarkColor,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
                tabs: [
                  SkywaText(text: 'Responses', color: Colors.white),
                  SkywaText(text: 'Questions', color: Colors.white),
                ],
                onTap: (int index) {
                  setState(() {
                    tabController.index = index;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                // height: Device.screenHeight - (kToolbarHeight * 2 + Device.screenHeight * 0.085),
                child: TabBarView(
                  controller: tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildNotesList(),
                    buildQuestionsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: tabController.index == 0
            ? SkywaFloatingActionButton(
                iconData: Icons.add_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AddNotesScreen(
                        folderModel: folderModel,
                        fetchAllNotes: fetchAllNotes,
                      ),
                      type: PageTransitionType.rippleRightUp,
                    ),
                  );
                },
              )
            : SkywaFloatingActionButton(
                iconData: Icons.add_rounded,
                onTap: () {
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
    );
  }
}
