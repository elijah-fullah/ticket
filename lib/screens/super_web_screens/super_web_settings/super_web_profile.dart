import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:ticket/widgets/universal/divide.dart';
import 'package:ticket/widgets/universal/heading_2.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';

class SuperWebProfile extends StatefulWidget {
  const SuperWebProfile({super.key});

  @override
  State<SuperWebProfile> createState() => _SuperWebProfileState();
}

class _SuperWebProfileState extends State<SuperWebProfile> {
  late AuthController authController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      authController = Get.find<AuthController>();
      authController.getUserData();
      firstNameController.text = authController.myUser.value.firstName ?? '';
      lastNameController.text = authController.myUser.value.lastName ?? '';
    });
  }

  Future<void> update(BuildContext context) async {
    String email = authController.myUser.value.email.toString();
    String newFirstName = firstNameController.text.trim();
    String newLastName = lastNameController.text.trim();
    String newFullName = "$newFirstName $newLastName";
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentMonth)
          .collection('userList')
          .where('email', isEqualTo: email)
          .get();

      for (var userDoc in userSnapshot.docs) {
        await userDoc.reference.update({
          'firstName': newFirstName,
          'lastName': newLastName,
        });
      }

      QuerySnapshot logsSnapshot = await FirebaseFirestore.instance
          .collection('logs')
          .doc(currentMonth)
          .collection('logList')
          .where('personId', isEqualTo: email)
          .get();

      for (var logDoc in logsSnapshot.docs) {
        await logDoc.reference.update({'person': newFullName});
      }

      QuerySnapshot ticketsSnapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(currentMonth)
          .collection('ticketList')
          .where('personId', isEqualTo: email)
          .get();

      for (var ticketDoc in ticketsSnapshot.docs) {
        await ticketDoc.reference.update({'person': newFullName});
      }

      Fluttertoast.showToast(
        msg: 'Your details updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: primary,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating your details: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(50),
        Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(IconlyBold.user_2, color: primary),
                      const Gap(5),
                      const SubHeadingText(text: 'First Name'),
                    ],
                  ),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        enabled: isLoading ? false : true,
                        decoration: InputDecoration(
                          hintText: authController.myUser.value.firstName ?? '',
                          hintStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(IconlyBold.user_2, color: primary),
                      const Gap(5),
                      const SubHeadingText(text: 'Last Name'),
                    ],
                  ),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: lastNameController,
                        enabled: isLoading ? false : true,
                        decoration: InputDecoration(
                          hintText: authController.myUser.value.lastName ?? '',
                          hintStyle: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
        ),
        Gap(50),
        Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user, color: primary),
                        const Gap(5),
                        const SubHeadingText(text: 'Role:'),
                        const Gap(5),
                        Heading2(text: authController.myUser.value.role.toString()),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, color: primary,),
                        const Gap(5),
                        const SubHeadingText(text: 'Status:'),
                        const Gap(5),
                        Heading2(text: authController.myUser.value.status.toString()),
                      ],
                    ),
                  ],
                ),
                Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divide(),
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: primary),
                        const Gap(5),
                        const SubHeadingText(text: 'Email:'),
                        const Gap(5),
                        Heading2(text: authController.myUser.value.email.toString()),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: primary),
                        const Gap(5),
                        const SubHeadingText(text: 'Phone:'),
                        const Gap(5),
                        Heading2(text: authController.myUser.value.phone.toString()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Gap(50),
        Row(
          children: [
            WebElevatedActionButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    update(context);
                  }
              },
                text: isLoading ? 'Updating' : 'Update',
                color: isLoading ? Colors.grey : blue
            )
          ],
        )
      ],
    );
  }
}
