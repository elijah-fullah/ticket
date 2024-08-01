import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class ReportTableHeading extends StatelessWidget {
  final String text;
  const ReportTableHeading({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: 1,
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
