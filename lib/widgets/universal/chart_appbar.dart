import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../constants/colors/colors.dart';
import 'appbar_heading_1.dart';

class ChartAppbar extends StatelessWidget {
  const ChartAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppBarHeading1(text: 'Charts',),
          GestureDetector(
            onTap: (){},
            child: const Icon(
              IconlyLight.filter,
              color: primary,),
          ),
        ],
      ),
    );
  }
}
