import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket/widgets/universal/heading_3.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';

class SuperMobileScanners extends StatefulWidget {
  const SuperMobileScanners({super.key});

  @override
  State<SuperMobileScanners> createState() => _SuperMobileScannersState();
}

class _SuperMobileScannersState extends State<SuperMobileScanners> {

  late bool isLoading;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    authController.getUserData();
  }

  Future<void> scanQrCode(BuildContext context) async {
    try {
      String scannedCode = await FlutterBarcodeScanner.scanBarcode(
        '#39abd0',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (scannedCode != '-1') {
        final parts = scannedCode.split('|');
        final ticketPart = parts.firstWhere((part) => part.startsWith('ticket:')).substring(7);
        //final codePart = parts.firstWhere((part) => part.startsWith('code:')).substring(5);

        // Call addLog method with extracted ticket information
        await addLog(context, ticketPart);
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
    }
  }
  Future<void> addLog(BuildContext context, String ticket) async {
    final person = "${authController.myUser.value.firstName} ${authController.myUser.value.lastName}";
    final personId = authController.myUser.value.email.toString();
    final role = authController.myUser.value.role.toString();
    final currentTime = DateTime.now();

    setState(() {
      isLoading = true;
    });

    try {
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

          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Confirmation',
            dialogBorderRadius: BorderRadius.circular(12),
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            desc: 'Ticket logged successfully!',
          ).show();
        }
      } else {
        AwesomeDialog(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: (){
              scanQrCode(context);
            },
            icon: const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: primary,
            )
        ),
        Gap(5),
        Heading3(text: 'Tap the icon to scan')
      ],
    );
  }
}
