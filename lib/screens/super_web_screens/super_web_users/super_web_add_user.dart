import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/drop_down_text.dart';
import '../../../widgets/universal/drop_down_type_widget.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_dialog_icon.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_elevated_back_button.dart';
import '../../../widgets/universal/web_heading_1.dart';
import 'package:http/http.dart' as http;

class SuperWebAddUser extends StatefulWidget {
  const SuperWebAddUser({super.key});

  @override
  State<SuperWebAddUser> createState() => _SuperWebAddUserState();
}

class _SuperWebAddUserState extends State<SuperWebAddUser> {

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem<String>(
        value: type,
        child: DropDownText(text: type),
      );

  String? val;
  List<String> types = ['Level One', 'Level Two', 'Level Three'];
  bool adding = false;
  late String num;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    firstController.dispose();
    lastController.dispose();
    contactController.dispose();
    emailController.dispose();
  }

  Future sendEmail(String firstName, String password, String email) async {
    const serviceId = 'service_q56l4uh';
    const templateId = 'template_p0dwsju';
    const userId = 'qQr4_R32IDtmnalnx';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': firstName,
          'user_password': password,
          'user_subject': 'Confirmation',
          'user_email': email,
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
  Future<void> addUser(BuildContext context, String uid) async {

    setState(() {
      adding = true;
    });

    try {
      String email = emailController.text.trim();
      String contact = contactController.text.trim();

      String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

      QuerySnapshot emailCheckUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMonth)
          .collection('userList')
          .where('email', isEqualTo: email)
          .get();

      QuerySnapshot contactCheckUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMonth)
          .collection('userList')
          .where('contact', isEqualTo: contact)
          .get();

      if (emailCheckUsers.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Email already exists.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: red,
        );
        return;
      }

      if (contactCheckUsers.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Contact already exists.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: red,
        );
        return;
      }

      String code;
      bool codeExists;
      int idNumber = 1;

      do {
        code = 'ST${idNumber.toString().padLeft(3, '0')}';
        QuerySnapshot codeCheckUsers = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentMonth)
            .collection('userList')
            .where('code', isEqualTo: code)
            .get();

        codeExists = codeCheckUsers.docs.isNotEmpty;
        if (codeExists) {
          idNumber++;
        }
      } while (codeExists);

      String password = generateRandomPassword();

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMonth)
          .collection('userList')
          .doc(userId)
          .set({
        "code": code,
        'firstName': firstController.text.trim(),
        'lastName': lastController.text.trim(),
        'contact': num,
        'email': email,
        'role': val!,
        'status': 'Active',
        'password': password,
      });

      await sendEmail(firstController.text.trim(), password, email);

      TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: 'AC44ffbb0fdaf6de95fecb52a353679fd1',
        authToken: '5e6d7f7da5e2910b864e022aa559b3c0',
        twilioNumber: '+16188926857',
      );

      try {
        await twilioFlutter.sendSMS(
          toNumber: num,
          messageBody:
          'Hello ${firstController.text.trim()}, you have been successfully registered. Your password is $password.',
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Failed to send SMS: $e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: red,
        );
      }
      Fluttertoast.showToast(
        msg: 'User added successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: primary,
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: red,
      );
    } finally {
      setState(() {
        adding = false;
      });
    }
  }
  String generateRandomPassword() {
    final random = Random();
    const length = 8;
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const characters = '$letters$numbers';

    String password;
    bool hasLetter = false;
    bool hasNumber = false;

    do {
      password = String.fromCharCodes(
        Iterable.generate(
          length,
              (_) => characters.codeUnitAt(
            random.nextInt(characters.length),
          ),
        ),
      );
      hasLetter = password.contains(RegExp(r'[A-Z]'));
      hasNumber = password.contains(RegExp(r'[0-9]'));
    } while (!hasLetter || !hasNumber);

    return password;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            children: [
              WebElevatedBackButton()
            ],
          ),
          const WebDialogIcon(icon: IconlyBold.user_2),
          const Gap(5),
          const WebHeading1(text: 'Add User'),
          const Divide(),
          const Gap(20),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(
                      text: 'User Type'),
                  const Gap(5),
                  DropDownTypeWidget(
                      val: val,
                      item: types
                          .map<
                          DropdownMenuItem<
                              String>>(
                          buildMenuType)
                          .toList(),
                      onChange: (newVal) {
                        setState(() {
                          val = newVal;
                        });
                      },
                      type: 'Select Type'),
                ],
              ),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'First Name'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        enabled: adding ? false : true,
                        controller: firstController,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: GoogleFonts.openSans(
                              textStyle:
                              const TextStyle(
                                  color: blue,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          border: InputBorder.none,
                          focusColor: blue,
                          fillColor: blue,
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(
                      text: 'Last Name'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        enabled: adding ? false : true,
                        controller: lastController,
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: GoogleFonts.openSans(
                              textStyle:
                              const TextStyle(
                                  color: blue,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          border: InputBorder.none,
                          focusColor: blue,
                          fillColor: blue,
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
          const Gap(30),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(
                      text: 'Email'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets
                          .symmetric(
                          horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        enabled: adding ? false : true,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.openSans(
                              textStyle:
                              const TextStyle(
                                  color: blue,
                                  fontWeight:
                                  FontWeight
                                      .bold)),
                          border: InputBorder.none,
                          focusColor: blue,
                          fillColor: blue,
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'Phone Contact'),
                  const Gap(5),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width /
                        4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10
                      ),
                      child: InternationalPhoneNumberInput(
                        height: 40,
                        controller: contactController,
                        inputFormatters: const [],
                        formatter: MaskedInputFormatter('## ## ## ##'),
                        initCountry: CountryCodeModel(name: "Sierra Leone", dial_code: "+232", code: "SL"),
                        onInputChanged: (phone) {
                          setState(() {
                            num = phone.fullNumber.replaceAll(' ', '');
                          });
                        },
                        betweenPadding: 23,
                        dialogConfig: DialogConfig(
                          backgroundColor: cardColor,
                          searchBoxBackgroundColor: cardColor,
                          searchBoxIconColor: background,
                          countryItemHeight: 50,
                          topBarColor: blue,
                          selectedItemColor: grey,
                          textStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          searchBoxTextStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          titleStyle:GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          searchBoxHintStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                        countryConfig: CountryConfig(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          noFlag: true,
                          textStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                        validator: (number) {
                          if (number.number.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        phoneConfig: PhoneConfig(
                          focusedColor: blue,
                          enabledColor: blue,
                          errorColor: red,
                          labelStyle: null,
                          labelText: null,
                          floatingLabelStyle: null,
                          focusNode: null,
                          radius: 12,
                          hintText: "Phone Number",
                          backgroundColor: Colors.transparent,
                          decoration: null,
                          popUpErrorText: true,
                          autoFocus: false,
                          showCursor: false,
                          textInputAction: TextInputAction.done,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          errorTextMaxLength: 1,
                          errorPadding: const EdgeInsets.only(top: 14),
                          errorStyle: TextStyle(
                              color: red, fontSize: 12, height: 1),
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(50),
          WebElevatedActionButton(
              onTap: adding ? null : () {
                if (formKey.currentState!.validate()) {
                  addUser(context, user.uid);
                }
              },
              text: adding ? 'Adding' : 'Add',
              color: adding ? Colors.grey : blue
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
