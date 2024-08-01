import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/drop_down_text.dart';
import '../../../widgets/universal/drop_down_type_widget.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_dialog_icon.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_elevated_back_button.dart';
import '../../../widgets/universal/web_heading_1.dart';

class ThreeWebAddTicket extends StatefulWidget {
  const ThreeWebAddTicket({super.key});

  @override
  State<ThreeWebAddTicket> createState() => _ThreeWebAddTicketState();
}

class _ThreeWebAddTicketState extends State<ThreeWebAddTicket> {

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem<String>(
        value: type,
        child: DropDownText(text: type),
      );

  final TextEditingController ticketController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? val;
  String? direction;
  late AuthController authController;
  List<String> corridor = [
    'East',
    'West',
  ];

  Map<String, List<String>> directions = {
    'East': [
      'Central-Bound',
      'East-Bound',
    ],

    'West': [
      'Central-Bound',
      'West-Bound',
    ],

  };

  List<String> currentDirections = [];
  List<String> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    authController.getUserData();
  }

  Future<void> addTicket(BuildContext context) async {
    final person = "${authController.myUser.value.firstName} ${authController.myUser.value.lastName}";
    final personId = authController.myUser.value.email.toString();
    final role = authController.myUser.value.role.toString();
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    final currentTime = DateTime.now();
    final ticket = ticketController.text.trim().toUpperCase();

    if (ticket.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a ticket.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: Colors.red,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot ticketCheck = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(currentMonth)
          .collection('ticketList')
          .where('ticket', isEqualTo: ticket)
          .get();

      if (ticketCheck.docs.isNotEmpty) {
        Fluttertoast.showToast(
          msg: 'Ticket already exists. Please enter a different ticket.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          textColor: Colors.red,
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      String code;
      bool codeExists;
      int idNumber = 1;
      do {
        code = 'WF${idNumber.toString().padLeft(3, '0')}';
        QuerySnapshot codeCheckUsers = await FirebaseFirestore.instance
            .collection('tickets')
            .doc(currentMonth)
            .collection('ticketList')
            .where('code', isEqualTo: code)
            .get();

        codeExists = codeCheckUsers.docs.isNotEmpty;
        if (codeExists) {
          idNumber++;
        }
      } while (codeExists);

      // Generate QR code data
      final qrCodeData = 'ticket:$ticket|code:$code';

      // Generate QR code image
      final qrCodeImage = await QrPainter(
        data: qrCodeData,
        version: QrVersions.auto,
        gapless: true,
      ).toImage(200);

      // Convert the image to a byte array
      final byteData = await qrCodeImage.toByteData(format: ImageByteFormat.png);
      final qrCodeBytes = byteData!.buffer.asUint8List();

      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(currentMonth)
          .collection('ticketList').add({
        "code": code,
        'corridor': val!,
        'direction': direction!,
        'ticket': ticket,
        'person': person,
        'personId': personId,
        'role': role,
        'status': 'Unverified',
        'time': currentTime.toUtc().millisecondsSinceEpoch,
        'qrCode': qrCodeBytes,
      });

      Fluttertoast.showToast(
        msg: 'Ticket added successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: primary,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: Colors.red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const WebDialogIcon(icon: FluentSystemIcons.ic_fluent_ticket_filled),
          const Gap(5),
          const WebHeading1(text: 'Add Ticket'),
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
                        controller: ticketController,
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
                            return "Required and it must be all 8 characters all caps";
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
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(
                      text: 'Corridor Type'),
                  const Gap(5),
                  DropDownTypeWidget(
                    val: val,
                    item: corridor.map<DropdownMenuItem<String>>(buildMenuType).toList(),
                    onChange: (newVal) {
                      setState(() {
                        val = newVal;
                        currentDirections = directions[newVal] ?? [];
                        direction = null;
                      });
                    },
                    type: 'Select Corridor',
                  ),
                ],
              ),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(
                      text: 'Direction'),
                  const Gap(5),
                  DropDownTypeWidget(
                    val: direction,
                    item: currentDirections
                        .map<DropdownMenuItem<String>>(buildMenuType)
                        .toList(),
                    onChange: (newDirection) {
                      setState(() {
                        direction = newDirection;
                      });
                    },
                    type: 'Select Direction',
                  ),
                ],
              ),
            ],
          ),
          const Gap(50),
          WebElevatedActionButton(
              onTap: isLoading ? null : () {
                if (formKey.currentState!.validate()) {
                  addTicket(context);
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
