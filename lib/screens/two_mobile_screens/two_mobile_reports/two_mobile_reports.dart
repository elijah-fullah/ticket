import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:ticket/screens/two_mobile_screens/two_mobile_reports/two_mobile_integrity.dart';
import 'package:ticket/screens/two_mobile_screens/two_mobile_reports/two_mobile_unverified.dart';
import 'package:ticket/screens/two_mobile_screens/two_mobile_reports/two_mobile_verified.dart';
import 'package:ticket/widgets/universal/all_text.dart';
import '../../../constants/colors/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/universal/appbar_heading_1.dart';
import '../../../widgets/universal/mobile_elevated_button.dart';
import '../../../widgets/universal/report_table_heading.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/table_detail_text.dart';
import 'package:pdf/widgets.dart' as pw;

class TwoMobileReports extends StatefulWidget {
  const TwoMobileReports({super.key});

  @override
  State<TwoMobileReports> createState() => _TwoMobileReportsState();
}

class _TwoMobileReportsState extends State<TwoMobileReports> {

  PrintingInfo? printingInfo;

  final TextEditingController collectStartController = TextEditingController();
  final TextEditingController collectEndController = TextEditingController();

  DateTime collectStart = DateTime.now();
  DateTime collectEnd = DateTime.now();

  List<Map<String, dynamic>> dataList = [];
  late Stream<QuerySnapshot<Map<String, dynamic>>> collectStream;

  void initializeCollectData() {
    collectStream = collectData(collectStart, collectEnd);
  }

