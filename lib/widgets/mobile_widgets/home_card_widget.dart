import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/colors/colors.dart';
import '../universal/heading_2.dart';
import '../universal/heading_3.dart';
import '../universal/sub_heading.dart';

class HomeCardWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String type;
  final String what;
  final String name;
  final String lien;
  const HomeCardWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.type,
    required this.what,
    required this.name,
    required this.lien
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.01,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: color,
                              size: 20,
                            ),
                            const Gap(5),
                            SubHeading(text: type)
                          ],
                        ),
                        Heading2(text: what),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SubHeading(text: 'for'),
                            const Gap(5),
                            Heading3(text: name)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: color,
                          size: 7,
                        ),
                        const Gap(5),
                        SubHeading(text: lien)
                      ],
                    ),
                    const Gap(20),
                    const SubHeading(text: '2m'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
