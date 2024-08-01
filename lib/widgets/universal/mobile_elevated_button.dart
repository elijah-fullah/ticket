import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/colors/colors.dart';
import 'elevated_button_icon.dart';
import 'elevated_button_text.dart';

class MobileElevatedButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String text;
  const MobileElevatedButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            elevation: 2
        ),
        child: Row(
          children: [
            ElevatedButtonIcon(icon: icon),
            const Gap(5),
            ElevatedButtonText(text: text)
          ],
        )
    );
  }
}
