// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/widgets/universal/title_text.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_login_password_text_field_widget.dart';
import '../../../widgets/universal/web_login_text_field_widget.dart';
import '../../layout/one_web_layout/one_web_layout.dart';
import '../../layout/super_web_layout/super_web_layout.dart';
import '../../layout/three_web_layout/three_web_layout.dart';
import '../../layout/two_web_layout/two_web_layout.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLocked = false;
  int loginAttempts = 0;
  late DateTime lockoutEndTime;
  late SharedPreferences sharedPreferences;

  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    if (isLocked && DateTime.now().isBefore(lockoutEndTime)) {
      final remainingTime = lockoutEndTime.difference(DateTime.now());
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Account Locked',
        dialogBorderRadius: BorderRadius.circular(20),
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        desc:
        'Too many failed login attempts. Please try again after ${remainingTime.inMinutes} minutes.',
      ).show();
      return;
    }

    try {
      final UserCredential userCredential =
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        loginAttempts = 0;
        isLocked = false;

        final QuerySnapshot userSnapshot = await firestore
            .collection('users').
        doc(currentMonth)
            .collection('userList')
            .where('email', isEqualTo: email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final DocumentSnapshot userData = userSnapshot.docs.first;

          final String role = userData['role'];

          switch (role) {
            case 'Super':
              sharedPreferences.setString('userId', email).then((_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SuperWebLayout()),
                );
              });
              break;
            case 'Level One':
              sharedPreferences.setString('userId', email).then((_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OneWebLayout()),
                );
              });
              break;
            case 'Level Two':
              sharedPreferences.setString('userId', email).then((_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TwoWebLayout()),
                );
              });
              break;
            case 'Level Three':
              sharedPreferences.setString('userId', email).then((_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ThreeWebLayout()),
                );
              });
              break;
            default:
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: 'Login Failed',
                dialogBorderRadius: BorderRadius.circular(20),
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: true,
                desc: 'Invalid role. Please contact support.',
              ).show();
          }
        } else {
          loginAttempts++;
          if (loginAttempts >= 3) {
            isLocked = true;
            lockoutEndTime = DateTime.now().add(const Duration(minutes: 30));AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.topSlide,
              showCloseIcon: true,
              title: 'Account Locked',
              dialogBorderRadius: BorderRadius.circular(20),
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              desc: 'Too many failed login attempts. Please try again after 30 minutes.',
            ).show();
            return;
          }
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Login Failed',
            dialogBorderRadius: BorderRadius.circular(20),
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            desc: 'Invalid email or password. Please try again.',
          ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: 'Login Failed',
          dialogBorderRadius: BorderRadius.circular(20),
          dismissOnBackKeyPress: true,
          dismissOnTouchOutside: true,
          desc: 'An error occurred while logging in.',
        ).show();
      }
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Login Failed',
        dialogBorderRadius: BorderRadius.circular(20),
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        desc: e.code,
      ).show();
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: grey,
              child: Center(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: primary)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: Image.asset(
                      'assets/pngs/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TitleText(smart: 'Ticket', transit: 'Verification'),
                  const Gap(20),
                  WebLoginTextFieldWidget(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      hint: 'Email',
                      icon: Icons.email),
                  WebLoginPasswordFieldWidget(
                    controller: passwordController,
                    type: TextInputType.text,
                    hint: 'Password',
                    icon: Icons.lock,
                    icon1: isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    isOb: !isPasswordVisible,
                    onPres: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot password?',
                            style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, color: blue)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: WebElevatedActionButton(
                        onTap: (isLocked && DateTime.now().isBefore(lockoutEndTime)) ? null : () => signInWithEmailAndPassword(
                            emailController.text,
                            passwordController.text,
                            context
                        ),
                        text: 'Login', color: primary),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                          'Just a guest?',
                          maxLines: 2,
                          maxFontSize: 14,
                          minFontSize: 12,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                color: blue,
                                fontSize: 14,
                                fontWeight: FontWeight.w900
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: (){},
                          child: AutoSizeText(
                              'View data',
                              maxLines: 2,
                              maxFontSize: 16,
                              minFontSize: 12,
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    color: primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.underline
                                ),
                              )
                          ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
