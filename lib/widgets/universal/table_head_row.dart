import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket/widgets/universal/table_head_row_text.dart';
import 'package:ticket/widgets/universal/table_icon.dart';

class TableHeadRow extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  const TableHeadRow({
    super.key,
    required this.color,
    required this.text,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TableIcon(
          color: color,
          icon: icon,
        ),
        const Gap(10),
        TableHeadRowText(
            text: text,
            color: color
        )
      ],
    );
  }
}
