import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import '../../constants/colors/colors.dart';
import 'appbar_heading_1.dart';

class NotificationsAppbar extends StatelessWidget {
  final Function() search;
  final Function() add;
  final Function() filter;
  const NotificationsAppbar({
    super.key,
    required this.search,
    required this.add,
    required this.filter
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
              AppBarHeading1(text: 'Notifications',),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: search,
                child: const Icon(
                  IconlyLight.search,
                  size: 25,
                  color: primary,
                ),
              ),
              const Gap(20),
              GestureDetector(
                onTap: add,
                child: const Icon(
                  Icons.add,
                  color: primary,
                  size: 25,
                ),
              ),
              const Gap(20),
              GestureDetector(
                onTap: filter,
                child: const Icon(
                  IconlyLight.filter,
                  color: primary,
                  size: 25,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
