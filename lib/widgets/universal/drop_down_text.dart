import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class DropDownText extends StatelessWidget {
  final String text;
  const DropDownText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
              color: blue,
              fontWeight: FontWeight.bold
          ),)
    );
  }
}
