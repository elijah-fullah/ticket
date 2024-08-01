import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class HeadingItalic extends StatelessWidget {
  final String text;
  const HeadingItalic({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        style: GoogleFonts.playfairDisplay(
          textStyle: TextStyle(
              color: textColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic
          ),)
    );
  }
}
