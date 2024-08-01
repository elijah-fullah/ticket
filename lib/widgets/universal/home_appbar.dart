import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:ticket/widgets/universal/title_text.dart';
import '../../constants/colors/colors.dart';

class HomeAppbar extends StatelessWidget {
  final Function() onTap;
  const HomeAppbar({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              TitleText(smart: 'feed', transit: 'salone',)
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              IconlyLight.search,
              size: 25,
              color: primary,
            ),
          )
        ],
      ),
    );
  }
}
