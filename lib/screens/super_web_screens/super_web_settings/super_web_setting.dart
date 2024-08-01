import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticket/screens/super_web_screens/super_web_settings/super_web_password.dart';
import 'package:ticket/screens/super_web_screens/super_web_settings/super_web_profile.dart';

import '../../../constants/colors/colors.dart';
import '../../../widgets/universal/tab_tab_pick_widget.dart';

class SuperWebSetting extends StatefulWidget {
  const SuperWebSetting({super.key});

  @override
  State<SuperWebSetting> createState() => _SuperWebSettingState();
}

class _SuperWebSettingState extends State<SuperWebSetting> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController controller = TabController(
        length: 2,
        vsync: this
    );
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: primary,
              ),
              child: Image.asset(
                  'assets/pngs/logo.jpg',
                  fit: BoxFit.cover
              ),
            ),
            Positioned(
              left: 20,
              bottom: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.asset(
                    'assets/icons/pro.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gap(50),
        TabBar(
            controller: controller,
            isScrollable: true,
            labelColor: primary,
            labelStyle: GoogleFonts.akayaTelivigala(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            indicatorColor: primary,
            unselectedLabelColor: blue,
            tabs: const [
              TabTabPickWidget(
                  name: 'Profile'
              ),
              TabTabPickWidget(
                  name: 'Password'
              ),
            ]
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          width: double.infinity,
          child: TabBarView(
              controller: controller,
              children:  const [
                SuperWebProfile(),
                SuperWebPassword(),
              ]
          ),
        ),
      ],
    );
  }
}
