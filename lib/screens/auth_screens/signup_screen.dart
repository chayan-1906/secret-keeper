import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/services/color_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../../models/user_model.dart';
import '../../services/global_methods.dart';
import '../../widgets/loading_widget.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  var top = 0.0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // String _name = '';
  // String _emailAddress = '';
  // String _password = '';
  String _errorMsg = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    if (isValid) {
      _formKey.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.toLowerCase().trim(),
          password: _passwordController.text.trim(),
        );
        final User user = _firebaseAuth.currentUser;
        final _uid = user.uid;
        var createdDate = user.metadata.creationTime.toString();
        user.updateDisplayName(_nameController.text);
        user.reload();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .set(UserModel(
              authenticatedBy: 'email',
              createdAt: createdDate,
              email: _emailController.text,
              joinedAt: formattedDate,
              id: _uid,
              name: _nameController.text,
            ).toMap());
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
        print('error occurred: ${error.toString()}');
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
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                collapsedHeight: kToolbarHeight,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
                                'Sign Up',
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
                            'Sign Up',
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

                      /// textformfield name
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SkywaTextFormField.name(
                          textEditingController: _nameController,
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          onChanged: (value) {
                            setState(() {
                              _nameController;
                            });
                          },
                          suffixIcon: _nameController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _nameController.clear();
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

                      /// don't have an account? sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// already have an account
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: const LoginScreen(),
                                    type: PageTransitionType.rippleRightUp,
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: const [
                                    TextSpan(
                                      text: 'Already have an account?',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFF96E46),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nSign In',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Color(0xFFF96E46),
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// sign up
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingActionButton(
                              elevation: 10.0,
                              onPressed: _submitForm,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              backgroundColor: ColorThemes.primaryColor,
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
              child: const LoadingWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
