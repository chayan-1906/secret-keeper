import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/framework/widgets/skywa_auto_size_text.dart';
import 'package:diary_app/framework/widgets/skywa_textformfield.dart';
import 'package:diary_app/services/color_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

import '../../framework/widgets/skywa_elevated_button.dart';
import '../../framework/widgets/skywa_rich_text.dart';
import '../../framework/widgets/skywa_text.dart';
import '../../generated/assets.dart';
import '../../models/user_model.dart';
import '../../services/global_methods.dart';
import '../../widgets/glassmorphic_loader.dart';
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
        UserModel userModel = UserModel(
          authenticatedBy: 'email',
          createdAt: createdDate,
          email: _emailController.text,
          joinedAt: formattedDate,
          id: _uid,
          name: _nameController.text,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .set(userModel.toMap());
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
                              child: SkywaAutoSizeText(
                                text: 'Sign Up',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                color: Color(0xFFEEF2FF),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.w800,
                              ),
                              SizedBox(height: 5.0),

                              /// your personal notekeeper
                              SkywaText(
                                text: 'Your personal notekeeper',
                                fontSize: 20.0,
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
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                          },
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
                              return 'Please enter your password';
                            }
                          },
                        ),
                      ),

                      /// forgot password & sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// sign in
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SkywaElevatedButton.save(
                              onTap: _submitForm,
                              text: 'Sign Up',
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// existing user? sign in
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// new user?
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: SkywaRichText(
                              texts: ['Existing User? ', 'Sign In'],
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
                                      child: const LoginScreen(),
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
              child: GlassMorphicLoader(text: 'Signing Up...'),
            ),
        ],
      ),
    );
  }
}
