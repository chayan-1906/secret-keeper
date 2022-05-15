import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_bottom_sheet.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/screens/view_all_notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../framework/widgets/skywa_alert_dialog.dart';
import '../framework/widgets/skywa_appbar.dart';
import '../framework/widgets/skywa_button.dart';
import '../framework/widgets/skywa_floating_action_button.dart';
import '../framework/widgets/skywa_text.dart';
import '../framework/widgets/skywa_textformfield.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';
import '../widgets/folder_widget.dart';
import '../widgets/question_row_widget.dart';
import 'view_all_questions_screen.dart';

CollectionReference folderReference;

class ViewAllFolderScreen extends StatefulWidget {
  const ViewAllFolderScreen({Key key}) : super(key: key);

  @override
  State<ViewAllFolderScreen> createState() => _ViewAllFolderScreenState();
}

class _ViewAllFolderScreenState extends State<ViewAllFolderScreen> {
  // List _folders = [];
  final TextEditingController _folderController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<FolderModel> folders = [];
  List<dynamic> questions = [];
  bool isLoading = false;
  SkywaAppBar _defaultAppBar;
  SkywaAppBar _selectedAppBar;
  FolderModel selectedFolderModel;
  final List<int> _selectedFoldersIndex = [];

  Widget folderShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.10,
        crossAxisCount: 2,
      ),
      itemCount: Device.screenHeight ~/ 2,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: Device.screenWidth / 2,
          height: 120.0,
          margin: EdgeInsets.symmetric(
            horizontal: Device.screenWidth * 0.03,
            vertical: 20.0,
          ),
          child: Shimmer.fromColors(
            highlightColor: Colors.grey,
            baseColor: Colors.white38,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> createFolder() async {
    String folderId = GlobalMethods.generateUniqueId();
    String folderCreationDate = DateTime.now().toString();
    FolderModel folderModel = FolderModel(
      folderId: folderId,
      folderName: _folderController.text,
      folderCreationDate: folderCreationDate,
      questions: <QuestionModel>[],
    );
    await folderReference.doc(folderId).set(folderModel.toMap()).then((value) {
      print('Folder added: $folderModel');
      setState(() {
        refreshViewAllFolders();
      });
    });
  }

  Future<void> deleteFolder({@required FolderModel folderModel}) async {
    setState(() {
      isLoading = true;
    });
    folderReference.doc(folderModel.folderId).delete().then((value) {
      setState(() {
        isLoading = false;
      });
      // fetchAllQuestions();
    });
  }

  void showAlertDialog() {
    SkywaAlertDialog.success(
      context: context,
      barrierDismissible: false,
      titleText: 'Add New Folder',
      titlePadding: EdgeInsets.only(
        top: Device.screenHeight * 0.025,
        bottom: Device.screenHeight * 0.025,
        left: Device.screenWidth * 0.05,
        right: Device.screenWidth * 0.01,
      ),
      fontSize: 22.0,
      content: Container(
        width: Device.screenWidth,
        constraints: BoxConstraints(
          minHeight: Device.screenHeight * 0.08,
          maxHeight: Device.screenHeight * 0.55,
        ),
        padding: const EdgeInsets.all(12.0),
        // TODO: if _questionController.isNotEmpty then show save button
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            _folderController.clear();
            return Column(
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      SkywaTextFormField.name(
                        textEditingController: _folderController,
                        labelText: 'Folder Name',
                        hintText: 'Enter folder name...',
                        onChanged: (value) {
                          setState(() {
                            _folderController;
                          });
                        },
                        suffixIcon: _folderController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _folderController.clear();
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
                      if (_folderController.text.isNotEmpty)
                        SkywaButton.save(
                            text: 'Save',
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _folderController;
                              });
                              createFolder();
                            }),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  void _changeSelection({@required bool enabled, @required int index}) {
    if (_selectedFoldersIndex.contains(index)) return;
    _selectedFoldersIndex.add(index);
    if (index == -1) _selectedFoldersIndex.clear();
  }

  Future<void> fetchAllFolders() async {
    setState(() {
      isLoading = true;
    });
    folders.clear();
    folderReference.get().then((QuerySnapshot querySnapshot) {
      for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
        /*for (var question in queryDocumentSnapshot['questions']) {
          QuestionModel questionFromJson = QuestionModel.fromJson(question);
          questions.add(questionFromJson);
        }*/
        FolderModel folderModel = FolderModel(
          folderId: queryDocumentSnapshot['folderId'],
          folderName: queryDocumentSnapshot['folderName'],
          folderCreationDate: queryDocumentSnapshot['folderCreationDate'],
          // questions: questions,
          questions: queryDocumentSnapshot['questions'],
        );
        setState(() {
          folders.add(folderModel);
          folders.sort(
            (a, b) {
              return DateTime.parse(a.folderCreationDate)
                  .compareTo(DateTime.parse(b.folderCreationDate));
            },
          );
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> refreshViewAllFolders() async {
    fetchAllFolders();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderReference = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('folders');
    fetchAllFolders();
  }

  @override
  Widget build(BuildContext context) {
    _defaultAppBar = SkywaAppBar(appbarText: 'All Folders');
    _selectedAppBar = SkywaAppBar(
      appbarText: '${_selectedFoldersIndex.length}',
      centerTitle: false,
      backIconButton: IconButton(
        onPressed: () {
          setState(() {
            _selectedFoldersIndex.clear();
          });
        },
        icon: const Icon(Icons.close_rounded),
      ),
      actions: [
        IconButton(
          onPressed: () {
            SkywaAlertDialog.error(
              context: context,
              titleText: 'Delete Folder',
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
                      text: 'Do you want to delete folder?',
                      fontSize: 18.0,
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
                            for (int i = 0;
                                i < _selectedFoldersIndex.length;
                                i++) {
                              deleteFolder(
                                  folderModel:
                                      folders[_selectedFoldersIndex[i]]);
                            }
                            _selectedFoldersIndex.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
      ],
    );

    return WillPopScope(
      onWillPop: () {
        if (_selectedFoldersIndex.isNotEmpty) {
          setState(() {
            _selectedFoldersIndex.clear();
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child:
              _selectedFoldersIndex.isEmpty ? _defaultAppBar : _selectedAppBar,
        ),
        body: isLoading
            ? folderShimmer()
            : folders.isNotEmpty
                ? Container(
                    height: Device.screenHeight,
                    width: Device.screenWidth,
                    child: Stack(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.10,
                            crossAxisCount: 2,
                          ),
                          itemCount: folders.length,
                          itemBuilder:
                              (BuildContext gridViewContext, int index) {
                            FolderModel folderModel = folders[index];
                            return GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _changeSelection(enabled: true, index: index);
                                });
                              },
                              onTap: () {
                                setState(() {
                                  if (_selectedFoldersIndex.contains(index)) {
                                    _selectedFoldersIndex.remove(index);
                                  } else if (_selectedFoldersIndex.isEmpty) {
                                    SkywaBottomSheet(
                                      context: gridViewContext,
                                      content: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            /// view notes
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: ViewAllNotes(
                                                        folderModel:
                                                            folderModel),
                                                    type: PageTransitionType
                                                        .rippleRightUp,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SkywaText(
                                                    text: 'View Notes'),
                                              ),
                                            ),

                                            /// view questions
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child:
                                                        ViewAllQuestionsScreen(
                                                      folderModel: folderModel,
                                                      refreshViewAllFolders:
                                                          refreshViewAllFolders,
                                                    ),
                                                    type: PageTransitionType
                                                        .rippleRightUp,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SkywaText(
                                                    text: 'View Questions'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    _selectedFoldersIndex.add(index);
                                  }
                                  print(_selectedFoldersIndex);
                                });
                              },
                              child: Stack(
                                children: [
                                  FolderWidget(folderModel: folderModel),
                                  if (_selectedFoldersIndex.contains(index))
                                    const Positioned(
                                      left: 20.0,
                                      top: 30.0,
                                      child: Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.white,
                                      ),
                                    )
                                  else if (_selectedFoldersIndex.isNotEmpty &&
                                      !_selectedFoldersIndex.contains(index))
                                    const Positioned(
                                      left: 20.0,
                                      top: 30.0,
                                      child: Icon(
                                        Icons.check_box_outline_blank_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: SkywaFloatingActionButton(
                            iconData: AntDesign.addfolder,
                            iconSize: 20.0,
                            onTap: () {
                              showAlertDialog();
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
                          iconData: AntDesign.addfolder,
                          iconSize: 20.0,
                          onTap: () {
                            showAlertDialog();
                          },
                        ),
                        const SizedBox(height: 10.0),
                        SkywaText(
                          text: 'Add New Folder',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
        /*body: Container(
          height: Device.screenHeight,
          child: StreamBuilder(
              stream: _folderReference
                  .orderBy('folderCreationDate', descending: false)
                  .snapshots(),
              builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
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
                        child: folderShimmer(),
                      ),
                    ],
                  );
                }
                _folders = snapshot.data.docs.map((question) {
                  return FolderModel.fromJson(question);
                }).toList();
                return _folders.isNotEmpty
                    ? Stack(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.10,
                              crossAxisCount: 2,
                            ),
                            itemCount: _folders.length,
                            itemBuilder:
                                (BuildContext gridViewContext, int index) {
                              FolderModel folderModel = _folders[index];
                              return GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    _changeSelection(
                                        enabled: true, index: index);
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    if (_selectedFoldersIndex.contains(index)) {
                                      _selectedFoldersIndex.remove(index);
                                    } else if (_selectedFoldersIndex.isEmpty) {
                                      SkywaBottomSheet(
                                        context: gridViewContext,
                                        content: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              /// view notes
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      child: ViewAllNotes(
                                                          folderModel:
                                                              folderModel),
                                                      type: PageTransitionType
                                                          .rippleRightUp,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SkywaText(
                                                      text: 'View Notes'),
                                                ),
                                              ),

                                              /// view questions
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      child:
                                                          ViewAllQuestionsScreen(
                                                              folderModel:
                                                                  folderModel),
                                                      type: PageTransitionType
                                                          .rippleRightUp,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: SkywaText(
                                                      text: 'View Questions'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      _selectedFoldersIndex.add(index);
                                    }
                                    print(_selectedFoldersIndex);
                                  });
                                },
                                child: Stack(
                                  children: [
                                    FolderWidget(folderModel: folderModel),
                                    if (_selectedFoldersIndex.contains(index))
                                      const Positioned(
                                        left: 20.0,
                                        top: 30.0,
                                        child: Icon(
                                          Icons.check_box_rounded,
                                          color: Colors.white,
                                        ),
                                      )
                                    else if (_selectedFoldersIndex.isNotEmpty &&
                                        !_selectedFoldersIndex.contains(index))
                                      const Positioned(
                                        left: 20.0,
                                        top: 30.0,
                                        child: Icon(
                                          Icons.check_box_outline_blank_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10.0,
                            right: 10.0,
                            child: SkywaFloatingActionButton(
                              iconData: AntDesign.addfolder,
                              iconSize: 20.0,
                              onTap: () {
                                showAlertDialog();
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
                              iconData: AntDesign.addfolder,
                              iconSize: 20.0,
                              onTap: () {
                                showAlertDialog();
                              },
                            ),
                            const SizedBox(height: 10.0),
                            SkywaText(
                              text: 'Add New Folder',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      );
              }),
        ),*/
      ),
    );
  }
}
