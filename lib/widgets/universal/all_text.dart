import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/colors/colors.dart';
import 'elevated_button_icon.dart';
import 'elevated_button_text.dart';

class AllText extends StatelessWidget {
  const AllText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primary
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              ElevatedButtonIcon(icon: FluentSystemIcons.ic_fluent_select_all_filled),
              Gap(5),
              ElevatedButtonText(text: 'All')
            ],
          ),
        )
    );
  }
}
