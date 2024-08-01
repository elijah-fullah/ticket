import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class Heading2 extends StatelessWidget {
  final String text;
  const Heading2({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
        maxLines: 2,
        maxFontSize: 18,
        minFontSize: 14,
        style: GoogleFonts.openSans(
        textStyle: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold
    ),)
    );
  }
}
