import 'package:flutter/material.dart';
import 'package:ticket/widgets/universal/profile_appbar_container.dart';
import 'heading_1.dart';

class ProfileAppbar extends StatelessWidget {
  final String pic;
  final String text;
  const ProfileAppbar({
    super.key,
    required this.pic,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAppbarContainer(
            pic: pic,
          ),
          Heading1(
              text: text
          ),
        ],
      ),
    );
  }
}
