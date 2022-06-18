import 'package:diary_app/framework/widgets/skywa_appbar.dart';
import 'package:diary_app/framework/widgets/skywa_button.dart';
import 'package:diary_app/models/user_model.dart';
import 'package:diary_app/screens/view_all_folders_screen.dart';
import 'package:diary_app/screens/view_all_questions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import 'add_question_screen.dart';

class HomeScreen extends StatefulWidget {
  final User firebaseUser;

  const HomeScreen({Key key, @required this.firebaseUser}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      /*appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(
          appbarText: 'Secret Keeper',
          actions: [
            IconButton(
              onPressed: () async {
                await _firebaseAuth.signOut();
              },
              icon: const Icon(Icons.power_settings_new_rounded),
            ),
          ],
        ),
      ),*/
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            SkywaButton.save(
              text: 'View All Folders',
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: ViewAllFolderScreen(firebaseUser: widget.firebaseUser),
                    type: PageTransitionType.rippleRightUp,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
