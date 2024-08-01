import 'package:flutter/material.dart';
import 'package:ticket/widgets/universal/table_icon.dart';
import '../../constants/colors/colors.dart';

class InventoryTableAction extends StatelessWidget {
  final Function() view;
  const InventoryTableAction({
    super.key,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: view,
            child: const TableIcon(
              color: blue,
              icon: Icons.remove_red_eye_rounded,
            )
        ),
      ],
    );
  }
}
