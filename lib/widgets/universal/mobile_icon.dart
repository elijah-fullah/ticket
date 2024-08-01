import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class MobileIcon extends StatelessWidget {
  final IconData icon;
  const MobileIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: background,
      size: 20,
    );
  }
}
