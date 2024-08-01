import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket/widgets/universal/shimmer_view.dart';
import '../../../constants/colors/colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/universal/heading_2.dart';
import '../../../widgets/universal/heading_3.dart';
import '../../../widgets/universal/one_line_widget.dart';
import '../../../widgets/universal/web_heading_1.dart';
import '../../../widgets/universal/web_icon.dart';
import '../../../widgets/universal/web_main_icon.dart';

class OneWebDashboard extends StatefulWidget {
  const OneWebDashboard({super.key});

  @override
  State<OneWebDashboard> createState() => _OneWebDashboardState();
}

class _OneWebDashboardState extends State<OneWebDashboard> {

  late bool isLoading;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    isLoading = true;
    Future.delayed(const Duration(seconds: 10), (){
      setState(() {
        isLoading = false;
      });
    });
    authController = Get.find<AuthController>();
    authController.getUserData();
  }

  final rowsPerPageOptions = [10, 20, 30];
  int rowsPerPage = 10;
  int currentPage = 0;

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get ticketStream {
    final currentUserEmail = authController.myUser.value.email.toString();
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .where('personId', isEqualTo: currentUserEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  late bool isShowingMainData;
  int touchedIndex = -1;

  Stream<int> getTicketToday() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final currentUserEmail = authController.myUser.value.email;

    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection("ticketList")
        .where('personId', isEqualTo: currentUserEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) =>
    DateTime.fromMillisecondsSinceEpoch(doc['time']).isAfter(startOfDay) &&
        DateTime.fromMillisecondsSinceEpoch(doc['time']).isBefore(endOfDay)
    ).length);
  }
  Stream<int> getTicketMonth() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    final currentUserEmail = authController.myUser.value.email;

    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .where('personId', isEqualTo: currentUserEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  Stream<int> getTicketYear() {
    int currentYear = DateTime.now().year;
    DateTime startOfYear = DateTime(currentYear, 1, 1);
    DateTime endOfYear = DateTime(currentYear + 1, 1, 1);

    final currentUserEmail = authController.myUser.value.email;

    if (currentUserEmail == null || currentUserEmail.isEmpty) {
      return Stream.value(0);
    }

    return FirebaseFirestore.instance
        .collectionGroup('ticketList')
        .where('personId', isEqualTo: currentUserEmail)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        if (!doc.data().containsKey('time')) {
          return false;
        }
        int time = doc['time'];
        DateTime ticketDate = DateTime.fromMillisecondsSinceEpoch(time);
        return ticketDate.isAfter(startOfYear) && ticketDate.isBefore(endOfYear);
      }).length;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error occurred: $error');
      }
      return 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const ShimmerView() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WebHeading1(text: 'Dashboard'),
          ],
        ),
        const Gap(5),
        const Row(
          children: [
            Heading3(text: 'Level One'),
            Gap(5),
            WebMainIcon(icon: Icons.space_dashboard)
          ],
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 80,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: getTicketToday(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitChasingDots(
                            color: primary,
                            size: 30,
                          );
                        } else if (snapshot.hasError) {
                          return const Heading3(
                            text: 'Error',
                          );
                        } else if (!snapshot.hasData || snapshot.data == 0) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: '0'),
                              Heading3(text: "Today's Tickets")
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: snapshot.data.toString()),
                              const Heading3(text: "Today's Tickets")
                            ],
                          );
                        }
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: mYellowColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: WebIcon(icon: Icons.today),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 80,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: getTicketMonth(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitChasingDots(
                            color: primary,
                            size: 30,
                          );
                        } else if (snapshot.hasError) {
                          return const Heading3(
                            text: 'Error',
                          );
                        } else if (!snapshot.hasData || snapshot.data == 0) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: '0'),
                              Heading3(text: 'MTD Tickets')
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: snapshot.data.toString()),
                              const Heading3(text: 'MTD Tickets')
                            ],
                          );
                        }
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: nPrimaryTextColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: WebIcon(icon: Icons.calendar_month),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: 80,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: getTicketYear(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SpinKitChasingDots(
                            color: primary,
                            size: 30,
                          );
                        } else if (snapshot.hasError) {
                          return const Heading3(
                            text: 'Error',
                          );
                        } else if (!snapshot.hasData || snapshot.data == 0) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: '0'),
                              Heading3(text: "Year's Tickets")
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: snapshot.data.toString()),
                              const Heading3(text: "Year's Tickets")
                            ],
                          );
                        }
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: mYellowColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: WebIcon(icon: Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const Gap(20),
        Row(
          children: [
            const Gap(10),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Heading2(text: 'Monthly Tickets'),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: OneLineWidget(isShowingMainData: isShowingMainData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
      ],
    );
  }
}