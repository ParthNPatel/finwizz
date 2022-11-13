import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/view/portfolio/portfolio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constant/color_const.dart';
import '../../controllers/portfolio_controller.dart';
import '../BottomNav/bottom_nav_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List listOfStocks = [
    {
      'title': 'TANLA',
      'updates': [1, 5]
    },
    {
      'title': 'TATA MOTORS',
      'updates': [2]
    },
    {
      'title': 'RELIANCE',
      'updates': [],
    }
  ];
  PortFolioController _portFolioController = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
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
            CommonWidget.commonSizedBox(height: 12),
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
            ),
            _searchController.text.length == 3
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: CommonText.textBoldWight400(
                        text:
                            'No results found. We are constantly working on adding support for more stocks. Please check again after sometime.'),
                  )
                : ListView.builder(
                    itemCount: listOfStocks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _portFolioController.isAddShare = true;
                          Get.off(() => BottomNavScreen(
                                selectedIndex: 2,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: CommonText.textBoldWight400(
                                          text: listOfStocks[index]['title']),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.star_border,
                                      color: CommonColor.greyColorA3A3A3,
                                    )
                                  ],
                                ),
                              ),
                              CommonWidget.commonSizedBox(height: 6),
                              Divider(
                                color: CommonColor.greyColorD1CDCD,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
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
