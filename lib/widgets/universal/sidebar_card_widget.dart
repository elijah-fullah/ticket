import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket/widgets/universal/title_text.dart';
import '../../constants/colors/colors.dart';
import 'divide.dart';

class SidebarCardWidget extends StatelessWidget {
  final IconData icon;
  final String waka;
  final String fine;
  const SidebarCardWidget({
    super.key,
    required this.icon,
    required this.waka,
    required this.fine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 20,
            bottom: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary,
                size: 25,
              ),
              const Gap(5),
              TitleText(
                smart: waka,
                transit: fine,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divide(),
        ),
      ],
    );
  }
}