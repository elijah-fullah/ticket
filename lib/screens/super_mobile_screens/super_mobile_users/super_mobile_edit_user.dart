import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/appbar_heading_1.dart';
import '../../../widgets/universal/drop_down_text.dart';
import '../../../widgets/universal/mobile_drop_down_type_widget.dart';
import '../../../widgets/universal/mobile_elevated_action_button.dart';
import '../../../widgets/universal/sub_heading_text.dart';

class SuperMobileEditUser extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  const SuperMobileEditUser({super.key, required this.data});

  @override
  State<SuperMobileEditUser> createState() => _SuperMobileEditUserState();
}

class _SuperMobileEditUserState extends State<SuperMobileEditUser> {

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem<String>(
    value: type,
    child: DropDownText(text: type),
  );
  String? val;
  List<String> types = ['Level One', 'Level Two', 'Level Three'];
  bool isLoading = false;
  late String num;
  final formKey = GlobalKey<FormState>();
  // Get current month in "Month Year" format
  String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  final TextEditingController updateFirstController = TextEditingController();
  final TextEditingController updateLastController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateFirstController.text = widget.data.data()['firstName'];
    updateLastController.text = widget.data.data()['lastName'];
  }

  @override
  void dispose() {
    updateFirstController.dispose();
    updateLastController.dispose();
    super.dispose();
  }

  Future<void> updateUser(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) async {
    CollectionReference reference = FirebaseFirestore.instance.collection('users').doc(currentMonth).collection('userList');

    setState(() {
      isLoading = true;
    });

    try {

      await reference.doc(widget.data.id).update({
        'type': val!,
        'firstName': updateFirstController.text,
        'lastName': updateLastController.text,
      });

      Fluttertoast.showToast(
        msg: 'User details updated successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: primary,
      );
      Navigator.pop(context);

    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating user detail.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                title: AppBarHeading1(text: widget.data.data()['code']),
              )
            ],
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubHeadingText(text: 'User Type'),
                        const Gap(5),
                        MobileDropDownTypeWidget(
                            val: val,
                            item: types.map<DropdownMenuItem<String>>(buildMenuType).toList(),
                            onChange: (newVal) {
                              setState(() {
                                val = newVal;
                              });
                            },
                            type: widget.data.data()['role']
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubHeadingText(text: 'First Name'),
                        const Gap(5),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: updateFirstController,
                              enabled: isLoading ? false : true,
                              decoration: InputDecoration(
                                hintText: widget.data.data()['firstName'],
                                hintStyle: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.bold)),
                                border: InputBorder.none,
                                focusColor: blue,
                                fillColor: blue,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubHeadingText(text: 'Last Name'),
                        const Gap(5),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: updateLastController,
                              enabled: isLoading ? false : true,
                              decoration: InputDecoration(
                                hintText: widget.data.data()['lastName'],
                                hintStyle: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.bold)),
                                border: InputBorder.none,
                                focusColor: blue,
                                fillColor: blue,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubHeadingText(text: 'Email'),
                        const Gap(5),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Row(
                              children: [
                                DropDownText(text: widget.data.data()['email'])
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SubHeadingText(text: 'Phone'),
                        const Gap(5),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Row(
                              children: [
                                DropDownText(
                                    text: widget.data.data()['contact'])
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(50),
                    MobileElevatedActionButton(
                        onTap: isLoading ? null : () {
                          if (formKey.currentState!.validate()) {
                            updateUser(context, widget.data);
                          }
                        },
                        text: isLoading ? 'Updating' : 'Update',
                        color: isLoading ? Colors.grey : blue
                    ),
                    const Gap(50),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
