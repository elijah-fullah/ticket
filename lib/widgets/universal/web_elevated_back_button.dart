import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class WebElevatedBackButton extends StatelessWidget {
  const WebElevatedBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          Navigator.pop(context);
        },
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(blue),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                )
            )
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_back_ios, size: 20, color: background,),
            AutoSizeText(
                'Back',
                maxLines: 1,
                minFontSize: 14,
                maxFontSize: 18,
                style: GoogleFonts.akayaTelivigala(
                  textStyle: const TextStyle(
                      color: background,
                      fontSize: 16,
                      fontWeight: FontWeight.w900
                  ),
                )
            )
          ],
        )
    );
  }
}
