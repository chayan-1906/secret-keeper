import 'dart:async';

import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

import '../generated/assets.dart';
import 'auth_screens/user_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigateToUserState() {
    Navigator.pushReplacementNamed(context, UserState.routeName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), navigateToUserState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: Device.screenWidth,
            height: Device.screenHeight,
            color: Colors.white,
            child: Image.asset(Assets.imagesSplashScreen),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SkywaText(
                text: 'Padmanabha Das',
                textStyle: GoogleFonts.satisfy(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
