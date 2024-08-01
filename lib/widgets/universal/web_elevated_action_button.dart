import 'package:flutter/material.dart';

import 'elevated_button_text.dart';

class WebElevatedActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;
  const WebElevatedActionButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 2
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButtonText(text: text),
        )
    );
  }
}
