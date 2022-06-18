import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../../framework/widgets/skywa_textformfield.dart';
import '../../services/color_themes.dart';
import '../../services/global_methods.dart';
import '../../widgets/loading_widget.dart';
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
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
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
            slivers: [
              /// sliver appbar
              SliverAppBar(
                expandedHeight: Device.screenHeight * 0.35,
                collapsedHeight: kToolbarHeight,
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                floating: true,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return Container(
                      // color: Color(0xFFDB6B97),
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
                        background: const Center(
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
                        ),
                      ),

                      /// textformfield password
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SkywaTextFormField.visiblePassword(
                          textEditingController: _passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
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
                        ),
                      ),

                      /// forget password & sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// forgot password
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rippleRightUp,
                                    child: const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF141E61),
                                ),
                              ),
                            ),
                          ),

                          /// sign in
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingActionButton(
                              elevation: 10.0,
                              onPressed: _submitForm,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              backgroundColor: ColorThemes.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      /// don't have an account? sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// don't have an account
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rippleRightUp,
                                    child: const SignUpScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: const [
                                    TextSpan(
                                      text: 'Don\'t have an account?',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: ColorThemes.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\tSign Up',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: ColorThemes.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// while signing in loading
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Visibility(
              visible: _isLoading,
              child: LoadingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
