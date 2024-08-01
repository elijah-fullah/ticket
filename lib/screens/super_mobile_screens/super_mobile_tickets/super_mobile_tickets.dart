import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_tickets/super_mobile_add_ticket.dart';
import 'package:ticket/widgets/universal/appbar_heading_1.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/heading_3.dart';
import '../../../widgets/universal/mobile_dialog_icon.dart';
import '../../../widgets/universal/mobile_elevated_action_button.dart';
import '../../../widgets/universal/mobile_heading_1.dart';
import '../../../widgets/universal/mobile_icon.dart';
import '../../../widgets/universal/table_detail_text.dart';
import '../../../widgets/universal/table_heading.dart';
import '../../../widgets/universal/ticket_status.dart';
import '../../../widgets/universal/ticket_view.dart';
import '../../../widgets/universal/view_detail_text.dart';
import '../../../widgets/universal/view_divide.dart';
import '../../../widgets/universal/view_heading.dart';

class SuperMobileTickets extends StatefulWidget {
  const SuperMobileTickets({super.key});

  @override
  State<SuperMobileTickets> createState() => _SuperMobileTicketsState();
}

class _SuperMobileTicketsState extends State<SuperMobileTickets> {

  final rowsPerPageOptions = [10, 20, 30];
  int rowsPerPage = 10;
  int currentPage = 0;

  final TextEditingController searchController = TextEditingController();
  String filterCriteria = 'All';
  List<String> filterOptions = ['All', 'Ticket ID', 'East', 'West', 'Central-Bound', 'East-Bound', 'West-Bound', 'Verified', 'Users', 'Unverified', 'Pending'];

