import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary_app/framework/widgets/skywa_elevated_button.dart';
import 'package:diary_app/framework/widgets/skywa_rich_text.dart';
import 'package:diary_app/framework/widgets/skywa_text.dart';
import 'package:diary_app/generated/assets.dart';
import 'package:diary_app/widgets/glassmorphic_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../../framework/widgets/skywa_textformfield.dart';
import '../../services/color_themes.dart';
import '../../services/global_methods.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  var top = 0.0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMsg = '';
  bool _obscureText = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await _firebaseAuth
            .signInWithEmailAndPassword(
          email: _emailController.text.toLowerCase().trim(),
          password: _passwordController.text.trim(),
        )
            .then((value) {
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        });
      } catch (error) {
        String authErrorText = '';
        if (error.toString() ==
            '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
          /// invalid username / password
          authErrorText =
              'The password is invalid or the user does not have a password.';
        } else if (error.toString() ==
            '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
          /// user not registered
          authErrorText =
              'There is no user record corresponding to this identifier. The user may have been deleted.';
        } else {
          authErrorText = error.toString();
        }
        GlobalMethods.authErrorDialog(context, 'Error Occurred', authErrorText);
        print('error occurred ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: [
              /// sliver appbar
              SliverAppBar(
                expandedHeight: Device.screenHeight * 0.45,
                collapsedHeight: kToolbarHeight,
                centerTitle: true,
                floating: true,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return Container(
                      color: ColorThemes.primaryColor,
                      child: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: top <= 110.0 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const AutoSizeText(
                                'Sign In',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFFEEF2FF),
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /*background: const Center(
                          child: AutoSizeText(
                            'Sign In',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 70.0,
                              color: Color(0xFFEEF2FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),*/
                        background: Container(
                          padding: EdgeInsets.only(
                            left: 30.0,
                            right: 30.0,
                            top: 35.0,
                            bottom: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// secret keeper
                              SkywaText(
                                text: 'Secret Keeper',
                                fontSize: 30.0,
                                letterSpacing: 1.3,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 5.0),

                              /// your personal notekeeper
                              SkywaText(
                                text: 'Your personal notekeeper',
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),

                              /// app icon
                              Flexible(
                                child: Center(
                                  child: Image.asset(Assets.appIcon),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// sliver body
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15.0),

                      /// textformfield email
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SkywaTextFormField.emailAddress(
                          textEditingController: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email address',
                          onChanged: (value) {
                            setState(() {
                              _emailController;
                            });
                          },
                          suffixIcon: _emailController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _emailController.clear();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: ColorThemes.primaryColor,
                                  ),
                                )
                              : null,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                          },
                        ),
                      ),

                      /// textformfield password
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SkywaTextFormField.visiblePassword(
                          textEditingController: _passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          isObscure: true,
                          onChanged: (value) {
                            setState(() {
                              _passwordController;
                            });
                          },
                          suffixIcon: _passwordController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordController.clear();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: ColorThemes.primaryColor,
                                  ),
                                )
                              : null,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                          },
                        ),
                      ),

                      /// forgot password & sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// forgot password
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rippleRightUp,
                                    child: const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const SkywaText(
                                text: 'Forgot Password',
                                color: Color(0xFF141E61),
                                letterSpacing: 0.8,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          /// sign in
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SkywaElevatedButton.save(
                              onTap: _submitForm,
                              text: 'Sign In',
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// new user? sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// new user?
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: SkywaRichText(
                              texts: ['New User? ', 'Sign Up'],
                              textStyles: [
                                TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ],
                              onTaps: [
                                () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rippleRightUp,
                                      child: const SignUpScreen(),
                                    ),
                                  );
                                }
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// while signing in loading
          if (_isLoading)
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: GlassMorphicLoader(text: 'Signing In...'),
            ),
        ],
      ),
    );
  }
}
