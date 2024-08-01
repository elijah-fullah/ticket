import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:ticket/widgets/universal/table_icon.dart';
import '../../constants/colors/colors.dart';

class UserAction extends StatelessWidget {
  final Function() view;
  final Function() edit;
  final Function() status;
  final Color color;
  final Icon icon;
  const UserAction({
    super.key,
    required this.view,
    required this.edit,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: view,
            icon: const TableIcon(
              color: blue,
              icon: Icons.remove_red_eye_rounded,
            )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: edit,
              icon: const TableIcon(
                color: blue,
                icon: IconlyBold.editSquare,
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: IconButton(
              onPressed: status,
              icon: icon,
                color: color,
              ),
          ),
      ],
    );
  }
}
