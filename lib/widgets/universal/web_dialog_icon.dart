import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class WebDialogIcon extends StatelessWidget {
  final IconData icon;
  const WebDialogIcon({
    super.key,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: blue,
      size: 50,
    );
  }
}
