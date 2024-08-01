import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class SidebarHeading2 extends StatelessWidget {
  final String text;
  const SidebarHeading2({
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
        style: GoogleFonts.akayaTelivigala(
          textStyle: const TextStyle(
              color: blue,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),)
    );
  }
}
