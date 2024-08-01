import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class WebIcon extends StatelessWidget {
  final IconData icon;
  const WebIcon({
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
