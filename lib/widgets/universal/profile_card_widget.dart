import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ticket/widgets/universal/profile_arrow_icon.dart';
import 'package:ticket/widgets/universal/sub_heading.dart';
import '../../constants/colors/colors.dart';
import 'heading_1.dart';
import 'heading_2.dart';
import 'heading_3.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading2(text: 'id'.toUpperCase()),
                  const Heading3(text: 'wwt222')
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading2(text: 'email'.toUpperCase()),
                  const Heading3(text: 'wwt222@gmail.com')
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading2(text: 'first name'.toUpperCase()),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Heading3(text: 'elijah'),
                      Gap(5),
                      ProfileArrowIcon()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading2(text: 'last name'.toUpperCase()),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Heading3(text: 'fuller'),
                      Gap(5),
                      ProfileArrowIcon()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading2(text: 'phone'.toUpperCase()),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Heading3(text: '+232 88 042283'),
                      Gap(5),
                      ProfileArrowIcon()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Heading3(text: 'Users'),
              GestureDetector(
                  onTap: (){},
                  child: const Heading3(text: 'see all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3.7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'User'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Heading3(text: 'Operators'),
              GestureDetector(
                onTap: (){},
                child: const Heading3(text: 'see all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3.7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Operator'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Heading3(text: 'Facilities'),
              GestureDetector(
                onTap: (){},
                child: const Heading3(text: 'see all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3.7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 0.4,
                          color: primary
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(130),
                              child: Image.asset(
                                'assets/icons/pro.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Heading1(text: 'Elijah Fullah'),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SubHeading(text: 'Facility'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
        const Gap(100)
      ],
    );
  }
}
