import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ticket/widgets/universal/shimmer_view.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/mobile_widgets/indicator.dart';
import '../../../widgets/universal/heading_2.dart';
import '../../../widgets/universal/heading_3.dart';
import '../../../widgets/universal/super_web_line_widget.dart';
import '../../../widgets/universal/web_heading_1.dart';
import '../../../widgets/universal/web_icon.dart';
import '../../../widgets/universal/web_main_icon.dart';

class SuperWebDashboard extends StatefulWidget {
  const SuperWebDashboard({super.key});

  @override
  State<SuperWebDashboard> createState() => _SuperWebDashboardState();
}

class _SuperWebDashboardState extends State<SuperWebDashboard> {

  Map<String, Map<String, int>> monthlyCorridorLogs = {};
  Map<String, int> corridorLogs = {'East': 0, 'West': 0};
  String selectedMonth = '';
  late bool isLoading;
  bool isMonthDataLoading = false;
  late bool isShowingMainData;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchMonthlyCorridorLogs();
    fetchCorridorLogs();
    DateTime now = DateTime.now();
    selectedMonth = getMonthName(now.month);
    isShowingMainData = true;
    isLoading = true;
    Future.delayed(const Duration(seconds: 10), (){
      setState(() {
        isLoading = false;
      });
    });
  }

  String getMonthName(int monthNumber) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[monthNumber - 1];
  }
  Future<void> fetchMonthlyCorridorLogs() async {
    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    Map<String, Map<String, int>> logs = {};

    for (String month in months) {
      await fetchMonthData(month, logs);
    }

    setState(() {
      monthlyCorridorLogs = logs;
    });
  }
  Future<void> fetchMonthData(String month, Map<String, Map<String, int>> logs) async {
    setState(() {
      isMonthDataLoading = true;
    });

    String monthYear = '$month ${DateTime.now().year}';
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('logs')
        .doc(monthYear)
        .collection('logList')
        .get();

    Map<String, int> corridorLogs = {'East': 0, 'West': 0};
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        String corridor = doc.data()['corridor'];
        if (corridorLogs.containsKey(corridor)) {
          corridorLogs[corridor] = corridorLogs[corridor]! + 1;
        }
      }
    }
    logs[month] = corridorLogs;

    setState(() {
      isMonthDataLoading = false;
    });
  }
  List<PieChartSectionData> showingCorridorSections() {
    List<String> corridors = ['East', 'West'];
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      String corridor = corridors[i];
      int totalLogs = 0;

      if (monthlyCorridorLogs[selectedMonth] != null &&
          monthlyCorridorLogs[selectedMonth]!.containsKey(corridor)) {
        totalLogs = monthlyCorridorLogs[selectedMonth]![corridor]!;
      }

      return PieChartSectionData(
        color: getColorForMonthAndCorridor(corridor),
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
  Color getColorForMonthAndCorridor(String corridor) {
    return corridor == 'East' ? blue : primary;
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
            Heading3(text: 'Super Admin'),
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
                              Heading3(text: 'YTD Tickets')
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WebHeading1(text: snapshot.data.toString()),
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
                        child: WebIcon(icon: Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Gap(20),
        Row(
          children: [
            const Gap(10),
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width / 15,
                height: MediaQuery.of(context).size.height / 1.9,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isMonthDataLoading ? Center(child: SpinKitChasingDots(color: primary, size: 30,))
                    : Column(
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
                        child: SuperWebLineWidget(isShowingMainData: isShowingMainData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: MediaQuery.of(context).size.height / 1.9,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isMonthDataLoading ? Center(child: SpinKitChasingDots(color: primary, size: 30,))
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.09,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:  DropdownButton<String>(
                        value: selectedMonth,
                        elevation: 0,
                        isExpanded: true,
                        items: <String>[
                          'January', 'February', 'March', 'April', 'May', 'June',
                          'July', 'August', 'September', 'October', 'November', 'December'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: AutoSizeText(
                              value,
                              style: GoogleFonts.akayaTelivigala(
                                textStyle: TextStyle(fontSize: 14, color: blue),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedMonth = newValue!;
                            isMonthDataLoading = true;
                          });
                          await fetchMonthData(selectedMonth, monthlyCorridorLogs);
                          setState(() {
                            isMonthDataLoading = false;
                          });
                        },
                      ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Indicator(
                              color: blue,
                              text: '$selectedMonth - East',
                              isSquare: false,
                            ),
                            Indicator(
                              color: primary,
                              text: '$selectedMonth - West',
                              isSquare: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
        const Gap(20),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
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
        )
      ],
    );
  }
}