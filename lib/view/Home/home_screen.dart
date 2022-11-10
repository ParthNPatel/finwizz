import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/const_size.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu_outlined,
                    size: 28.sp,
                    color: CommonColor.themColor9295E2,
                  )),
              CommonText.textBoldWight700(
                  text: 'Good evening  🙌', fontSize: 16.sp),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CommonText.textBoldWight400(text: 'Login'),
                decoration: BoxDecoration(
                    border: Border.all(color: CommonColor.themColor9295E2),
                    borderRadius: BorderRadius.circular(100)),
              ),
              CommonWidget.commonSizedBox(width: 10)
            ],
          )
        ]),
      ),
    );
  }
}
