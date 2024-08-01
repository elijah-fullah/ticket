import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket/widgets/universal/table_icon.dart';

import '../../constants/colors/colors.dart';

class TableAction extends StatelessWidget {
  final Function() view;
  final Function() edit;
  final Function() suspend;
  final Function() delete;
  const TableAction({
    super.key,
    required this.view,
    required this.edit,
    required this.suspend,
    required this.delete
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
        const Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
              onTap: edit,
              child: const TableIcon(
                color: blue,
                icon: Icons.edit,
              )
          ),
        ),
        const Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
              onTap: suspend,
              child: const TableIcon(
                color: blue,
                icon: Icons.pause,
              )
          ),
        ),
        const Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
              onTap: delete,
              child: TableIcon(
                color: red,
                icon: Icons.delete,
              )
          ),
        ),
      ],
    );
  }
}
