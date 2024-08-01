import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors/colors.dart';

class MobileLoginTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hint;
  final IconData icon;
  const MobileLoginTextFieldWidget({
    super.key,
    required this.controller,
    required this.type,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20
      ),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10
          ),
          child: Center(
            child: TextField(
              keyboardType: type,
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blue,
                    )
                ),
                prefixIcon: Icon(
                  icon,
                  color: blue,
                ),
                border: InputBorder.none,
                fillColor: blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}