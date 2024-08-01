import 'package:flutter/material.dart';

import '../../constants/colors/colors.dart';
import '../universal/sub_heading.dart';
import '../universal/title_text.dart';

class MenuCardWidget extends StatelessWidget {
  final String role;
  const MenuCardWidget({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 1,
                  color: primary
              )
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/pngs/logo.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Row(
          children: [
            TitleText(smart: 'Smart', transit: 'Transit',)
          ],
        ),
        subtitle: SubHeading(text: role),
      ),
    );
  }
}