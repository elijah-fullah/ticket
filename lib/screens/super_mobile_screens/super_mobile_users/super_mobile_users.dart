import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_users/super_mobile_add_user.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_users/super_mobile_edit_user.dart';
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
import '../../../widgets/universal/user_action.dart';
import '../../../widgets/universal/view_detail_text.dart';
import '../../../widgets/universal/view_divide.dart';
import '../../../widgets/universal/view_heading.dart';

class SuperMobileUsers extends StatefulWidget {
  const SuperMobileUsers({super.key});

  @override
  State<SuperMobileUsers> createState() => _SuperMobileUsersState();
}

class _SuperMobileUsersState extends State<SuperMobileUsers> {

  final rowsPerPageOptions = [10, 20, 30];
  int rowsPerPage = 10;
  int currentPage = 0;
  final TextEditingController searchController = TextEditingController();
  int counter = 1;
  String search = "";
  bool showSuffixIcon = false;
  List<String> storage = [];

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> get usersStream {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .where('role', isNotEqualTo: 'Super')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<int> getOne() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .snapshots()
        .map((snapshot) =>
    snapshot.docs.where((doc) => doc.data()['role'] == 'Level One').length);
  }
  Stream<int> getTwo() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .snapshots()
        .map((snapshot) =>
    snapshot.docs.where((doc) => doc.data()['role'] == 'Level Two').length);
  }
  Stream<int> getThree() {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentMonth)
        .collection('userList')
        .snapshots()
        .map((snapshot) =>
    snapshot.docs.where((doc) => doc.data()['role'] == 'Level Three').length);
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
                title: AppBarHeading1(text: 'Users'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SuperMobileAddUser()));
                    },
                    icon: const Icon(IconlyBold.add_user),
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
                            stream: getOne(),
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
                                    Heading3(text: 'Level One')
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MobileHeading1(text: snapshot.data.toString()),
                                    const Heading3(text: 'Level One')
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
                              child: MobileIcon(icon: Icons.looks_one),
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
                            stream: getTwo(),
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
                                    Heading3(text: 'Level Two')
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MobileHeading1(text: snapshot.data.toString()),
                                    const Heading3(text: 'Level Two')
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
                              child: MobileIcon(icon: Icons.looks_two),
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
                            stream: getThree(),
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
                                    Heading3(text: 'Level Three')
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MobileHeading1(text: snapshot.data.toString()),
                                    const Heading3(text: 'Level Three')
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
                              child: MobileIcon(icon: Icons.looks_3),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimSearchBar(
                          width: MediaQuery.of(context).size.width * 0.8,
                          textController: searchController,
                          animationDurationInMilli: 300,
                          closeSearchOnSuffixTap: true,
                          helpText: 'search users...',
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
                      ],
                    ),
                  ),
                  StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(stream: usersStream, builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>>snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SpinKitChasingDots(
                        color: primary,
                        size: 30,
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Something went wrong'));
                    }

                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    storeDocs = snapshot.data ?? [];

                    if (searchController.text.isEmpty) {
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
                        columns: [
                          DataColumn(label: Center(child: TableHeading(text: 'ID'.toUpperCase()))),
                          const DataColumn(label: TableHeading(text: 'Full Name')),
                          const DataColumn(label: TableHeading(text: 'Phone No.')),
                          const DataColumn(label: TableHeading(text: 'Email')),
                          const DataColumn(label: TableHeading(text: 'Role')),
                          const DataColumn(label: TableHeading(text: 'Action')),
                        ],
                        source: MyData(storeDocs, context),
                      );
                    } else {
                      final dataList = storeDocs.where((document) => document['code'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                          document['firstName'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                          document['lastName'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                          document['phone'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                          document['email'].toString().toLowerCase().contains(searchController.text.toLowerCase())).toList();

                      return PaginatedDataTable(
                        rowsPerPage: 10,
                        columns: [
                          DataColumn(label: Center(child: TableHeading(text: 'ID'.toUpperCase()))),
                          const DataColumn(label: TableHeading(text: 'Full Name')),
                          const DataColumn(label: TableHeading(text: 'Phone No.')),
                          const DataColumn(label: TableHeading(text: 'Email')),
                          const DataColumn(label: TableHeading(text: 'Role')),
                          const DataColumn(label: TableHeading(text: 'Action')),
                        ],
                        source: MyData(dataList, context),
                      );
                    }
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

class MyData extends DataTableSource {
  MyData(this.dataList, this.context);
  final BuildContext context;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList;

  String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  void view(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        MobileDialogIcon(icon: IconlyBold.user_2),
                        Gap(5),
                        MobileHeading1(
                          text: 'Details',
                        ),
                        Divide(),
                        Gap(20),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ViewHeading(text: 'id:'.toUpperCase(),),
                            ViewDetailText(text: data.data()['code']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(text: 'Full Name:',),
                            ViewDetailText(text: '${data.data()['firstName'] ?? ''} ${data.data()['lastName'] ?? ''}'),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(text: 'Phone:',),
                            ViewDetailText(text: data.data()['contact']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(text: 'Email:',),
                            ViewDetailText(text: data.data()['email']),
                          ],
                        ),
                        const ViewDivide(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const ViewHeading(text: 'Role:',),
                            ViewDetailText(text: data.data()['role']),
                          ],
                        ),
                      ],
                    ),
                    const Gap(80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MobileElevatedActionButton(onTap: () {Navigator.of(context).pop();}, text: 'Close', color: red),
                        MobileElevatedActionButton(onTap: () {}, text: 'Block', color: blue),
                      ],
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
          ),
        );
      });
  }

  Future<void> updateStatus(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    CollectionReference reference = FirebaseFirestore.instance.collection('users').doc(currentMonth).collection('userList');

    try {
      String newStatus = data['status'] == 'Active' ? 'Block' : 'Active';

      await reference.doc(data.id).update({
        'status': newStatus,
      });

      Fluttertoast.showToast(
        msg: 'User status updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: primary,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating user status.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: primary,
      );
    }
  }

  @override
  DataRow getRow(int index) {
    final data = dataList[index];
    final status = data['status'] ?? 'Active';
    final Icon statusIcon = (status == 'Active' ? const Icon(Icons.check_circle) : const Icon(Icons.block));
    final Color statusColor = status == 'Active' ? blue : red;

    return DataRow(
      cells: [
        DataCell(TableDetailText(text: data['code'] ?? '',)),
        DataCell(TableDetailText(text: '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',),),
        DataCell(TableDetailText(text: data['contact'] ?? '',)),
        DataCell(TableDetailText(text: data['email'] ?? '',)),
        DataCell(TableDetailText(text: data['role'] ?? '',)),
        DataCell(
          UserAction(
            view: () {view(context, data);},
            edit: () { Navigator.push(context, MaterialPageRoute(builder: (context) => SuperMobileEditUser(data: data)));},
            status: () {updateStatus(context, data);},
            color: statusColor,
            icon: statusIcon,
          ),
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