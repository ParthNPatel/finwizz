import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constant/color_const.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _editingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CommonWidget.commonSizedBox(height: 10),
            appBarWidget(),
            CommonWidget.commonSizedBox(height: 10),
            searchBarWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  CommonText.textBoldWight600(text: 'Search result for '),
                  CommonText.textBoldWight400(text: "'to'"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: CommonColor.greyColorD1CDCD,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding appBarWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 20),
      child: Row(
        children: [
          CommonText.textBoldWight600(text: 'Add Stocks', fontSize: 18.sp),
          Spacer(),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                child: Icon(Icons.close)),
          )
        ],
      ),
    );
  }

  Row searchBarWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
              height: 44,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 15),
              margin: EdgeInsets.only(left: 14, right: 10, bottom: 10, top: 10),
              decoration: BoxDecoration(
                color: CommonColor.whiteColorF4F6F9,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _editingController,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 2),
                    hintText: 'Search',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(0xff858C94),
                    ),
                    border: InputBorder.none),
              )),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: CommonText.textBoldWight700(
              text: 'SEARCH',
              fontSize: 10.sp,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: CommonColor.themColor9295E2)),
      ],
    );
  }
}
