import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../constants/theme/mode_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../providers/mode_provider.dart';
import '../../screens/two_mobile_screens/two_mobile_dashboard/two_mobile_dashboard.dart';
import '../../screens/two_mobile_screens/two_mobile_scanners/two_mobile_scanners.dart';
import '../../widgets/mobile_widgets/menu_card_widget.dart';
import '../../widgets/universal/bottom_nav_bar_icon.dart';
import '../../widgets/universal/bottom_nav_bar_icon_container.dart';
import '../../widgets/universal/two_mobile_menu.dart';

class TwoMobileLayout extends StatefulWidget {
  const TwoMobileLayout({super.key});

  @override
  State<TwoMobileLayout> createState() => _TwoMobileLayoutState();
}

class _TwoMobileLayoutState extends State<TwoMobileLayout> {

  int currentIndex = 0;
  late PageController pageController;
  final controller = AdvancedDrawerController();
  late AuthController authController;


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
    authController = Get.find<AuthController>();
    authController.getUserData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);
    return AdvancedDrawer(
      controller: controller,
      drawer: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MenuCardWidget(role: authController.myUser.value.role.toString(),),
              TwoMobileMenu()
            ],
          ),
        ),
      ),
      backdropColor: modeProvider.lightModeEnable ? ModeTheme.background : ModeTheme.blackBackground,
      rtlOpening: false,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      childDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: const [
            TwoMobileDashboard(),
            TwoMobileScanners(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              bottom: 5,
              left: 10,
              right: 10
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              if (currentIndex == 0) BottomNavBarIconContainer(
                  icon: IconlyBold.home
              ) else IconButton(
                onPressed: () {
                  pageController.jumpToPage(0);
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: const BottomNavBarIcon(
                  icon: IconlyLight.home,
                ),
              ),
              if (currentIndex == 1) const BottomNavBarIconContainer(
                icon: Icons.qr_code_scanner,
              ) else IconButton(
                  onPressed: () {
                    pageController.jumpToPage(1);
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  icon: const BottomNavBarIcon(
                    icon: Icons.qr_code_rounded,
                  )
              ),
              IconButton(
                  onPressed: drawerControl,
                  icon: const BottomNavBarIcon(
                    icon: Ionicons.menu,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
  void drawerControl() {
    controller.showDrawer();
  }
}