  String search = "";
  bool showSuffixIcon = false;

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get ticketStream {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<int> getToday() {
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
  Stream<int> getMonth() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(currentMonth)
        .collection('ticketList')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  Stream<int> getYear() {
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
                title: AppBarHeading1(text: 'Tickets'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SuperMobileAddTicket()));
                    },
                    icon: const Icon(FluentSystemIcons.ic_fluent_ticket_filled),
                  ),
                  Gap(10)
                ],
              )
            ],
            body: SingleChildScrollView(
              child: Column(
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
                            stream: getToday(),
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
                            stream: getMonth(),
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
                            stream: getYear(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimSearchBar(
                          width: MediaQuery.of(context).size.width * 0.6,
                          textController: searchController,
                          animationDurationInMilli: 300,
                          closeSearchOnSuffixTap: true,
                          helpText: 'search tickets...',
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
                  ),
                  StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    stream: ticketStream,
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
                            case 'Ticket ID':
                              return document['ticket'].toString().toLowerCase().contains(lowerSearch);
                            case 'East':
                              return document['corridor'].toString().toLowerCase() == 'east';
                            case 'West':
                              return document['corridor'].toString().toLowerCase() == 'west';
                            case 'Central-Bound':
                              return document['direction'].toString().toLowerCase() == 'central-bound';
                            case 'East-Bound':
                              return document['direction'].toString().toLowerCase() == 'east-bound';
                            case 'West-Bound':
                              return document['direction'].toString().toLowerCase() == 'west-bound';
                            case 'Verified':
                              return document['status'].toString().toLowerCase() == 'verified';
                            case 'Users':
                              return document['person'].toString().toLowerCase().contains(lowerSearch);
                            case 'Unverified':
                              return document['status'].toString().toLowerCase() == 'unverified';
                            case 'Pending':
                              return document['status'].toString().toLowerCase() == 'pending';
                            default:
                              return document['ticket'].toString().toLowerCase().contains(lowerSearch) ||
                                  document['corridor'].toString().toLowerCase().contains(lowerSearch) ||
                                  document['direction'].toString().toLowerCase().contains(lowerSearch) ||
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
                          DataColumn(label: Center(child: TableHeading(text: 'Ticket ID'))),
                          DataColumn(label: TableHeading(text: 'Corridor')),
                          DataColumn(label: TableHeading(text: 'Direction')),
                          DataColumn(label: TableHeading(text: 'Date')),
                          DataColumn(label: TableHeading(text: 'Logged By')),
                          DataColumn(label: TableHeading(text: 'Status')),
                          DataColumn(label: TableHeading(text: 'Action')),
                        ],
                        source: MyData(filteredDocs, context),
                      );
                    },
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  MyData(this.dataList, this.context);
  final BuildContext context;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList;
  String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('d MMMM yyyy : HH:mm').format(date);
  }

  void view(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
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
                        MobileDialogIcon(icon: FluentSystemIcons.ic_fluent_ticket_filled),
                        Gap(5),
                        MobileHeading1(text: 'Details'),
                        Divide(),
                        Gap(20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Ticket ID:',
                            ),
                            ViewDetailText(text: data.data()['ticket']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Corridor:',
                            ),
                            ViewDetailText(text: data.data()['corridor']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Direction:',
                            ),
                            ViewDetailText(text: data.data()['direction']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Logged By:',
                            ),
                            ViewDetailText(text: data.data()['person']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Status:',
                            ),
                            ViewDetailText(text: data.data()['status']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(
                              text: 'Date:',
                            ),
                            ViewDetailText(
                              text: formatTimestamp(data.data()['time']),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(20),
                    // Display the QR code
                    QrImageView(
                      data: 'ticket:${data.data()['ticket']}|code:${data.data()['code']}',
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const Gap(20),
                    MobileElevatedActionButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: 'Close',
                      color: red,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> updateStatus(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    CollectionReference ticketsReference = FirebaseFirestore.instance.collection('tickets').doc(currentMonth).collection('ticketList');
    CollectionReference logsReference = FirebaseFirestore.instance.collection('logs').doc(currentMonth).collection('logList');

    try {
      String ticketId = data['ticket'];

      QuerySnapshot ticketCheck = await ticketsReference
          .where('ticket', isEqualTo: ticketId)
          .get();

      QuerySnapshot logCheck = await logsReference
          .where('ticket', isEqualTo: ticketId)
          .get();

      if (ticketCheck.docs.isNotEmpty && logCheck.docs.isNotEmpty) {
        String newStatus = data['status'] == 'Pending' ? 'Verified' : data['status'];

        await ticketsReference.doc(ticketCheck.docs[0].id).update({
          'status': newStatus,
        });

        await logsReference.doc(logCheck.docs[0].id).update({
          'status': newStatus,
        });

        Fluttertoast.showToast(
          msg: 'Ticket status updated successfully!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: primary,
        );
      } else {

        Fluttertoast.showToast(
          msg: 'Ticket not found in both collections or does not meet conditions.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating ticket status: $e.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: red,
      );
    }
  }

  @override
  DataRow getRow(int index) {
    final data = dataList[index];
    final status = data['status'] ?? 'Unverified';

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
        statusIcon = const Icon(Icons.pending, color: Colors.orange);
        statusColor = Colors.orange;
        isClickable = true;
        break;
      case 'Verified':
        statusIcon = const Icon(Icons.verified, color: primary);
        statusColor = primary;
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
        DataCell(TableDetailText(text: data['ticket'] ?? '',)),
        DataCell(TableDetailText(text: data['corridor'] ?? '',)),
        DataCell(TableDetailText(text: data['direction'] ?? '',)),
        DataCell(TableDetailText(text: formatTimestamp(data.data()['time']))),
        DataCell(TableDetailText(text: data['person'] ?? '',)),
        DataCell(TableDetailText(text: data['status'] ?? '',)),
        DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TicketView(view: () {view(context, data);}),
                isClickable ? TicketStatus(status: () => updateStatus(context, data), color: statusColor, icon: statusIcon) : statusIcon,
              ],
            )
        ),
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