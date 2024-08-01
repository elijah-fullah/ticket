import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class ViewDivide extends StatelessWidget {
  const ViewDivide({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Divider(
        color: textColor,
        height: 0.1,
      ),
    );
  }
}
