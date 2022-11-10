import 'package:finwizz/constant/color_const.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    Key? key,
    required this.pagerIndex,
    required this.totalPages,
  }) : super(key: key);

  final totalPages;
  final int pagerIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalPages; i++)
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: pagerIndex == i
                        ? CommonColor.themColor9295E2
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                width: 14,
              ),
            ],
          ),
      ],
    );
  }
}
