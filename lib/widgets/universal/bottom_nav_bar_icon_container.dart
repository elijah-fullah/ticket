import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class BottomNavBarIconContainer extends StatelessWidget {
  final IconData icon;
  const BottomNavBarIconContainer({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
          color: primary.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Icon(
        icon,
        color: primary,
        size: 25,
      ),
    );
  }
}
