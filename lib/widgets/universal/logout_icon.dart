import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class LogoutIcon extends StatelessWidget {
  const LogoutIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.logout,
      color: red,
      size: 25,
    );
  }
}
