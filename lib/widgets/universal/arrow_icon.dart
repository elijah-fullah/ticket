import 'package:flutter/material.dart';

import '../../constants/colors/colors.dart';

class ArrowIcon extends StatelessWidget {
  const ArrowIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_forward_ios,
      color: primary,
      size: 20,
    );
  }
}
