import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/color_const.dart';
import '../../constant/image_const.dart';
import '../../constant/text_styel.dart';
import '../../get_storage_services/get_storage_service.dart';
import '../SignUp_SignIn/sign_up_screen.dart';

class MoversScreen extends StatefulWidget {
  const MoversScreen({Key? key}) : super(key: key);

  @override
  State<MoversScreen> createState() => _MoversScreenState();
}

class _MoversScreenState extends State<MoversScreen> {
  bool isFavourite = true;
  bool isFavourite1 = true;

  List listOfNews = [
    {
      'image': ImageConst.newsIcon,
      'title': 'News',
      'text': 'News that moves stocks'
    },
    {
      'image': ImageConst.bagIcon,
      'title': 'Portfolio protection',
      'text': 'Invest on information. Sell on information'
    }
  ];
  List listOfNews1 = [
    {
      'image': ImageConst.calender,
      'title': 'Today',
    },
    {
      'image': ImageConst.calender,
      'title': 'Yesterday',
    },
    {
      'image': ImageConst.calender,
      'title': 'Wed, 05 Sep 2022',
    }
  ];

  PageController? pageController;
  int _currentPage = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    // pageController!.addListener(() {
    //   setState(() {
    //     _currentPage = pageController!.page!.toInt();
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetStorageServices.getUserLoggedInStatus() == true
        ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                CommonWidget.commonSizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 1),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Divider(
                              color: Color(0xffD1CDCD),
                              height: 0,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                CommonWidget.commonSvgPitcher(
                                    image: ImageConst.calender,
                                    height: 20.sp,
                                    width: 20.sp),
                                SizedBox(width: 10),
                                CommonText.textBoldWight500(
                                    text: listOfNews1[index]['title'])
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: Color(0xffD1CDCD),
                              height: 0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // pageController!.previousPage(
                              //     duration: Duration(milliseconds: 600),
                              //     curve: Curves.easeIn);
                            },
                            child: CommonWidget.commonSvgPitcher(
                                image: 'assets/svg/left_arrow.svg'),
                          ),
                          Container(
                            height: 300,
                            width: Get.width - 50,
                            child: PageView.builder(
                              itemCount: 2,
                              onPageChanged: (value) {
                                setState(() {
                                  _currentPage = value;
                                });
                              },
                              //scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Container(
                                        /* margin:
                                          EdgeInsets.symmetric(horizontal: 20),*/
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffD1CDCD),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                              CommonText.textBoldWight700(
                                                  text: 'TANLA PLATFORMS',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CommonText.textBoldWight400(
                                                      text: 'TANLA',
                                                      color: Colors.black,
                                                      fontSize: 9.sp),
                                                  CommonWidget.commonSizedBox(
                                                      width: 10),
                                                  CommonText.textBoldWight400(
                                                      text: '839-1127',
                                                      color: Colors.black,
                                                      fontSize: 9.sp),
                                                  CommonText.textBoldWight400(
                                                      text: '29 jul - 2 sep',
                                                      color: Colors.black,
                                                      fontSize: 9.sp),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/png/percentage_graph.png',
                                                    scale: 4,
                                                  ),
                                                  CommonWidget.commonSizedBox(
                                                      width: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 40),
                                                    child: Image.asset(
                                                      'assets/png/⬆30%.png',
                                                      scale: 4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isFavourite =
                                                            !isFavourite;
                                                      });
                                                    },
                                                    child: Icon(
                                                      isFavourite == true
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CommonText.textBoldWight400(
                                                      text: '120.1K',
                                                      color: Colors.black),
                                                  Spacer(),
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isFavourite1 =
                                                            !isFavourite1;
                                                      });
                                                    },
                                                    child: Icon(
                                                      isFavourite1 == true
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_outline_sharp,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkResponse(
                                                    onTap: () {
                                                      Share.share("Test");
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                              CommonText.textBoldWight400(
                                                  text:
                                                      'Sep 7,  12:38 ·| Source : BSE',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                            ]),
                                      )
                                    : Container(
                                        /* margin:
                                          EdgeInsets.symmetric(horizontal: 20),*/
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffD1CDCD),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                              CommonText.textBoldWight700(
                                                  text:
                                                      'TANLA PLATFORMS considers equity buyback',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              CommonText.textBoldWight400(
                                                  text: 'TANLA',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              CommonText.textBoldWight500(
                                                  color: Color(0xff394452),
                                                  fontSize: 10.sp,
                                                  text:
                                                      "✅ Company will consider a proposal for buybac of Equity Shares on Thursday September 08, 2022"),
                                              CommonWidget.commonSizedBox(
                                                  height: 6),
                                              CommonText.textBoldWight500(
                                                  fontSize: 10.sp,
                                                  color: Color(0xff394452),
                                                  text:
                                                      "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                              Row(
                                                children: [
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isFavourite =
                                                            !isFavourite;
                                                      });
                                                    },
                                                    child: Icon(
                                                      isFavourite == true
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CommonText.textBoldWight400(
                                                      text: '120.1K',
                                                      color: Colors.black),
                                                  Spacer(),
                                                  InkResponse(
                                                    onTap: () {
                                                      setState(() {
                                                        isFavourite1 =
                                                            !isFavourite1;
                                                      });
                                                    },
                                                    child: Icon(
                                                      isFavourite1 == true
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_outline_sharp,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkResponse(
                                                    onTap: () {
                                                      Share.share("Test");
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      color: CommonColor
                                                          .yellowColorFFB800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                              CommonText.textBoldWight400(
                                                  text:
                                                      'Sep 7,  12:38 ·| Source : BSE',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                            ]),
                                      );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // pageController!.nextPage(
                              //     duration: Duration(milliseconds: 600),
                              //     curve: Curves.easeIn);
                            },
                            child: CommonWidget.commonSvgPitcher(
                                image: 'assets/svg/right_arrow.svg'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  itemCount: 3,
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 30),
            child: CreateAccount(),
          );
  }
}
