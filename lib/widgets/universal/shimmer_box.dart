import 'package:flutter/material.dart';
import 'package:ticket/constants/colors/colors.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerBox({
    super.key,
    required this.height,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(100),
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}
