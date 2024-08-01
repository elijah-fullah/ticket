import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class WebMenuIcon extends StatelessWidget {
  final IconData icon;
  const WebMenuIcon({
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
