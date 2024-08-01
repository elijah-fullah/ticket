import 'package:flutter/material.dart';

class TableIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  const TableIcon({
    super.key,
    required this.color,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: 22,
    );
  }
}