import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_dashboard/super_mobile_dashboard.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_logs/super_mobile_logs.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_reports/super_mobile_reports.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_tickets/super_mobile_tickets.dart';
import 'package:ticket/screens/super_mobile_screens/super_mobile_users/super_mobile_users.dart';
import '../../constants/colors/colors.dart';
import '../../screens/mobile_login_screen/mobile_login_screen.dart';
import '../universal/arrow_icon.dart';
import '../universal/divide.dart';
import '../universal/heading_2.dart';
import '../universal/logout_heading2.dart';
import '../universal/logout_icon.dart';
import '../universal/menu_icon.dart';

class SuperMobileMenu extends StatefulWidget {
  const SuperMobileMenu({
    super.key,
  });

  @override
  State<SuperMobileMenu> createState() => _SuperMobileMenuState();
}

class _SuperMobileMenuState extends State<SuperMobileMenu> {

  late SharedPreferences sharedPreferences;
  Future<void> logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MobileLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 30
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 20
                ),
                child: Divide(),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SuperMobileUsers()));
                },
                leading: const MenuIcon(
                    icon: Icons.person
                ),
                title: const Heading2(
                    text: 'Users'
                ),
                trailing: const ArrowIcon(),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SuperMobileTickets()));
                },
                leading: const MenuIcon(
                    icon: FluentSystemIcons.ic_fluent_ticket_filled
                ),
                title: const Heading2(
                    text: 'Tickets'
                ),
                trailing: const ArrowIcon(),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SuperMobileReports()));
                },
                leading: const MenuIcon(
                    icon: Icons.report
                ),
                title: const Heading2(
                    text: 'Reports'
                ),
                trailing: const ArrowIcon(),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SuperMobileLogs()));
                },
                leading: const MenuIcon(
                    icon: FluentSystemIcons.ic_fluent_send_logging_filled
                ),
                title: const Heading2(
                    text: 'Logs'
                ),
                trailing: const ArrowIcon(),
              ),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 20
                ),
                child: Divide(),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SuperMobileDashboard()));
                },
                leading: const MenuIcon(
                    icon: Icons.settings
                ),
                title: const Heading2(
                    text: 'Settings'
                ),
                trailing: const ArrowIcon(),
              ),
              ListTile(
                onTap: (){},
                leading: const MenuIcon(
                    icon: Icons.help
                ),
                title: const Heading2(
                    text: 'Help'
                ),
                trailing: const ArrowIcon(),
              ),
            ],
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 20
                ),
                child: Divide(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListTile(
                  onTap: (){
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.topSlide,
                        showCloseIcon: true,
                        title: 'Logout Alert',
                        dialogBorderRadius: BorderRadius.circular(20),
                        dismissOnBackKeyPress: true,
                        dismissOnTouchOutside: true,
                        desc: 'Sign in required after signing out.',
                        btnOkOnPress: logout,
                        btnOkColor: primary
                    ).show();
                  },
                  leading: const LogoutIcon(),
                  title: const LogoutHeading2(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}