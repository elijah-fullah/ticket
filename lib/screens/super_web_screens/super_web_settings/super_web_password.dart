import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';

class SuperWebPassword extends StatefulWidget {
  const SuperWebPassword({super.key});

  @override
  State<SuperWebPassword> createState() => _SuperWebPasswordState();
}

class _SuperWebPasswordState extends State<SuperWebPassword> {

  late AuthController authController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController oldController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isLoading = false;
  bool isOld = false;
  bool isNew = false;
  bool isConfirm = false;
  bool isOldPasswordValid = false;

  final Map<String, bool> criteria = {
    'At least 8 characters': false,
    'Contains an uppercase letter': false,
    'Contains a lowercase letter': false,
    'Contains a number': false,
    'Contains a special character': false,
  };

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    authController.getUserData();
    newController.addListener(validatePassword);
    confirmController.addListener(validateConfirmPassword);
  }

  void validatePassword() {
    final password = newController.text;
    setState(() {
      criteria['At least 8 characters'] = password.length >= 8;
      criteria['Contains an uppercase letter'] = RegExp(r'[A-Z]').hasMatch(password);
      criteria['Contains a lowercase letter'] = RegExp(r'[a-z]').hasMatch(password);
      criteria['Contains a number'] = RegExp(r'[0-9]').hasMatch(password);
      criteria['Contains a special character'] = RegExp(r'[!@#\$&*~]').hasMatch(password);
      validateFields();
    });
  }
  void validateConfirmPassword() {
    setState(() {
      criteria['Passwords match'] = confirmController.text == newController.text;
      validateFields();
    });
  }
  void validateFields() {
    setState(() {});
  }

  void changePassword(BuildContext context) async {
    if (newController.text != confirmController.text) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Error',
        desc: 'New password and confirm password do not match.',
      ).show();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldController.text,
        );

        try {
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(newController.text);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Success',
            desc: 'Password changed successfully.',
          ).show();
        } catch (e) {
          setState(() {
            isOldPasswordValid = false;
          });
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Error',
            desc: 'Old password is incorrect.',
          ).show();
        }
      }
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Error',
        desc: e.message,
      ).show();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  bool isButtonEnabled() {
    return newController.text.isNotEmpty &&
        confirmController.text.isNotEmpty &&
        criteria['At least 8 characters'] == true &&
        criteria['Contains an uppercase letter'] == true &&
        criteria['Contains a lowercase letter'] == true &&
        criteria['Contains a number'] == true &&
        criteria['Contains a special character'] == true &&
        criteria['Passwords match'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(50),
        Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubHeadingText(text: 'Old Password'),
                      const Gap(5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: oldController,
                            enabled: isLoading ? false : true,
                            obscureText: !isOld,
                            decoration: InputDecoration(
                              hintText: 'Old Password',
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: blue,
                                  )),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: blue,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isOld = !isOld;
                                    });
                                  },
                                  icon: Icon(isOld ? Icons.visibility : Icons.visibility_off,
                                    color: blue,
                                  )),
                              border: InputBorder.none,
                              fillColor: blue,
                              focusColor: blue,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubHeadingText(text: 'New Password'),
                      const Gap(5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: newController,
                            enabled: isLoading ? false : true,
                            obscureText: !isNew,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: blue,
                                  )),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: blue,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isNew = !isNew;
                                    });
                                  },
                                  icon: Icon(isNew ? Icons.visibility : Icons.visibility_off,
                                    color: blue,
                                  )),
                              border: InputBorder.none,
                              fillColor: blue,
                              focusColor: blue,
                            ),
                          ),
                        ),
                      ),
                      Gap(20),
                      buildCriteriaList(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubHeadingText(text: 'Confirm Password'),
                      const Gap(5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: confirmController,
                            enabled: isLoading ? false : true,
                            obscureText: !isConfirm,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: blue,
                                  )),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: blue,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isConfirm = !isConfirm
                                      ;
                                    });
                                  },
                                  icon: Icon(isConfirm ? Icons.visibility : Icons.visibility_off,
                                    color: blue,
                                  )),
                              border: InputBorder.none,
                              fillColor: blue,
                              focusColor: blue,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(50),
              WebElevatedActionButton(
                onTap: isLoading || !isButtonEnabled() ? null : () => changePassword(context),
                text: isLoading ? 'Updating' : 'Update',
                color: isLoading || !isButtonEnabled() ? Colors.grey : blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCriteriaList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: criteria.entries.map((entry) {
        return Row(
          children: [
            Icon(
              entry.value ? Icons.check_circle : Icons.cancel,
              color: entry.value ? primary : red,
            ),
            Gap(5),
            Text(
              entry.key,
              style: TextStyle(
                color: entry.value ? primary : red,
                fontSize: 16,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
