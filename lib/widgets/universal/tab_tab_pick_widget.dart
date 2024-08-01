import 'package:flutter/material.dart';

class TabTabPickWidget extends StatelessWidget {
  final String name;
  const TabTabPickWidget({
    Key? key,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
    );
  }
}
