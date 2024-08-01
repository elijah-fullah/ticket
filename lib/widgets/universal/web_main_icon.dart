import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class WebMainIcon extends StatelessWidget {
  final IconData icon;
  const WebMainIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: blue,
      size: 25,
    );
  }
}
