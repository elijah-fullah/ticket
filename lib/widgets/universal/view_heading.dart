import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class ViewHeading extends StatelessWidget {
  final String text;
  const ViewHeading({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 18,
        maxFontSize: 22,
        style: GoogleFonts.akayaTelivigala(
          textStyle: const TextStyle(
              color: blue,
              fontSize: 20,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
