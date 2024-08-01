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
import '../../../constants/colors/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/universal/appbar_heading_1.dart';
import '../../../widgets/universal/mobile_elevated_button.dart';
import '../../../widgets/universal/report_table_heading.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/table_detail_text.dart';
import 'package:pdf/widgets.dart' as pw;

class TwoMobileIntegrity extends StatefulWidget {
  const TwoMobileIntegrity({super.key});

  @override
  State<TwoMobileIntegrity> createState() => _TwoMobileIntegrityState();
}

class _TwoMobileIntegrityState extends State<TwoMobileIntegrity> {

  PrintingInfo? printingInfo;

  TextEditingController verifiedStartController = TextEditingController();
  TextEditingController verifiedEndController = TextEditingController();


  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  List<Map<String, dynamic>> dataList = [];
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? filteredStream;

  @override
  void initState() {
    super.initState();
    filteredStream = verifiedData();
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> verifiedData() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection("ticketList")
        .snapshots()
        .map((snapshot) => snapshot.docs.toList());
  }
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> filterData(DateTime collectStartDate, DateTime collectEndDate) {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection("ticketList")
        .snapshots()
        .map((snapshot) => snapshot.docs.where((doc) =>
    DateTime.fromMillisecondsSinceEpoch(doc['time']).isAfter(collectStartDate) &&
        DateTime.fromMillisecondsSinceEpoch(doc['time']).isBefore(collectEndDate)
    ).toList());
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

    final startDateString = "${startDate.toLocal()}".split(' ')[0];
    final endDateString = "${endDate.toLocal()}".split(' ')[0];

    int totalTickets = dataList.length;
    int verifiedTicketsCount = dataList.where((doc) => doc['status'] == 'Verified').length;
    double verifiedPercentage = (verifiedTicketsCount / totalTickets) * 100;

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
                    pw.Text('Data Integrity', style: pw.TextStyle(font: bold, fontWeight: pw.FontWeight.bold, color: pdfBackgroundHeader)),
                    pw.SizedBox(height: 10),
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
          pw.SizedBox(
              height: 50
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              '%',
              'Selected Start Date',
              'Selected End Date',
            ],
            data: [
              [
                '${verifiedPercentage.toStringAsFixed(2)}%',
                formatDate(selectedStartDate),
                formatDate(selectedEndDate),
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

  void onDateSelected() {
    final DateTime endDate = selectedEndDate;
    setState(() {
      filteredStream = filterData(selectedStartDate, endDate);
      if (kDebugMode) {
        print('Filtering data from $selectedStartDate to $endDate');
      }
    });
  }

  Future<void> verifiedStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        verifiedStartController.text = DateFormat('yyyy-MM-dd').format(picked);
        if (kDebugMode) {
          print('Selected start date: $selectedStartDate');
        }
        onDateSelected();
      });
    } else {
      if (kDebugMode) {
        print('No start date picked');
      }
    }
  }
  Future<void> verifiedEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
        verifiedEndController.text = DateFormat('yyyy-MM-dd').format(picked);
        if (kDebugMode) {
          print('Selected end date: $selectedEndDate');
        }
        onDateSelected();
      });
    } else {
      if (kDebugMode) {
        print('No end date picked');
      }
    }
  }

  String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMMM yyyy : HH:mm').format(date);
  }
  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  void dispose() {
    verifiedStartController.dispose();
    verifiedEndController.dispose();
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
                title: AppBarHeading1(text: 'Integrity'),
              )
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
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
                                    controller: verifiedStartController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    readOnly: true,
                                    onTap: () => verifiedStartDate(context),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select start date";
                                      }
                                      return null;
                                    },
                                  )
                              ),
                              Expanded(
                                  child: IconButton(
                                    onPressed: () => verifiedStartDate(context),
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
                                    controller: verifiedEndController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    readOnly: true,
                                    onTap: () => verifiedEndDate(context),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select end date";
                                      }
                                      return null;
                                    },
                                  )
                              ),
                              Expanded(
                                  child: IconButton(
                                    onPressed: () => verifiedEndDate(context),
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
                  StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    stream: filteredStream,
                    builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitChasingDots(
                          color: primary,
                          size: 30,
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      List<Map<String, dynamic>> dataList = snapshot.data?.map((doc) => doc.data()).toList() ?? [];
                      int totalTickets = dataList.length;
                      int verifiedTicketsCount = dataList.where((doc) => doc['status'] == 'Verified').length;
                      double verifiedPercentage = (verifiedTicketsCount / totalTickets) * 100;

                      return Column(
                        children: [
                          Visibility(
                            visible: false,
                            child: DataTable(
                              headingRowColor: WidgetStateColor.resolveWith((states) => const Color(0xFF16163F)),
                              border: TableBorder.all(
                                borderRadius: BorderRadius.circular(12),
                                width: 1,
                                color: const Color(0xFF16163F),
                              ),
                              columns: const [
                                DataColumn(label: ReportTableHeading(text: 'No.')),
                                DataColumn(label: ReportTableHeading(text: 'Ticket ID')),
                                DataColumn(label: ReportTableHeading(text: 'Corridor')),
                                DataColumn(label: ReportTableHeading(text: 'Direction')),
                                DataColumn(label: ReportTableHeading(text: 'Date')),
                                DataColumn(label: ReportTableHeading(text: 'Logged By')),
                                DataColumn(label: ReportTableHeading(text: 'Status')),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                  headingRowColor: WidgetStateColor.resolveWith((states) => const Color(0xFF16163F)),
                                  border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(12),
                                    width: 1,
                                    color: const Color(0xFF16163F),
                                  ),
                                  columns: const [
                                    DataColumn(label: ReportTableHeading(text: '%'),),
                                    DataColumn(label: ReportTableHeading(text: 'Selected Start Date'),),
                                    DataColumn(label: ReportTableHeading(text: 'Selected End Date'),),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: [
                                        DataCell(TableDetailText(text: '${verifiedPercentage.toStringAsFixed(2)}%')),
                                        DataCell(TableDetailText(text: formatDate(selectedStartDate))),
                                        DataCell(TableDetailText(text: formatDate(selectedEndDate))),
                                      ],
                                    )]
                              ),
                            ),
                          ),
                          if (dataList.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: MobileElevatedButton(
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
                                                      build: (format) => generatePdfWithData(format, dataList, selectedStartDate, selectedEndDate),
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
                                ),
                              ],
                            ),
                        ],
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