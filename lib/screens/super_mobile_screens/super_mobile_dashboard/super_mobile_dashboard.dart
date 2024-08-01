import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ticket/widgets/universal/title_text.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/mobile_widgets/indicator.dart';
import '../../../widgets/universal/heading_2.dart';
import '../../../widgets/universal/heading_3.dart';
import '../../../widgets/universal/mobile_heading_1.dart';
import '../../../widgets/universal/mobile_icon.dart';
import '../../../widgets/universal/super_mobile_line_widget.dart';

class SuperMobileDashboard extends StatefulWidget {
  const SuperMobileDashboard({super.key});

  @override
  State<SuperMobileDashboard> createState() => _SuperMobileDashboardState();
}

class _SuperMobileDashboardState extends State<SuperMobileDashboard> {

  Map<String, Map<String, int>> monthlyCorridorLogs = {};
  Map<String, int> corridorLogs = {'East': 0, 'West': 0};
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    fetchMonthlyCorridorLogs();
    fetchCorridorLogs();
    isShowingMainData = true;
  }

  Future<void> fetchMonthlyCorridorLogs() async {
    List<String> months = ['January', 'March', 'May', 'July', 'September', 'November'];
    Map<String, Map<String, int>> logs = {};

    for (String month in months) {
      String monthYear = '$month ${DateTime.now().year}';
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('logs')
          .doc(monthYear)
          .collection('logList')
          .get();

      Map<String, int> corridorLogs = {'East': 0, 'West': 0};
      for (var doc in snapshot.docs) {
        String corridor = doc.data()['corridor'];
        if (corridorLogs.containsKey(corridor)) {
          corridorLogs[corridor] = corridorLogs[corridor]! + 1;
        }
      }
      logs[month] = corridorLogs;
    }

    setState(() {
      monthlyCorridorLogs = logs;
    });
  }
  Future<void> fetchCorridorLogs() async {
    try {
      Map<String, int> corridorLogs = {'East': 0, 'West': 0};
      String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('logs')
          .doc(currentMonth)
          .collection('logList')
          .get();

      for (var doc in snapshot.docs) {
        String corridor = doc.data()['corridor'] ?? '';
        if (corridorLogs.containsKey(corridor)) {
          corridorLogs[corridor] = corridorLogs[corridor]! + 1;
        }
      }

      setState(() {
        this.corridorLogs = corridorLogs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print("Error fetching corridor logs: $e");
      }
    }
  }

  late bool isShowingMainData;
  int touchedIndex = -1;

  Stream<int> getTicketToday() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .where('time', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .where('time', isLessThan: endOfDay.millisecondsSinceEpoch)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  Stream<int> getTicketMonth() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  Stream<int> getTicketYear() {
    int currentYear = DateTime.now().year;
    DateTime startOfYear = DateTime(currentYear, 1, 1);
    DateTime endOfYear = DateTime(currentYear + 1, 1, 1);

    return FirebaseFirestore.instance
        .collectionGroup('ticketList')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.where((doc) {
        DateTime ticketDate = DateTime.fromMillisecondsSinceEpoch(doc['time']);
        return ticketDate.isAfter(startOfYear) && ticketDate.isBefore(endOfYear);
      }).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  Row(
                    children: [
                      TitleText(smart: 'Smart', transit: 'Transit'),
                    ],
                  ),
                  Divider(
                    color: primary,
                    thickness: 0.2,
                  ),
                ],
              ),
            )
          ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                                  MobileHeading1(text: '0'),
                                  Heading3(text: "Today's Tickets")
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MobileHeading1(text: snapshot.data.toString()),
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
                            child: MobileIcon(icon: Icons.today),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                                  MobileHeading1(text: '0'),
                                  Heading3(text: 'MTD Tickets')
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MobileHeading1(text: snapshot.data.toString()),
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
                            child: MobileIcon(icon: Icons.calendar_month),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                                  MobileHeading1(text: '0'),
                                  Heading3(text: 'YTD Tickets')
                                ],
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MobileHeading1(text: snapshot.data.toString()),
                                  const Heading3(text: 'YTD Tickets')
                                ],
                              );
                            }
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: MobileIcon(icon: Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 1.9,
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
                            Heading2(text: 'Monthly logs'),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: SuperMobileLineWidget(isShowingMainData: isShowingMainData),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 1.9,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                            'Corridor Monthly Logs',
                            maxLines: 2,
                            maxFontSize: 30,
                            minFontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.akayaTelivigala(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900
                              ),
                            )
                        ),
                        const Gap(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.height / 4,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event.isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection == null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingCorridorSections(),
                                ),
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorBlue,
                                    text: 'JAN - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.blueGrey,
                                    text: 'JAN - West',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorYellow,
                                    text: 'MAR - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.yellowAccent,
                                    text: 'MAR - West',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorPurple,
                                    text: 'MAY - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.purpleAccent,
                                    text: 'MAY - West',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorGreen,
                                    text: 'JUL - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.greenAccent,
                                    text: 'JUL - West',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorRed,
                                    text: 'SEP - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.redAccent,
                                    text: 'SEP - West',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: AppColors.contentColorPink,
                                    text: 'NOV - East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: Colors.pinkAccent,
                                    text: 'NOV - West',
                                    isSquare: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                            'Corridor Logs',
                            maxLines: 2,
                            maxFontSize: 30,
                            minFontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.akayaTelivigala(
                              textStyle: const TextStyle(
                                  color: blue,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900
                              ),
                            )
                        ),
                        const Gap(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.height / 4,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event.isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection == null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(),
                                ),
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: blue,
                                    text: 'East',
                                    isSquare: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Indicator(
                                    color: primary,
                                    text: 'West',
                                    isSquare: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingCorridorSections() {
    List<String> corridors = ['East', 'West'];
    return List.generate(12, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      int monthIndex = i ~/ 2;
      String corridor = corridors[i % 2];
      String month = ['January', 'March', 'May', 'July', 'September', 'November'][monthIndex];
      int totalLogs = 0;

      if (monthlyCorridorLogs[month] != null && monthlyCorridorLogs[month]!.containsKey(corridor)) {
        totalLogs = monthlyCorridorLogs[month]![corridor]!;
      }

      return PieChartSectionData(
        color: getColorForMonthAndCorridor(month, corridor),
        value: totalLogs.toDouble(),
        title: '$totalLogs',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
  Color getColorForMonthAndCorridor(String month, String corridor) {
    switch (month) {
      case 'January':
        return corridor == 'East' ? AppColors.contentColorBlue : Colors.blueGrey;
      case 'March':
        return corridor == 'East' ? AppColors.contentColorYellow : Colors.yellowAccent;
      case 'May':
        return corridor == 'East' ? AppColors.contentColorPurple : Colors.purpleAccent;
      case 'July':
        return corridor == 'East' ? AppColors.contentColorGreen : Colors.greenAccent;
      case 'September':
        return corridor == 'East' ? AppColors.contentColorRed : Colors.redAccent;
      case 'November':
        return corridor == 'East' ? AppColors.contentColorPink : Colors.pinkAccent;
      default:
        return AppColors.contentColorBlue;
    }
  }

  List<PieChartSectionData> showingSections() {
    List<String> corridors = ['East', 'West'];
    return List.generate(corridors.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      String corridor = corridors[i];
      int totalLogs = corridorLogs[corridor] ?? 0;

      return PieChartSectionData(
        color: getColorForCorridor(corridor),
        value: totalLogs.toDouble(),
        title: '$totalLogs',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
  Color getColorForCorridor(String corridor) {
    switch (corridor) {
      case 'East':
        return blue;
      case 'West':
        return primary;
      default:
        return Colors.grey;
    }
  }
}
