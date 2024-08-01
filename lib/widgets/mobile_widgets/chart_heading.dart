import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class ChartHeading extends StatelessWidget {
  final String text;
  const ChartHeading({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        maxFontSize: 18,
        minFontSize: 8,
        style: GoogleFonts.playfairDisplay(
          textStyle: TextStyle(
              color: textColor,
              fontSize: 16,
            fontWeight: FontWeight.bold
          ),)
    );
  }
}
