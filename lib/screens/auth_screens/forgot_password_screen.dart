import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../framework/widgets/skywa_textformfield.dart';
import '../../services/color_themes.dart';
import '../../services/global_methods.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  String _emailAddress = '';
  String _errorMsg = '';

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        await _firebaseAuth
            .sendPasswordResetEmail(
                email: _emailController.text.trim().toLowerCase())
            .then(
          (value) {
            print('password reset: ${_emailController.text}');
            return Fluttertoast.showToast(
              msg: 'Password reset link sent your email',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: ColorThemes.secondaryColor,
              textColor: Colors.white,
              fontSize: 17.0,
            );
          },
        );
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const LoginScreen(),
            type: PageTransitionType.rippleRightUp,
          ),
        );
        // Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        GlobalMethods.authErrorDialog(
          context,
          'Error Occurred',
          error.toString(),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// sliver appbar
          SliverAppBar(
            expandedHeight: Device.screenHeight * 0.35,
            collapsedHeight: kToolbarHeight,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            floating: true,
            pinned: true,
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
                        Flexible(
                          child: AnimatedOpacity(
                            opacity: top <= 110.0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: const AutoSizeText(
                              'Forgot your password?',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xFFEEF2FF),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    background: const Center(
                      child: AutoSizeText(
                        'Forgot your \npassword?',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 50.0,
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

                  /// reset password
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 20.0,
                    ),
                    width: Device.screenWidth,
                    child: MaterialButton(
                      elevation: 10.0,
                      height: 50.0,
                      animationDuration: Duration(milliseconds: 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
                      ),
                      color: ColorThemes.primaryColor,
                      onPressed: () {
                        print(_emailAddress);
                        _submitForm();
                      },
                      child: AutoSizeText(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
