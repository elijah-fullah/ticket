import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/drop_down_text.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_dialog_icon.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_elevated_back_button.dart';
import '../../../widgets/universal/web_heading_1.dart';

class SuperWebAddLogs extends StatefulWidget {
  const SuperWebAddLogs({super.key});

  @override
  State<SuperWebAddLogs> createState() => _SuperWebAddLogsState();
}

class _SuperWebAddLogsState extends State<SuperWebAddLogs> {

  DropdownMenuItem<String> buildMenuType(String type) =>
      DropdownMenuItem<String>(
        value: type,
        child: DropDownText(text: type),
      );

  final formKey = GlobalKey<FormState>();
  final TextEditingController logController = TextEditingController();
  bool isLoading = false;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    authController.getUserData();
  }

  @override
  void dispose() {
    logController.dispose();
    super.dispose();
  }

  Future<void> addLog(BuildContext context, String uid) async {
    final person = "${authController.myUser.value.firstName} ${authController.myUser.value.lastName}";
    final personId = authController.myUser.value.email.toString();
    final role = authController.myUser.value.role.toString();
    final currentTime = DateTime.now();

    setState(() {
      isLoading = true;
    });

    try {
      String ticket = logController.text.trim().toUpperCase();
      String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

      QuerySnapshot ticketCheck = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(currentMonth)
          .collection('ticketList')
          .where('ticket', isEqualTo: ticket)
          .where('status', isEqualTo: 'Unverified')
          .get();

      if (ticketCheck.docs.isNotEmpty) {
        bool confirm = await _showConfirmationDialog(context);
        if (confirm) {
          String ticketId = ticketCheck.docs.first.id;
          DocumentSnapshot ticketDoc = ticketCheck.docs.first;
          String corridor = ticketDoc['corridor'] ?? '';
          String direction = ticketDoc['direction'] ?? '';

          await FirebaseFirestore.instance
              .collection('tickets')
              .doc(currentMonth)
              .collection('ticketList')
              .doc(ticketId)
              .update({'status': 'Pending'});

          int idNumber = 1;
          QuerySnapshot existingLogsSnapshot = await FirebaseFirestore.instance
              .collection('logs')
              .doc(currentMonth)
              .collection('logList')
              .get();
          int existingLogsCount = existingLogsSnapshot.docs.length;
          idNumber += existingLogsCount;
          String code = 'ST${idNumber.toString().padLeft(3, '0')}';

          await FirebaseFirestore.instance
              .collection('logs')
              .doc(currentMonth)
              .collection('logList')
              .add({
            "code": code,
            'date': currentTime.toUtc().millisecondsSinceEpoch,
            'time': currentTime.toUtc().millisecondsSinceEpoch,
            'ticket': ticket,
            'status': 'Pending',
            'person': person,
            'role': role,
            'personId': personId,
            'corridor': corridor,
            'direction': direction,
          });

          return AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.topSlide,
              showCloseIcon: true,
              title: 'Confirmation',
              dialogBorderRadius: BorderRadius.circular(12),
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              desc: 'Ticket logged successfully!',
              btnOkOnPress: () {
                Navigator.pop(context);
              }
          ).show();
        }
      } else {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: 'Error',
          dialogBorderRadius: BorderRadius.circular(12),
          dismissOnBackKeyPress: true,
          dismissOnTouchOutside: true,
          desc: 'The ticket is not available.',
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Error',
        dialogBorderRadius: BorderRadius.circular(12),
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        desc: 'Error: $e.',
      ).show();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to log this ticket?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
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
          const WebDialogIcon(icon: FluentSystemIcons.ic_fluent_send_logging_filled),
          const Gap(5),
          const WebHeading1(text: 'Ticket Log'),
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
                  const SubHeadingText(text: 'Ticket ID'),
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
                        enabled: !isLoading,
                        controller: logController,
                        decoration: InputDecoration(
                          hintText: 'Ticket ID',
                          hintStyle: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              color: blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          border: InputBorder.none,
                          focusColor: blue,
                          fillColor: blue,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          } else if (value.length != 8) {
                            return "It must be exactly 8 characters long";
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
          const Gap(50),
          WebElevatedActionButton(
              onTap: isLoading ? null : () {
                if (formKey.currentState!.validate()) {
                  addLog(context, user.uid);
                }
              },
              text: isLoading ? 'Adding' : 'Add',
              color: isLoading ? Colors.grey : blue
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
