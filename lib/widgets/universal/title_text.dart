import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class TitleText extends StatelessWidget {
  final String smart;
  final String transit;
  const TitleText({
    super.key,
    required this.smart,
    required this.transit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
            smart,
            maxLines: 2,
            maxFontSize: 30,
            minFontSize: 20,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.akayaTelivigala(
              textStyle: const TextStyle(
                  color: blue,
                  fontSize: 25,
                  fontWeight: FontWeight.w900
              ),
            )
        ),
        const Gap(2),
        AutoSizeText(
            transit,
            maxLines: 2,
            maxFontSize: 30,
            minFontSize: 20,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.akayaTelivigala(
              textStyle: const TextStyle(
                  color: primary,
                  fontSize: 25,
                  fontWeight: FontWeight.w900
              ),
            )
        ),
      ],
    );
  }
}
