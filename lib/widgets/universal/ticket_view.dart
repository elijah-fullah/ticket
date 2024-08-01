import 'package:flutter/material.dart';
import 'package:ticket/widgets/universal/table_icon.dart';
import '../../constants/colors/colors.dart';

class TicketView extends StatelessWidget {
  final Function() view;
  const TicketView({
    super.key,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: view,
        icon: const TableIcon(
          color: blue,
          icon: Icons.remove_red_eye_rounded,
        )
    );
  }
}
