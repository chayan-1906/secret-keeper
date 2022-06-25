/*import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../framework/widgets/skywa_elevated_button.dart';
import 'auth_screens/login_screen.dart';
import 'auth_screens/signup_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Landing'), elevation: 50.0),
      body: Column(
        children: [
          SkywaElevatedButton.save(
            text: 'Sign In',
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const LoginScreen(),
                  type: PageTransitionType.rippleRightUp,
                ),
              );
            },
            iconData: Icons.verified_user_rounded,
          ),
          const SizedBox(height: 10.0),
          SkywaElevatedButton.save(
            text: 'Sign Up',
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const SignUpScreen(),
                  type: PageTransitionType.rippleRightUp,
                ),
              );
            },
            iconData: Icons.verified_user_rounded,
          ),
        ],
      ),
    );
  }
}
*/