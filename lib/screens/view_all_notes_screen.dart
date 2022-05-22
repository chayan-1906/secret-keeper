import 'package:diary_app/framework/widgets/skywa_floating_action_button.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:diary_app/models/note_model.dart';
import 'package:diary_app/services/color_themes.dart';
import 'package:diary_app/services/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../framework/widgets/skywa_appbar.dart';
import 'add_notes_screen.dart';

class ViewAllNotesScreen extends StatefulWidget {
  final FolderModel folderModel;
  final Function refreshViewAllFolders;

  const ViewAllNotesScreen({
    Key key,
    @required this.folderModel,
    @required this.refreshViewAllFolders,
  }) : super(key: key);

  @override
  State<ViewAllNotesScreen> createState() => _ViewAllNotesScreenState();
}

class _ViewAllNotesScreenState extends State<ViewAllNotesScreen> {
  FolderModel folderModel;
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List notes = [];
  List<String> stringsToBeEliminated = [];

  /*Widget questionShimmer() {
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
  }*/

  Future<void> fetchAllNotes() async {
    print('fetchAllNotes called');
    setState(() {
      folderModel.notes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderModel = widget.folderModel;
    print(folderModel);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isSearching) {
          setState(() {
            isSearching = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: !isSearching
              ? SkywaAppBar(
                  appbarText: 'View All Notes',
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = true;
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
                      notes = Search.search(
                        searchText: _searchController.text,
                        items: folderModel.notes,
                        stringsToBeEliminated: stringsToBeEliminated,
                      );
                      setState(() {});
                      print('notes: $notes');
                    },
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: Icon(Icons.close_rounded, color: Colors.black),
                      ),
                    ),
                  ),
                ),
        ),
        // TODO: Show diff body when notes are not added yet or may be directly go to add_notes_screen
        body: ListView.builder(
          itemCount: isSearching ? notes.length : folderModel.notes.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> _note = {};
            if (isSearching) {
              _note = notes[index];
            } else {
              _note = folderModel.notes[index];
            }
            print('82: ${_note}');
            NoteModel noteModel = NoteModel(
              noteId: _note['noteId'],
              noteAnswer: _note['noteAnswer'],
              noteCreationDate: _note['noteCreationDate'],
            );
            print('87: ${noteModel.noteAnswer}');
            List<String> keys = [];
            noteModel.noteAnswer.keys.forEach((key) {
              keys.add(key);
            });
            List<String> values = [];
            noteModel.noteAnswer.values.forEach((value) {
              values.add(value);
            });
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
                        BoxShadow(
                          offset: Offset(5, 5),
                          color: Colors.grey.shade400,
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                        ),
                        BoxShadow(
                          offset: Offset(-5, -5),
                          color: Colors.grey.shade300,
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: keys.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int keyIndex) {
                        return SkywaText(
                            text: '${keys[keyIndex]}: ${values[keyIndex]}');
                      },
                    ),
                  ),
                  SkywaText(
                      text:
                          'creation date: ${noteModel.noteCreationDate.toString().substring(0, 10)}'),
                ],
              ),
            );
          },
        ),
        floatingActionButton: SkywaFloatingActionButton(
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
        ),
      ),
    );
  }
}
