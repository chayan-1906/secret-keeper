import 'package:diary_app/screens/home_screen.dart';
import 'package:diary_app/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../landing_screen.dart';

class UserState extends StatelessWidget {
  static const String routeName = '/user_state';

  const UserState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        /*print('userSnapshot: $userSnapshot');*/
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingWidget(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            /*print('The user has already logged in ${userSnapshot.data}');*/
            return HomeScreen(firebaseUser: userSnapshot.data);
          } else {
            print('The user didn\'t log in');
            return const LandingScreen();
          }
        } else if (userSnapshot.hasError) {
          return const Center(
            child: Text(
              'Error occurred',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Error occurred',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        }
      },
    );
  }
}
