import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/divide.dart';
import '../../../widgets/universal/drop_down_text.dart';
import '../../../widgets/universal/drop_down_type_widget.dart';
import '../../../widgets/universal/sub_heading_text.dart';
import '../../../widgets/universal/web_dialog_icon.dart';
import '../../../widgets/universal/web_elevated_action_button.dart';
import '../../../widgets/universal/web_elevated_back_button.dart';
import '../../../widgets/universal/web_heading_1.dart';

class SuperWebEditUser extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  const SuperWebEditUser({super.key, required this.data});

  @override
  State<SuperWebEditUser> createState() => _SuperWebEditUserState();
}

class _SuperWebEditUserState extends State<SuperWebEditUser> {

  DropdownMenuItem<String> buildMenuType(String type) => DropdownMenuItem<String>(
    value: type,
    child: DropDownText(text: type),
  );
  String? val;
  List<String> types = ['Level One', 'Level Two', 'Level Three'];
  bool isLoading = false;
  late String num;
  final formKey = GlobalKey<FormState>();
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
        timeInSecForIosWeb: 5,
        textColor: primary,
      );
      Navigator.pop(context);

    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error updating user detail.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        textColor: primary,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            children: [
              WebElevatedBackButton()
            ],
          ),
          const WebDialogIcon(icon: FluentSystemIcons.ic_fluent_person_accounts_filled),
          const Gap(5),
          WebHeading1(text: widget.data.data()['code']),
          const Divide(),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'User Type'),
                  const Gap(5),
                  DropDownTypeWidget(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'First Name'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'Last Name'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
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
            ],
          ),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'Email'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SubHeadingText(text: 'Phone'),
                  const Gap(5),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 4,
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
            ],
          ),
          const Gap(50),
          WebElevatedActionButton(
              onTap: isLoading ? null : () {
                if (formKey.currentState!.validate()) {
                  updateUser(context, widget.data);
                }
              },
              text: isLoading ? 'Updating' : 'Update',
              color: isLoading ? Colors.grey : blue
          ),
        ],
      ),
    );
  }
}
