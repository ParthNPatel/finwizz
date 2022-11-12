import 'package:finwizz/constant/image_const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/color_const.dart';
import '../../constant/text_styel.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        appWidget(),
        Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffDADEE3), width: 1),
                ),
              ),
            ),
            tabBarTitleWidget(),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 26),
                  ListView.builder(
                    itemCount: listOfStocks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: CommonText.textBoldWight400(
                                      text: listOfStocks[index]['title']),
                                ),
                                Spacer(),
                                listOfStocks[index]['updates'].length == 0
                                    ? CommonText.textBoldWight400(
                                        text: 'No recent updates ')
                                    : Row(
                                        children: List.generate(
                                            listOfStocks[index]['updates']
                                                .length, (indexOf) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 30.sp,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child:
                                                  CommonText.textBoldWight400(
                                                      text: listOfStocks[index]
                                                                  ['updates']
                                                              [indexOf]
                                                          .toString()),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: listOfStocks[index][
                                                                      'updates']
                                                                  .length ==
                                                              2 &&
                                                          indexOf == 0
                                                      ? CommonColor
                                                          .greenColor2ECC71
                                                          .withOpacity(0.5)
                                                      : CommonColor
                                                          .lightRedColor3D3D3D
                                                          .withOpacity(0.5)),
                                            ),
                                          );
                                        }),
                                      )
                              ],
                            ),
                            CommonWidget.commonSizedBox(height: 6),
                            Divider(
                              color: CommonColor.greyColorD1CDCD,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  CommonWidget.commonSizedBox(height: 32),
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: CommonText.textBoldWight700(
                          text: 'ADD STOCKS',
                          fontSize: 10.sp,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CommonColor.themColor9295E2)),
                ],
              ),
              Center(
                child: Text(
                  "News",
                  textScaleFactor: 1,
                ),
              ),
              Center(
                child: Text(
                  "Insider",
                  textScaleFactor: 1,
                ),
              )
            ],
          ),
        )
      ])),
    );
  }

  TabBar tabBarTitleWidget() {
    return TabBar(
      //isScrollable: true,
      controller: tabController,
      labelPadding: EdgeInsets.symmetric(vertical: 9.sp),
      unselectedLabelColor: Colors.black,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff9295E2), width: 4),
      ),
      //onTap: (index) => tabsModel.value = listTabsModel[index],
      tabs: [
        Text(
          'Summary',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
        Text(
          'News',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
        Text(
          'Insider',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget appWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          CommonText.textBoldWight700(text: 'Hello Tia🙌', fontSize: 16.sp),
          Spacer(),
          CommonWidget.commonSizedBox(width: 10),
          Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
              child: CommonWidget.commonSvgPitcher(image: ImageConst.plusIcon)),
          CommonWidget.commonSizedBox(width: 10),
          Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
              child:
                  CommonWidget.commonSvgPitcher(image: ImageConst.deleteIcon)),
        ],
      ),
    );
  }
}