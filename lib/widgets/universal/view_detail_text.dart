import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class ViewDetailText extends StatelessWidget {
  final String text;
  const ViewDetailText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 2,
        minFontSize: 14,
        maxFontSize: 20,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
              color: blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
          ),)
    );
  }
}
