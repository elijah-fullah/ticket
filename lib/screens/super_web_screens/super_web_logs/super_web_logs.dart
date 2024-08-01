// ignore_for_file: use_build_context_synchronously

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:ticket/screens/super_web_screens/super_web_logs/super_web_add_logs.dart';
import 'package:ticket/widgets/universal/log_action.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/heading_3.dart';
import '../../../widgets/universal/table_detail_text.dart';
import '../../../widgets/universal/table_heading.dart';
import '../../../widgets/universal/view_detail_text.dart';
import '../../../widgets/universal/view_divide.dart';
import '../../../widgets/universal/view_heading.dart';
import '../../../widgets/universal/web_dialog_icon.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_elevated_button.dart';
import '../../../widgets/universal/web_heading_1.dart';
import '../../../widgets/universal/web_main_icon.dart';

class SuperWebLogs extends StatefulWidget {
  const SuperWebLogs({super.key});

  @override
  State<SuperWebLogs> createState() => _SuperWebLogsState();
}

class _SuperWebLogsState extends State<SuperWebLogs> {

  final rowsPerPageOptions = [10, 20, 30];
  int rowsPerPage = 10;
  int currentPage = 0;

  final TextEditingController searchController = TextEditingController();
  String filterCriteria = 'All';
  List<String> filterOptions = ['All', 'Activity', 'Performed By'];
  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get logStream {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('logs')
        .doc(currentMonth)
        .collection('logList')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  int counter = 1;
  String search = "";
  bool showSuffixIcon = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        showSuffixIcon = !searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const WebHeading1(text: 'Logs'),
              WebElevatedButton(
                onTap: () {
                  Get.to(() => const SuperWebAddLogs(), id: 4);
                },
                icon: FluentSystemIcons.ic_fluent_send_logging_filled,
                text: 'Log Ticket',
              )
            ],
          ),
          const Gap(5),
          const Row(
            children: [
              Heading3(text: 'Super Admin'),
              Gap(5),
              WebMainIcon(icon: FluentSystemIcons.ic_fluent_send_logging_filled)
            ],
          ),
          const Gap(20),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 800,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WebHeading1(text: 'Recent Update'),
                      Row(
                        children: [
                          AnimSearchBar(
                            width: MediaQuery.of(context).size.width * 0.3,
                            textController: searchController,
                            animationDurationInMilli: 300,
                            closeSearchOnSuffixTap: true,
                            helpText: 'search logs...',
                            searchIconColor: blue,
                            style: TextStyle(color: textColor),
                            onSuffixTap: () {
                              setState(() {
                                searchController.clear();
                              });
                            },
                            onSubmitted: (val) {
                              setState(() {
                                search = val.trim().toLowerCase();
                              });
                            },
                          ),
                          const Gap(20),
                          DropdownButton<String>(
                            value: filterCriteria,
                            icon: const Icon(IconlyBold.filter),
                            iconSize: 24,
                            style: const TextStyle(color: blue),
                            onChanged: (String? newValue) {
                              setState(() {
                                filterCriteria = newValue!;
                              });
                            },
                            items: filterOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    stream: logStream,
                    builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SpinKitChasingDots(
                          color: primary,
                          size: 30,
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      final List<QueryDocumentSnapshot<Map<String, dynamic>>> storeDocs = snapshot.data ?? [];

                      List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs = storeDocs;

                      if (searchController.text.isNotEmpty || filterCriteria != 'All') {
                        filteredDocs = storeDocs.where((document) {
                          final lowerSearch = searchController.text.toLowerCase();
                          switch (filterCriteria) {
                            case 'Activity':
                              return document['status'].toString().toLowerCase().contains(lowerSearch);
                            case 'Performed By':
                              return document['person'].toString().toLowerCase().contains(lowerSearch);
                            default:
                              return document['date'].toString().toLowerCase().contains(lowerSearch) ||
                                  document['time'].toString().toLowerCase().contains(lowerSearch) ||
                                  document['status'].toString().toLowerCase().contains(lowerSearch) ||
                                  document['person'].toString().toLowerCase().contains(lowerSearch);
                          }
                        }).toList();
                      }

                      return PaginatedDataTable(
                        rowsPerPage: rowsPerPage,
                        availableRowsPerPage: rowsPerPageOptions,
                        showCheckboxColumn: true,
                        onPageChanged: (int pageIndex) {
                          setState(() {
                            currentPage = pageIndex;
                          });
                        },
                        arrowHeadColor: blue,
                        columns: const [
                          DataColumn(label: TableHeading(text: 'Date')),
                          DataColumn(label: TableHeading(text: 'Time')),
                          DataColumn(label: TableHeading(text: 'Activity')),
                          DataColumn(label: TableHeading(text: 'Performed By')),
                          DataColumn(label: TableHeading(text: 'Action')),
                        ],
                        source: LogData(filteredDocs, context),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LogData extends DataTableSource {
  LogData(this.dataList, this.context);

  final BuildContext context;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList;
  String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMMM yyyy').format(date);
  }

  String formatTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(date);
  }


  void view(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                color: background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          WebDialogIcon(icon: FluentSystemIcons.ic_fluent_send_logging_filled),
                          Gap(5),
                          WebHeading1(text: 'Details',),
                          Divide(),
                          Gap(20),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ViewHeading(text: 'Date:',),
                              ViewDetailText(text: formatDate(data.data()['date'])),
                            ],
                          ),
                          const ViewDivide(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ViewHeading(text: 'Time:',),
                              ViewDetailText(text: formatTime(data.data()['time'])),
                            ],
                          ),
                          const ViewDivide(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ViewHeading(text: 'Activity:',),
                              ViewDetailText(text: data.data()['status']),
                            ],
                          ),
                          const ViewDivide(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ViewHeading(text: 'Performed By:',),
                              ViewDetailText(text: data.data()['person']),
                            ],
                          ),
                        ],
                      ),
                      const Gap(20),
                      WebElevatedActionButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Close',
                          color: red),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  DataRow getRow(int index) {
    final data = dataList[index];
    final status = data['status'] ?? 'Pending';

    Icon statusIcon;
    Color statusColor;
    bool isClickable;

    switch (status) {
      case 'Unverified':
        statusIcon = const Icon(null);
        statusColor = Colors.transparent;
        isClickable = false;
        break;
      case 'Pending':
        statusIcon = const Icon(Icons.remove_red_eye_rounded, color: blue);
        statusColor = blue;
        isClickable = true;
        break;
      case 'Verified':
        statusIcon = const Icon(null);
        statusColor = Colors.transparent;
        isClickable = false;
        break;
      default:
        statusIcon = Icon(Icons.block, color: red);
        statusColor = red;
        isClickable = false;
        break;
    }

    return DataRow(
      cells: [
        DataCell(TableDetailText(text: formatDate(data.data()['date']))),
        DataCell(TableDetailText(text: formatTime(data.data()['time']))),
        DataCell(TableDetailText(text: data['status'] ?? '',)),
        DataCell(TableDetailText(text: data['person'] ?? '',)),
        DataCell(isClickable ? LogAction(status: () => view(context, data), color: statusColor, icon: statusIcon) : statusIcon)
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataList.length;

  @override
  int get selectedRowCount => 0;
}