import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class MobileHeading1 extends StatelessWidget {
  final String text;
  const MobileHeading1({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 26,
        maxFontSize: 32,
        style: GoogleFonts.akayaTelivigala(
          textStyle: const TextStyle(
              color: blue,
              fontSize: 30,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
