import 'package:flutter/material.dart';
import 'package:ticket/widgets/universal/web_main_icon.dart';
import '../../constants/colors/colors.dart';
import 'drop_down_text.dart';

class DropDownTypeWidget extends StatelessWidget {
  final String? val;
  final List<DropdownMenuItem> item;
  final onChange;
  final String type;
  const DropDownTypeWidget(
      {super.key,
      required this.val,
      required this.item,
      required this.onChange,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 4,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            isExpanded: true,
            icon: const WebMainIcon(
              icon: Icons.arrow_drop_down_rounded,
            ),
            value: val,
            hint: DropDownText(text: type),
            items: item,
            onChanged: onChange),
      ),
    );
  }
}
