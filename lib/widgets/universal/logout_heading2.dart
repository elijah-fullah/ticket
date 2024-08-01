import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class LogoutHeading2 extends StatelessWidget {
  const LogoutHeading2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        'Logout',
        maxLines: 1,
        maxFontSize: 18,
        minFontSize: 14,
        style: GoogleFonts.playfairDisplay(
          textStyle: TextStyle(
              color: red,
              fontSize: 16,
              fontWeight: FontWeight.w800
          ),)
    );
  }
}
