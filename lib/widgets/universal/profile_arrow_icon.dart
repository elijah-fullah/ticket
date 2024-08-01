import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class ProfileArrowIcon extends StatelessWidget {
  const ProfileArrowIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      color: textColor,
      size: 20,
    );
  }
}
