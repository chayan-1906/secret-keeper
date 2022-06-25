import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_auto_size_text.dart';
import 'package:diary_app/framework/widgets/skywa_outlined_button.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/models/note_model.dart';
import 'package:diary_app/models/question_model.dart';
import 'package:diary_app/screens/auth_screens/login_screen.dart';
import 'package:diary_app/screens/notes_questions_tabbar_screen.dart';
import 'package:diary_app/services/is_string_invalid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:shimmer/shimmer.dart';

import '../framework/widgets/skywa_alert_dialog.dart';
import '../framework/widgets/skywa_appbar.dart';
import '../framework/widgets/skywa_elevated_button.dart';
import '../framework/widgets/skywa_floating_action_button.dart';
import '../framework/widgets/skywa_text.dart';
import '../framework/widgets/skywa_textformfield.dart';
import '../services/color_themes.dart';
import '../services/global_methods.dart';
import '../services/search.dart';
import '../widgets/folder_widget.dart';
import 'view_all_questions_screen.dart';

FirebaseAuth firebaseAuth;
CollectionReference folderReference;
FirebaseFirestore firebaseFirestore;
FirebaseStorage firebaseStorage;

class ViewAllFolderScreen extends StatefulWidget {
  final User firebaseUser;

  const ViewAllFolderScreen({Key key, @required this.firebaseUser})
      : super(key: key);

  @override
  State<ViewAllFolderScreen> createState() => _ViewAllFolderScreenState();
}

