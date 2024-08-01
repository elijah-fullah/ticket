import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class ProfileIcon extends StatelessWidget {
  final IconData icon;
  const ProfileIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: textColor,
      size: 25,
    );
  }
}
