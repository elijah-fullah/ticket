import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class MenuIcon extends StatelessWidget {
  final IconData icon;
  const MenuIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: primary,
      size: 25,
    );
  }
}
