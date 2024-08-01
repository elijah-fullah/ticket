import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class ElevatedButtonIcon extends StatelessWidget {
  final IconData icon;
  const ElevatedButtonIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: background,
      size: 16,
    );
  }
}
