import 'package:diary_app/services/color_themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screens/user_state.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return MaterialApp(
            title: 'Secret Keeper',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: ThemeData(
              primaryColor: ColorThemes.primaryColor,
              errorColor: ColorThemes.errorColor,
              textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: ColorThemes.cursorColor),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: ColorThemes.accentColor),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: ColorThemes.primaryColor,
                /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Device.screenHeight * 0.02),
                  ),
                ),*/
              ),
            ),
            home: const SplashScreen(),
            routes: {
              UserState.routeName: (ctx) => const UserState(),
            },
          );
        });
  }
}
