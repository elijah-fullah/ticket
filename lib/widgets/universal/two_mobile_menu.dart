import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors/colors.dart';
import '../../providers/mode_provider.dart';
import '../../screens/mobile_login_screen/mobile_login_screen.dart';
import '../../screens/two_mobile_screens/two_mobile_logs/two_mobile_logs.dart';
import '../../screens/two_mobile_screens/two_mobile_reports/two_mobile_reports.dart';
import '../universal/arrow_icon.dart';
import '../universal/divide.dart';
import '../universal/heading_2.dart';
import '../universal/logout_heading2.dart';
import '../universal/logout_icon.dart';
import '../universal/menu_icon.dart';

class TwoMobileMenu extends StatefulWidget {
  const TwoMobileMenu({
    super.key,
  });

  @override
  State<TwoMobileMenu> createState() => _TwoMobileMenuState();
}

class _TwoMobileMenuState extends State<TwoMobileMenu> {

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
                      builder: (context) => const TwoMobileReports()));
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
                      builder: (context) => const TwoMobileLogs()));
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
                onTap: (){},
                leading: const MenuIcon(
                    icon: Icons.settings
                ),
                title: const Heading2(
                    text: 'Settings'
                ),
                trailing: const ArrowIcon(),
              ),
              ListTile(
                onTap: (){
                  Provider.of<ModeProvider>(context, listen: false).changeMode();
                  print('print');
                },
                leading: const MenuIcon(
                    icon: Icons.dark_mode,
                ),
                title: const Heading2(
                    text: 'Appearance'
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