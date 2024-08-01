import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class SubHeading extends StatelessWidget {
  final String text;
  const SubHeading({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 2,
        maxFontSize: 16,
        minFontSize: 8,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
              color: textColor,
              fontSize: 14
          ),)
    );
  }
}
