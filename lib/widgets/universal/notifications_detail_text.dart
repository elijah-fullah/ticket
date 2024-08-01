import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class NotificationsDetailText extends StatelessWidget {
  final String text;
  const NotificationsDetailText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxFontSize: 16,
        minFontSize: 12,
        style: GoogleFonts.playfairDisplay(
          textStyle: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),)
    );
  }
}
