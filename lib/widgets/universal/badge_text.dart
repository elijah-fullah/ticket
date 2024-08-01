import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class BadgeText extends StatelessWidget {
  final String text;
  const BadgeText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        maxFontSize: 12,
        minFontSize: 8,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
              color: background,
              fontSize: 10,
            fontWeight: FontWeight.w700
          ),)
    );
  }
}
