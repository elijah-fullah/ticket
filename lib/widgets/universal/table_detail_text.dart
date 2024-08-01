import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors/colors.dart';

class TableDetailText extends StatelessWidget {
  final String text;
  const TableDetailText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: 1,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
              color: blue,
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
}
