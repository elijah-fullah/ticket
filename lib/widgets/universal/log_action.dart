import 'package:flutter/material.dart';

class LogAction extends StatelessWidget {
  final Function() status;
  final Color color;
  final Icon icon;
  const LogAction({
    super.key,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: status,
        color: color,
        icon: icon
    );
  }
}