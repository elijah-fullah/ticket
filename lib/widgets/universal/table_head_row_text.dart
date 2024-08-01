import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableHeadRowText extends StatelessWidget {
  final String text;
  final Color color;
  const TableHeadRowText({
    super.key,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: 1,
        style: GoogleFonts.akayaTelivigala(
          textStyle: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
