import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/const_size.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/indicatorWidget.dart';
import '../BottomNav/bottom_nav_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  int pagerIndex = 0;
  int currentRadio = 0;
  bool isSkip = false;

  _pageChange(int index) {
    if (!isSkip) {
      print("Page changed : $index");
      setState(() {
        pagerIndex = index;
        controller.animateToPage(index,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      });
    } else {
      isSkip = false;
    }
  }

  _navigateToLastPage() {
    print("Navigate last page");
    isSkip = true;
    setState(() {
      pagerIndex = 3;
      controller.jumpToPage(3);
      // controller.animateToPage(3,
      //     duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  List<Map<String, dynamic>> items = [
    {
      "image": "assets/png/splash_wallet_icon.png",
      "title":
          "If your portfolio is at mercy of other’s opinion, you wouldn’t go very far in wealth creation "
    },
    {
      "image": "assets/png/splash_wallet_icon.png",
      "title":
          "If your portfolio is at mercy of other’s opinion, you wouldn’t go very far in wealth creation "
    },
    {
      "image": "assets/png/w_buble_text.png",
      "title": "WHAT DESCRIBES YOU BEST?",
      'question': [
        {
          'title': 'BEGINNER',
          'answer': 'I invest to generate long term returns'
        },
        {
          'title': 'LONG TERM INVESTOR',
          'answer': 'I’m just stepping into the market'
        },
        {
          'title': 'SHORT TERM INVESTOR',
          'answer': 'I invest to seek short term profit making opportunities'
        },
      ]
    },
    {
      "image": "assets/png/stack_bubel.png",
      "title": "HOW MANY YEARS LONG HAS YOUR STOCK MARKET JOURNEY HAS BEEN?",
      "years": [
        ["<=1", "2", '3'],
        ["4", "5", '6'],
        ["7", "8", '9+'],
      ]
    },
  ];
  int yearSelected = -1;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
              // height: height * 0.6,
              child: PageView.builder(
                onPageChanged: _pageChange,
                scrollDirection: Axis.horizontal,
                controller: controller,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return pagViewWidget(index, height);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PageIndicator(pagerIndex: pagerIndex, totalPages: 4),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _pageChange(pagerIndex + 1);
                    if (pagerIndex == 3) {
                      Get.offAll(
                        () => BottomNavScreen(
                          selectedIndex: 0,
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 70,
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                        color: CommonColor.themColor9295E2,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(ImageConst.rightArrow),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Column pagViewWidget(int index, double height) {
    return index == 0 || index == 1
        ? firstAndSecondWidget(index, height)
        : index == 2
            ? thirdIndexWidget(index, height)
            : lastIndexWidget(index, height);
  }

  Column thirdIndexWidget(int index, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(items[index]['image'], scale: 4.2),
        CommonWidget.commonSizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CommonText.textBoldWight600(
                    text: items[index]['title'], fontSize: 13.sp),
              ),
              CommonWidget.commonSizedBox(height: 10),
              Column(
                children: List.generate(
                  items[index]['question'].length,
                  (indexList) => Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CommonColor.greyColorEFEDF2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CommonText.textBoldWight400(
                                  text: items[index]['question'][indexList]
                                      ['title'],
                                  color: CommonColor.blackColor0C0101,
                                  fontSize: 12.sp),
                              Spacer(),
                              Theme(
                                data: ThemeData(
                                    toggleableActiveColor:
                                        CommonColor.themColor9295E2,
                                    unselectedWidgetColor:
                                        CommonColor.themColor9295E2,
                                    primaryColor: CommonColor.themColor9295E2),
                                child: Radio(
                                    // focusColor: CommonColor.themColor9295E2,
                                    // hoverColor: CommonColor.themColor9295E2,
                                    // activeColor: CommonColor.themColor9295E2,
                                    value: currentRadio == indexList
                                        ? indexList
                                        : 5,
                                    groupValue: indexList,
                                    onChanged: ((value) {
                                      setState(() {
                                        currentRadio = indexList;
                                      });
                                    })),
                              )
                            ],
                          ),
                          CommonText.textBoldWight400(
                              text: items[index]['question'][indexList]
                                  ['answer']),
                        ],
                      )),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Column firstAndSecondWidget(int index, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 70.sp),
        Image.asset(
          items[index]['image'], scale: 4.2,
          // height: height * 0.15,
          // width: height * 0.15,
        ),
        SizedBox(
          height: height * 0.06,
        ),
        Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CommonColor.greyColorEFEDF2),
            child: CommonText.textBoldWight400(text: items[index]['title'])),
      ],
    );
  }

  Column lastIndexWidget(int index, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(items[index]['image'], scale: 4.2),
        CommonWidget.commonSizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CommonText.textBoldWight700(
                    text: items[index]['title'], fontSize: 13.sp),
              ),
              CommonWidget.commonSizedBox(height: 30),
              Column(
                children: List.generate(
                  items[index]['years'].length,
                  (indexList) => Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CommonColor.greyColorEFEDF2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            items[index]['years'][indexList].length,
                            (indexOfYears) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      // setState(() {
                                      //   yearSelected = index;
                                      // });
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: yearSelected == index
                                              ? Color(0xff9295E2)
                                              : Colors.white),
                                      child: Center(
                                        child: CommonText.textBoldWight400(
                                            text: items[index]['years']
                                                [indexList][indexOfYears]),
                                      ),
                                    ),
                                  ),
                                )),
                      )),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
