import 'package:flutter/material.dart';
import '../../constants/colors/colors.dart';

class ProfileAppbarContainer extends StatelessWidget {
  final String pic;
  const ProfileAppbarContainer({
    super.key,
    required this.pic
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: primary,
              width: 2
          ),
          image: DecorationImage(
              image: AssetImage(
                pic,
              ),
              fit: BoxFit.cover
          )
      ),
    );
  }
}
