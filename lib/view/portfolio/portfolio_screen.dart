import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/view/portfolio/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/color_const.dart';
import '../../constant/text_styel.dart';
import '../../controllers/portfolio_controller.dart';
import 'insider_tab_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key? key,
  }) : super(key: key);

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
  PortFolioController _portFolioController = Get.find();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController!.animation!.addListener(tabListener);
    super.initState();
  }

  void tabListener() {
    if (_portFolioController.selected !=
        tabController!.animation!.value.round()) {
      _portFolioController.selected = tabController!.animation!.value.round();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PortFolioController>(
        builder: (controller) {
          return SafeArea(
              child: Column(children: [
            appWidget(controller),
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
                  firstTabView(controller, context),
                  Center(
                    child: Text(
                      "News",
                      textScaleFactor: 1,
                    ),
                  ),
                  InsiderTabScreen()
                ],
              ),
            )
          ]));
        },
      ),
    );
  }

  Column firstTabView(PortFolioController controller, BuildContext context) {
    return Column(
      mainAxisAlignment: controller.isAddShare
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        controller.isAddShare
            ? CommonWidget.commonSizedBox(height: 26)
            : SizedBox(),
        controller.isAddShare
            ? ListView.builder(
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
                            //assets/svg/empty_check_box.svg
                            controller.isDelete
                                ? InkWell(
                                    onTap: () {
                                      controller.setListOfPortFolio(
                                          shareName: listOfStocks[index]
                                              ['title']);
                                    },
                                    child: CommonWidget.commonSvgPitcher(
                                        image: controller.listOfDeletePortFolio
                                                .contains(listOfStocks[index]
                                                    ['title'])
                                            ? 'assets/svg/check_box.svg'
                                            : 'assets/svg/empty_check_box.svg'),
                                  )
                                : SizedBox(),
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
                                        listOfStocks[index]['updates'].length,
                                        (indexOf) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 30.sp,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: CommonText.textBoldWight400(
                                              text: listOfStocks[index]
                                                      ['updates'][indexOf]
                                                  .toString()),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: listOfStocks[index]
                                                                  ['updates']
                                                              .length ==
                                                          2 &&
                                                      indexOf == 0
                                                  ? CommonColor.greenColor2ECC71
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
              )
            : SizedBox(),
        _portFolioController.isAddShare
            ? CommonWidget.commonSizedBox(height: 32)
            : SizedBox(),
        InkWell(
          onTap: () {
            if (controller.isDelete) {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) => Container(
                  height: 150.sp,
                  decoration: BoxDecoration(
                    color: Color(0xfff4f4f4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CommonText.textBoldWight500(
                            text: "Are you sure you want to delete ?"),
                      ),
                      CommonWidget.commonSizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: CommonText.textBoldWight700(
                                    text: "CANCEL",
                                    fontSize: 10.sp,
                                    color: Colors.white),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: CommonColor.themColor9295E2)),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: CommonText.textBoldWight700(
                                    text: "YES, DELETE",
                                    fontSize: 10.sp,
                                    color: Colors.white),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: CommonColor.themColor9295E2)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              Get.to(() => SearchScreen());
            }
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: CommonText.textBoldWight700(
                  text: controller.isDelete ? 'DELETE' : 'ADD STOCKS',
                  fontSize: 10.sp,
                  color: Colors.white),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CommonColor.themColor9295E2)),
        ),
      ],
    );
  }

  TabBar tabBarTitleWidget() {
    return TabBar(
      //isScrollable: true,
      controller: tabController,
      onTap: (value) {
        _portFolioController.selected = tabController!.index;
      },
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

  Widget appWidget(PortFolioController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          CommonText.textBoldWight700(text: 'Hello Tia🙌', fontSize: 16.sp),
          Spacer(),
          controller.selected == 0
              ? Row(
                  children: [
                    CommonWidget.commonSizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.to(() => SearchScreen());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                          child: CommonWidget.commonSvgPitcher(
                            image: ImageConst.plusIcon,
                          )),
                    ),
                    CommonWidget.commonSizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        controller.isDelete = true;
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                          child: CommonWidget.commonSvgPitcher(
                              image: ImageConst.deleteIcon,
                              color: controller.isDelete
                                  ? CommonColor.themDarkColor6E5DE7
                                  : Colors.black)),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () {
                    controller.isDelete = true;
                  },
                  child: Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                      child: CommonWidget.commonSvgPitcher(
                          image: ImageConst.filterIcon,
                          color: controller.isDelete
                              ? CommonColor.themDarkColor6E5DE7
                              : Colors.black)),
                ),
        ],
      ),
    );
  }
}
