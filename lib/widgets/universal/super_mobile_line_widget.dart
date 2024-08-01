import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';
import '../mobile_widgets/chart_heading.dart';

class SuperMobileLineWidget extends StatefulWidget {
  const SuperMobileLineWidget({super.key, required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  _SuperMobileLineWidgetState createState() => _SuperMobileLineWidgetState();
}

class _SuperMobileLineWidgetState extends State<SuperMobileLineWidget> {

  List<Color> get availableColors => const <Color>[
    AppColor.colorRed,
    AppColor.colorOrange,
    AppColor.colorYellow,
    AppColor.colorGreen,
    AppColor.colorBlue,
    AppColor.colorIndigo,
    AppColor.colorPurple,
    AppColor.cColorPink,
    AppColor.colorBrown,
    AppColor.colorCyan,
    AppColor.colorTeal,
    AppColor.colorLime,
  ];

  bool isShowingMainData = true;
  List<FlSpot> monthlySalesData = [];
  List<Color> monthlyColors = [
    AppColor.colorRed,
    AppColor.colorOrange,
    AppColor.colorYellow,
    AppColor.colorGreen,
    AppColor.colorBlue,
    AppColor.colorIndigo,
    AppColor.colorPurple,
    AppColor.cColorPink,
    AppColor.colorBrown,
    AppColor.colorCyan,
    AppColor.colorTeal,
    AppColor.colorLime,
  ];

  @override
  void initState() {
    super.initState();
    fetchMonthlyLogData();
  }

  Future<void> fetchMonthlyLogData() async {
    List<FlSpot> salesData = [];

    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    for (int i = 0; i < months.length; i++) {
      String monthYear = '${months[i]} ${DateTime.now().year}';
      int count = await getLogsForMonth(monthYear);
      salesData.add(FlSpot(i + 1, count.toDouble()));
    }

    setState(() {
      monthlySalesData = salesData;
    });
  }

  Future<int> getLogsForMonth(String monthYear) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('logs')
        .doc(monthYear)
        .collection('logList')
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: getLineBarsData(monthlySalesData),
    minX: 0,
    maxX: 12,
    maxY: 25,
    minY: 0,
  );

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: getLineBarsData(monthlySalesData, true),
    minX: 0,
    maxX: 12,
    maxY: 25,
    minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> getLineBarsData(List<FlSpot> salesData, [bool secondary = false]) {
    return salesData.map((spot) {
      int index = spot.x.toInt() - 1;
      return LineChartBarData(
        isCurved: true,
        color: monthlyColors[index].withOpacity(secondary ? 0.5 : 1.0),
        barWidth: secondary ? 4 : 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [spot],
      );
    }).toList();
  }

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = '${value.toInt()}';

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 5,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const ChartHeading(text: 'JAN');
        break;
      case 3:
        text = const ChartHeading(text: 'MAR');
        break;
      case 5:
        text = const ChartHeading(text: 'MAY');
        break;
      case 7:
        text = const ChartHeading(text: 'JUL');
        break;
      case 9:
        text = const ChartHeading(text: 'SEP');
        break;
      case 11:
        text = const ChartHeading(text: 'NOV');
        break;
      default:
        text = const ChartHeading(text: '');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: textColor.withOpacity(0.2)),
      left: BorderSide(color: textColor),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );
}