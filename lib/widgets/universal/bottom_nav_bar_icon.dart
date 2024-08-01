import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class BottomNavBarIcon extends StatelessWidget {
  final IconData icon;
  const BottomNavBarIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: primary,
      size: 30,
    );
  }
}
