import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket/widgets/universal/shimmer_box.dart';

class ShimmerView extends StatelessWidget {
  const ShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ShimmerBox(height: 50, width: MediaQuery.of(context).size.height / 4),
        const Gap(10),
        ShimmerBox(height: 50, width: MediaQuery.of(context).size.height / 4),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ShimmerBox(height: 80, width: MediaQuery.of(context).size.height / 2),
            ShimmerBox(height: 80, width: MediaQuery.of(context).size.height / 2),
            ShimmerBox(height: 80, width: MediaQuery.of(context).size.height / 2),
          ],
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerBox(height: 400, width: MediaQuery.of(context).size.height / 1),
            const Gap(10),
            ShimmerBox(height: 400, width: MediaQuery.of(context).size.height / 2),
          ],
        ),
      ],
    );
  }
}
