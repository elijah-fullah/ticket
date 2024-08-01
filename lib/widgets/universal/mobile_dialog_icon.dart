import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class MobileDialogIcon extends StatelessWidget {
  final IconData icon;
  const MobileDialogIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: blue,
      size: 50,
    );
  }
}
