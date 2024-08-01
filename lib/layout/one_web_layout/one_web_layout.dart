import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors/colors.dart';
import '../../controllers/one_web_sidebar_controller/one_web_sidebar_controller.dart';
import '../../screens/web_login_screen/web_login_screen.dart';
import '../../widgets/universal/divide.dart';
import '../../widgets/universal/logout_heading2.dart';
import '../../widgets/universal/logout_icon.dart';
import '../../widgets/universal/menu_icon.dart';
import '../../widgets/universal/sidebar_card_widget.dart';
import '../../widgets/universal/web_main_icon.dart';

class OneWebLayout extends StatefulWidget {
  const OneWebLayout({
    super.key,
  });

  @override
  State<OneWebLayout> createState() => _OneWebLayoutState();
}

class _OneWebLayoutState extends State<OneWebLayout> {
  final OneWebSidebarController oneSidebarController = Get.put(OneWebSidebarController());
  late SharedPreferences sharedPreferences;
  Future<void> logout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WebLoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Obx(() {
            final isExpanded = oneSidebarController.isExpanded.value;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isExpanded ? 200 : 70,
              color: background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SidebarCardWidget(
                    icon: Ionicons.bus,
                    waka: isExpanded ? 'Smart' : '',
                    fine: isExpanded ? 'Transit' : '',
                  ),
                  Column(
                    children: [
                      buildListTile(0, Icons.space_dashboard, isExpanded ? 'Dashboard' : ''),
                      buildListTile(1, FluentSystemIcons.ic_fluent_ticket_filled, isExpanded ? 'Tickets' : ''),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divide(),
                      ),
                      buildListTile(2, Icons.settings, isExpanded ? 'Settings' : ''),
                      ListTile(
                        onTap: () {
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
                        title: isExpanded ? const LogoutHeading2() : null,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          Expanded(
            flex: 6,
            child: Container(
              color: grey,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: background,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                oneSidebarController.isExpanded.toggle();
                              },
                              icon: const WebMainIcon(icon: Icons.menu),
                            ),
                            Row(
                              children: [
                                const MenuIcon(icon: IconlyBold.notification),
                                const Gap(10),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      'assets/icons/pro.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: SingleChildScrollView(
                          child: Obx(() {
                            return Navigator(
                              key: Get.nestedKey(oneSidebarController.index.value), // Use nestedKey here
                              onGenerateRoute: (settings) {
                                return MaterialPageRoute(
                                  builder: (context) => oneSidebarController.pages[oneSidebarController.index.value],
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(int index, IconData icon, String text) {
    return Obx(() {
      final isSelected = oneSidebarController.index.value == index;
      final isExpanded = oneSidebarController.isExpanded.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? blue : background,
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListTile(
            onTap: () => oneSidebarController.index.value = index,
            selected: isSelected,
            leading: Icon(
                icon,
                size: 25,
                color: isSelected ? background : blue
            ),
            title: isExpanded ? AutoSizeText(
                text,
                maxLines: 2,
                maxFontSize: 18,
                minFontSize: 14,
                style: GoogleFonts.akayaTelivigala(
                  textStyle: TextStyle(
                      color: isSelected ? background : blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),)
            ) : null,
          ),
        ),
      );
    });
  }
}
