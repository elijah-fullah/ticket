import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class ElevatedButtonText extends StatelessWidget {
  final String text;
  const ElevatedButtonText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 14,
        maxFontSize: 18,
        style: GoogleFonts.akayaTelivigala(
          textStyle: const TextStyle(
              color: background,
              fontSize: 16,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
