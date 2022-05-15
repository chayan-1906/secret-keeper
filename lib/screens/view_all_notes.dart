import 'package:diary_app/framework/widgets/skywa_floating_action_button.dart';
import 'package:diary_app/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../framework/widgets/skywa_appbar.dart';
import 'add_notes_screen.dart';

class ViewAllNotes extends StatefulWidget {
  final FolderModel folderModel;

  const ViewAllNotes({Key key, @required this.folderModel}) : super(key: key);

  @override
  State<ViewAllNotes> createState() => _ViewAllNotesState();
}

class _ViewAllNotesState extends State<ViewAllNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(appbarText: 'Add Notes'),
      ),
      floatingActionButton: SkywaFloatingActionButton(
        iconData: Icons.add_rounded,
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: AddNotesScreen(),
              type: PageTransitionType.rippleRightUp,
            ),
          );
        },
      ),
    );
  }
}
