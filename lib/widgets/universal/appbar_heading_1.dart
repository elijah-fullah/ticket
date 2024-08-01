import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class AppBarHeading1 extends StatelessWidget {
  final String text;
  const AppBarHeading1({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        style: GoogleFonts.dancingScript(
          textStyle: const TextStyle(
              color: primary,
              fontSize: 25,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