class _ViewAllFolderScreenState extends State<ViewAllFolderScreen> {
  final TextEditingController _folderController = TextEditingController();
  final TextEditingController _folderSearchController = TextEditingController();
  User firebaseUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<FolderModel> folders = [];
  List<FolderModel> searchedFolders = [];
  List<dynamic> questions = [];
  bool isLoading = false;
  AppBar _defaultAppBar;
  SkywaAppBar _selectedAppBar;
  String initialLetter = '';
  FolderModel selectedFolderModel;
  final List<int> _selectedFoldersIndex = [];
  bool isSearching = false;
  String userName = '';

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
      notes: <NoteModel>[],
    );
    await folderReference.doc(folderId).set(folderModel.toMap()).then((value) {
      print('Folder added: $folderModel');
      setState(() {
        refreshViewAllFolders();
      });
    });
  }

  Future<void> editFolder({@required FolderModel folderModel}) async {
    folderReference
        .doc(folderModel.folderId)
        .update({'folderName': _folderController.text}).then((value) {
      refreshViewAllFolders();
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
    });
  }

  void showAddFolderAlertDialog(
      {FolderModel folderModel, String mode = 'add'}) {
    SkywaAlertDialog.info(
      context: context,
      titleText: 'Add New Label',
      titlePadding: EdgeInsets.only(
        top: Device.screenHeight * 0.025,
        bottom: Device.screenHeight * 0.025,
        left: Device.screenWidth * 0.05,
        right: Device.screenWidth * 0.05,
      ),
      fontSize: 20.0,
      content: Container(
        width: Device.screenWidth,
        constraints: BoxConstraints(
          minHeight: Device.screenHeight * 0.08,
          maxHeight: Device.screenHeight * 0.55,
        ),
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            if (mode == 'add')
              _folderController.clear();
            else if (mode == 'edit')
              _folderController.text = folderModel.folderName;
            return Column(
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      SkywaTextFormField.name(
                        textEditingController: _folderController,
                        labelText: 'Label Name',
                        hintText: 'Enter label name...',
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
                        SkywaElevatedButton.save(
                            text: 'Save',
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _folderController;
                              });
                              if (mode == 'add')
                                createFolder();
                              else if (mode == 'edit')
                                editFolder(folderModel: folderModel);
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

  void showProfileAlertDialog() {
    SkywaAlertDialog.info(
      context: context,
      fontSize: 22.0,
      content: Column(
        // shrinkWrap: true,
        children: [
          /// image
          Container(
            height: 120.0,
            width: 120.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorThemes.primaryDarkColor,
              borderRadius: BorderRadius.circular(450.0),
            ),
            child: SkywaText(
              text: initialLetter,
              fontSize: 80.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),

          /// display name
          SkywaText(
            text: userName,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 5.0),

          /// email
          SkywaAutoSizeText(
            text: firebaseUser.email,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.w500,
            textStyle: TextStyle(fontSize: 17.0),
          ),
          SizedBox(height: 5.0),

          /// last sign in at
          SkywaAutoSizeText(
            text:
                'Last signed in: ${firebaseUser.metadata.lastSignInTime.toString().substring(0, 16)}',
            maxLines: 1,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        ],
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
          notes: queryDocumentSnapshot['notes'],
        );
        if (mounted) {
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
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> refreshViewAllFolders() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      fetchAllFolders();
    }
  }

  Widget buildFolderGridView() {
    return Container(
      height: Device.screenHeight,
      width: Device.screenWidth,
      child: Stack(
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.10,
              crossAxisCount: 2,
            ),
            itemCount: isSearching ? searchedFolders.length : folders.length,
            itemBuilder: (BuildContext gridViewContext, int index) {
              FolderModel folderModel;
              folderModel =
                  isSearching ? searchedFolders[index] : folders[index];
              // print('folderModel: $folderModel');
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
                      if (folderModel.questions.isEmpty) {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: NotesQuestionTabBarScreen(
                              folderModel: folderModel,
                              refreshViewAllFolders: refreshViewAllFolders,
                              tabIndex: 1,
                            ),
                            type: PageTransitionType.rippleRightUp,
                          ),
                        );
                      } else {
                        /*SkywaBottomSheet(
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
                                        child: ViewAllNotesScreen(
                                          folderModel: folderModel,
                                          refreshViewAllFolders:
                                              refreshViewAllFolders,
                                        ),
                                        type: PageTransitionType.rippleRightUp,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SkywaText(text: 'View Notes'),
                                  ),
                                ),

                                /// view questions
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: ViewAllQuestionsScreen(
                                          folderModel: folderModel,
                                          refreshViewAllFolders:
                                              refreshViewAllFolders,
                                        ),
                                        type: PageTransitionType.rippleRightUp,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SkywaText(text: 'View Questions'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );*/
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rippleRightUp,
                            child: NotesQuestionTabBarScreen(
                              folderModel: folderModel,
                              refreshViewAllFolders: refreshViewAllFolders,
                            ),
                          ),
                        );
                      }
                    } else {
                      _selectedFoldersIndex.add(index);
                    }
                    // print('_selectedFoldersIndex: ${_selectedFoldersIndex}');
                  });
                },
                child: Stack(
                  children: [
                    FolderWidget(
                      folderModel: folderModel,
                      isSelected: _selectedFoldersIndex.isNotEmpty,
                      refreshViewAllFolders: refreshViewAllFolders,
                      showAddFolderAlertDialog: showAddFolderAlertDialog,
                    ),
                    if (_selectedFoldersIndex.contains(index))
                      const Positioned(
                        left: 20.0,
                        top: 30.0,
                        child: Icon(
                          Icons.check_box_rounded,
                          color: Colors.black,
                        ),
                      )
                    else if (_selectedFoldersIndex.isNotEmpty &&
                        !_selectedFoldersIndex.contains(index))
                      const Positioned(
                        left: 20.0,
                        top: 30.0,
                        child: Icon(
                          Icons.check_box_outline_blank_rounded,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          /// fab for add folder
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: _selectedFoldersIndex.isNotEmpty
                ? Container()
                : SkywaFloatingActionButton(
                    iconData: AntDesign.addfolder,
                    iconSize: 20.0,
                    onTap: () {
                      showAddFolderAlertDialog();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void showLogoutAlertDialog({@required BuildContext context}) {
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
        width: Device.screenWidth,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkywaText(
              text: 'Do you want to logout?',
              color: Colors.black.withOpacity(0.60),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TODO: After making SkywaOutlinedButton make No button with that widget
                SkywaOutlinedButton(
                    text: 'NO',
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                    }),
                SizedBox(width: 10.0),
                SkywaElevatedButton.save(
                    text: 'YES',
                    onTap: () {
                      _firebaseAuth.signOut();
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          child: LoginScreen(),
                          type: PageTransitionType.rippleRightUp,
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDisplayName() async {
    if (!isStringInvalid(text: firebaseUser.displayName)) {
      userName = firebaseUser.displayName;
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        userName = documentSnapshot.get('name');
      });
    }
    initialLetter = GlobalMethods.getInitialLetter(text: userName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
    firebaseStorage = FirebaseStorage.instance;
    folderReference = firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('folders');
    firebaseUser = widget.firebaseUser;
    print('firebaseUser: $firebaseUser');
    print('_firebaseAuth.currentUse: ${_firebaseAuth.currentUser}');
    getDisplayName();
    fetchAllFolders();
  }

  @override
  Widget build(BuildContext context) {
    _defaultAppBar = AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leadingWidth: 60.0,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showProfileAlertDialog();
            },
            child: Container(
              height: kToolbarHeight * 0.80,
              width: kToolbarHeight * 0.80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorThemes.primaryDarkColor,
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: SkywaText(
                text: initialLetter,
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      title: SkywaTextFormField.text(
        textEditingController: _folderSearchController,
        labelText: '',
        hintText: '',
        contentPadding: EdgeInsets.all(14.0),
        suffixIcon: _folderSearchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _folderSearchController.clear();
                    isSearching = false;
                  });
                },
                icon: Icon(Icons.close_rounded, color: Colors.black),
              )
            : null,
        onChanged: (String _searchText) {
          // print(_searchText);
          if (_folderSearchController.text.isNotEmpty) {
            setState(() {
              isSearching = true;
            });
          } else {
            setState(() {
              isSearching = false;
            });
          }
          searchedFolders = Search.folderSearch(
            searchText: _folderSearchController.text,
            folders: folders,
          );
          setState(() {});
          // searchedFolders.forEach((element) {
          //   print(element.folderName);
          // });
        },
        maxLines: 1,
      ),
      actions: [
        /// logout
        IconButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            showLogoutAlertDialog(context: context);
            ;
          },
          icon: Icon(Icons.logout_rounded, color: Colors.black),
        ),
      ],
    );
    _selectedAppBar = SkywaAppBar(
      // TODO: Change appbar color to white
      appbarText: '${_selectedFoldersIndex.length}',
      centerTitle: false,
      backIconButton: IconButton(
        onPressed: () {
          setState(() {
            _selectedFoldersIndex.clear();
          });
        },
        icon: const Icon(Icons.close_rounded, color: Colors.white),
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
                        SkywaElevatedButton.save(
                          text: 'Cancel',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 20.0),
                        SkywaElevatedButton.delete(
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
                            refreshViewAllFolders();
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
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child:
              _selectedFoldersIndex.isEmpty ? _defaultAppBar : _selectedAppBar,
        ),
        body: isLoading
            ? folderShimmer()
            : folders.isNotEmpty
                ? buildFolderGridView()
                :

                /// add very first folder
                SizedBox(
                    width: Device.screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkywaFloatingActionButton(
                          iconData: AntDesign.addfolder,
                          iconSize: 20.0,
                          onTap: () {
                            showAddFolderAlertDialog();
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
      ),
    );
  }
}
