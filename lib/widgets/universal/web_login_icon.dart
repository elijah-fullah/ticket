import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/colors/colors.dart';

class WebLoginIcon extends StatelessWidget {
  const WebLoginIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Ionicons.bus,
      color: primary,
      size: 150,
    );
  }
}