  Future<void> collectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: collectStart,
      firstDate: DateTime(2024, 6, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != collectStart) {
      setState(() {
        collectStart = picked;
        collectStartController.text = DateFormat('yyyy-MM-dd').format(collectStart);
        initializeCollectData();
      });
    }
  }
  Future<void> collectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: collectEnd,
      firstDate: DateTime(2024, 6, 1),
      lastDate: DateTime(3000, 1, 1),
    );
    if (picked != null && picked != collectEnd) {
      setState(() {
        collectEnd = picked;
        collectEndController.text = DateFormat('yyyy-MM-dd').format(collectEnd);
        initializeCollectData();
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> collectData(DateTime collectStartDate, DateTime collectEndDate) {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .where('time', isGreaterThanOrEqualTo: collectStartDate.millisecondsSinceEpoch)
        .where('time', isLessThanOrEqualTo: collectEndDate.millisecondsSinceEpoch)
        .snapshots();
  }

  String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMMM yyyy : HH:mm').format(date);
  }

  Future<Uint8List> generatePdfWithData(PdfPageFormat format, List<Map<String, dynamic>> dataList, DateTime startDate, DateTime endDate) async {
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final fontBold = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttf = pw.Font.ttf(fontData);
    final bold = pw.Font.ttf(fontBold);

    final doc = pw.Document(title: 'Smart Transit');
    final logoImage = pw.MemoryImage((await rootBundle.load("assets/pngs/logo-icon.png")).buffer.asUint8List());
    final pageTheme = await myPageTheme(format, ttf);
    Color backgroundHeader = const Color(0xFF16163F);
    PdfColor pdfBackgroundHeader = PdfColor.fromInt(backgroundHeader.value);
    Color textHeader = const Color(0xFFFDFCFF);
    PdfColor pdfTextHeader = PdfColor.fromInt(textHeader.value);

    final startDateString = "${startDate.toLocal()}".split(' ')[0]; // Format as needed
    final endDateString = "${endDate.toLocal()}".split(' ')[0]; // Format as needed

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                alignment: pw.Alignment.topCenter,
                logoImage,
                fit: pw.BoxFit.contain,
                width: 100,
              ),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('General', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Selected Start Date:', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                          pw.SizedBox(width: 5),
                          pw.Text(startDateString, style: pw.TextStyle(font: ttf, color: pdfBackgroundHeader))
                        ]
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Selected End Date:', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                          pw.SizedBox(width: 5),
                          pw.Text(endDateString, style: pw.TextStyle(font: ttf, color: pdfBackgroundHeader))
                        ]
                    ),
                  ]
              )
            ]
        ),
        footer: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Smart Transit', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
              pw.SizedBox(height: 5),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Email:', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                    pw.SizedBox(width: 5),
                    pw.Text('smartransit@gmail.com', style: pw.TextStyle(font: ttf, color: pdfBackgroundHeader))
                  ]
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Contact:', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                    pw.SizedBox(width: 5),
                    pw.Text('+232 88 043383', style: pw.TextStyle(font: ttf, color: pdfBackgroundHeader))
                  ]
              ),
            ]
        ),
        build: (context) => [
          pw.SizedBox(
              height: 20
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'No.',
              'Ticket ID',
              'Corridor',
              'Direction',
              'Date',
              'Logged By',
              'Status',
            ],
            data: [
              for (int i = 0; i < dataList.length; i++)
                [
                  (i + 1).toString(), // Row number
                  dataList[i]['ticket'],
                  dataList[i]['corridor'],
                  dataList[i]['direction'],
                  formatTimestamp(dataList[i]['time']),
                  dataList[i]['person'],
                  dataList[i]['status'],
                ],
            ],
            cellStyle: pw.TextStyle(font: ttf),
            headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, color: pdfTextHeader),
            cellAlignment: pw.Alignment.center,
            headerDecoration: pw.BoxDecoration(color: pdfBackgroundHeader),
            border: null,
          ),
        ],
      ),
    );

    return doc.save();
  }

  Future<void> init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    initializeCollectData();
  }

  @override
  void dispose() {
    collectStartController.dispose();
    collectEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction> [
      if(!kIsWeb) const PdfPreviewAction(
          icon: Icon(Icons.save),
          onPressed: saveAsFile
      )
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                title: AppBarHeading1(text: 'Reports'),
              )
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const AllText(),
                          const Gap(10),
                          MobileElevatedButton(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TwoMobileVerified()));},
                            icon: Icons.verified,
                            text: 'Verified',
                          ),
                          const Gap(10),
                          MobileElevatedButton(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TwoMobileUnverified()));},
                            icon: Icons.hourglass_empty,
                            text: 'Unverified',
                          ),
                          const Gap(10),
                          MobileElevatedButton(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TwoMobileIntegrity()));},
                            icon: Icons.safety_check,
                            text: 'Integrity',
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SubHeadingText(
                          text: 'Start Date'),
                      const Gap(5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context)
                            .size
                            .width * 0.9,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets
                              .only(
                              left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: collectStartController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    readOnly: true,
                                    onTap: () => collectStartDate(context),
                                  )
                              ),
                              Expanded(
                                  child: IconButton(
                                    onPressed: () => collectStartDate(context),
                                    icon: const Icon(
                                      FluentSystemIcons.ic_fluent_calendar_date_filled,
                                      color: blue,
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SubHeadingText(
                          text: 'End Date'),
                      const Gap(5),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context)
                            .size
                            .width * 0.9,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets
                              .only(
                              left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: collectEndController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    readOnly: true,
                                    onTap: () => collectEndDate(context),
                                  )
                              ),
                              Expanded(
                                  child: IconButton(
                                    onPressed: () => collectEndDate(context),
                                    icon: const Icon(
                                      FluentSystemIcons.ic_fluent_calendar_date_filled,
                                      color: blue,
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: collectStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitChasingDots(
                          color: primary,
                          size: 30,
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      dataList = snapshot.data?.docs.map((e) => e.data()).toList() ?? [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStateColor.resolveWith((states) => const Color(0xFF16163F)),
                                border: TableBorder.all(
                                  borderRadius: BorderRadius.circular(12),
                                  width: 1,
                                  color: const Color(0xFF16163F),
                                ),
                                columns: const [
                                  DataColumn(label: ReportTableHeading(text: 'No.'),),
                                  DataColumn(label: ReportTableHeading(text: 'Ticket ID'),),
                                  DataColumn(label: ReportTableHeading(text: 'Corridor'),),
                                  DataColumn(label: ReportTableHeading(text: 'Direction'),),
                                  DataColumn(label: ReportTableHeading(text: 'Date'),),
                                  DataColumn(label: ReportTableHeading(text: 'Logged By'),),
                                  DataColumn(label: ReportTableHeading(text: 'Status'),),
                                ],
                                rows: List.generate(dataList.length, (index) {
                                  final data = dataList[index];
                                  final count = index + 1;
                                  return DataRow(
                                    cells: [
                                      DataCell(TableDetailText(text: '$count')),
                                      DataCell(TableDetailText(text: data['ticket'])),
                                      DataCell(TableDetailText(text: data['corridor'])),
                                      DataCell(TableDetailText(text: data['direction'])),
                                      DataCell(TableDetailText(text: formatTimestamp(data['time']))),
                                      DataCell(TableDetailText(text: data['person'])),
                                      DataCell(TableDetailText(text: data['status'])),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            const Gap(20),
                            if (dataList.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MobileElevatedButton(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) {
                                              return Scaffold(
                                                body: NestedScrollView(
                                                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                                                      SliverAppBar(
                                                        floating: true,
                                                        backgroundColor: Colors.transparent,
                                                        automaticallyImplyLeading: true,
                                                        title: AppBarHeading1(text: 'Print'),
                                                      )
                                                    ],
                                                    body: PdfPreview(
                                                      maxPageWidth: 1000,
                                                      actions: actions,
                                                      build: (format) => generatePdfWithData(format, dataList, collectStart, collectEnd),
                                                    )
                                                ),
                                              );
                                            }
                                        ),
                                      );
                                    },
                                    text: 'Generate PDF',
                                    icon: FluentSystemIcons.ic_fluent_document_pdf_filled,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}