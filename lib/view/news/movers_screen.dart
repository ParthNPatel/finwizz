import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_all_movers_res_model.dart';
import 'package:finwizz/viewModel/get_all_movers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  GetAllMoverViewModel getAllMoverViewModel = Get.put(GetAllMoverViewModel());

  @override
  void initState() {
    pageController = PageController(initialPage: 0, keepPage: true);
    getAllMoverViewModel.getMoversViewModel();
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
                GetBuilder<GetAllMoverViewModel>(builder: (controller) {
                  if (controller.getMoversApiResponse.status ==
                      Status.LOADING) {
                    return CircularProgressIndicator();
                  }
                  if (controller.getMoversApiResponse.status ==
                      Status.COMPLETE) {
                    GetAllMoversResponseModel response =
                        controller.getMoversApiResponse.data;

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              Divider(
                                color: Color(0xffD1CDCD),
                                height: 0,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  CommonWidget.commonSvgPitcher(
                                      image: ImageConst.calender,
                                      height: 20.sp,
                                      width: 20.sp),
                                  SizedBox(width: 10),
                                  CommonText.textBoldWight500(text: 'Today')
                                ],
                              ),
                              SizedBox(height: 5),
                              Divider(
                                color: Color(0xffD1CDCD),
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: response.data!.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20.sp);
                          },
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                /*  controller.currentPage == 1
                                    ?*/
                                InkWell(
                                  onTap: () {
                                    pageController!.animateToPage(
                                        --controller.currentPage,
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.easeIn);
                                  },
                                  child: CommonWidget.commonSvgPitcher(
                                      image: 'assets/svg/left_arrow.svg'),
                                )
                                /*  : SizedBox(
                                        child: CommonWidget.commonSvgPitcher(
                                            image: 'assets/svg/left_arrow.svg',
                                            color: Colors.transparent)),*/
                                ,
                                SizedBox(
                                  height: 300,
                                  width: Get.width - 50,
                                  child: PageView(
                                    pageSnapping: true,
                                    controller: pageController,
                                    scrollDirection: Axis.horizontal,

                                    onPageChanged: (value) {
                                      controller.pageCount(value);
                                    },
                                    children: [
                                      Container(
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
                                                      '${response.data![index].title}',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CommonText.textBoldWight400(
                                                      text:
                                                          '${response.data![index].companyId!.name.toString().capitalizeFirst}',
                                                      color: Colors.black,
                                                      fontSize: 9.sp),
                                                  CommonWidget.commonSizedBox(
                                                      width: 10),
                                                  CommonText.textBoldWight400(
                                                      text:
                                                          '${response.data![index].priceRange}',
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
                                                  SizedBox(
                                                      height: 125.sp,
                                                      width: 125.sp,
                                                      child: gaugeWidget(
                                                          response, index)),
                                                  CommonWidget.commonSizedBox(
                                                      width: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 40),
                                                    child: Image.asset(
                                                      'assets/png/up_arrow_iphone.png',
                                                      scale: 4,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 40),
                                                    child: CommonText
                                                        .textBoldWight500(
                                                            text:
                                                                " ${response.data![index].percentage} %"),
                                                  )
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
                                                      '${DateFormat('MMM dd, hh:mm').format(response.data![index].createdAt!)} ·| Source : BSE',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 10),
                                            ]),
                                      ),
                                      Container(
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
                                                      '${response.data![index].title}',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              CommonText.textBoldWight400(
                                                  text:
                                                      '${response.data![index].companyId!.name!.toUpperCase()}',
                                                  color: Colors.black),
                                              CommonWidget.commonSizedBox(
                                                  height: 15),
                                              CommonText.textBoldWight500(
                                                  color: Color(0xff394452),
                                                  fontSize: 10.sp,
                                                  text:
                                                      "${response.data![index].description}"),
                                              CommonWidget.commonSizedBox(
                                                  height: 16),
                                              // CommonText.textBoldWight500(
                                              //     fontSize: 10.sp,
                                              //     color:
                                              //         Color(0xff394452),
                                              //     text:
                                              //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                              // CommonWidget.commonSizedBox(
                                              //     height: 10),
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
                                    ],
                                    //scrollDirection: Axis.horizontal,
                                    // itemBuilder: (context, indexPage) {
                                    //   return indexPage == 0
                                    //       ? Container(
                                    //           /* margin:
                                    //           EdgeInsets.symmetric(horizontal: 20),*/
                                    //           width: double.infinity,
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: 20, vertical: 10),
                                    //           decoration: BoxDecoration(
                                    //             border: Border.all(
                                    //               color: Color(0xffD1CDCD),
                                    //             ),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(14),
                                    //           ),
                                    //           child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //                 CommonText.textBoldWight700(
                                    //                     text:
                                    //                         '${response.data![index].title}',
                                    //                     color: Colors.black),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 15),
                                    //                 Row(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment
                                    //                           .spaceBetween,
                                    //                   children: [
                                    //                     CommonText.textBoldWight400(
                                    //                         text:
                                    //                             '${response.data![index].companyId!.name.toString().capitalizeFirst}',
                                    //                         color: Colors.black,
                                    //                         fontSize: 9.sp),
                                    //                     CommonWidget
                                    //                         .commonSizedBox(
                                    //                             width: 10),
                                    //                     CommonText.textBoldWight400(
                                    //                         text:
                                    //                             '${response.data![index].priceRange}',
                                    //                         color: Colors.black,
                                    //                         fontSize: 9.sp),
                                    //                     CommonText.textBoldWight400(
                                    //                         text:
                                    //                             '29 jul - 2 sep',
                                    //                         color: Colors.black,
                                    //                         fontSize: 9.sp),
                                    //                   ],
                                    //                 ),
                                    //                 Spacer(),
                                    //                 Row(
                                    //                   mainAxisAlignment:
                                    //                       MainAxisAlignment
                                    //                           .start,
                                    //                   children: [
                                    //                     SizedBox(
                                    //                         height: 125.sp,
                                    //                         width: 125.sp,
                                    //                         child: gaugeWidget(
                                    //                             response,
                                    //                             index)),
                                    //                     CommonWidget
                                    //                         .commonSizedBox(
                                    //                             width: 20),
                                    //                     Padding(
                                    //                       padding:
                                    //                           const EdgeInsets
                                    //                                   .only(
                                    //                               bottom: 40),
                                    //                       child: Image.asset(
                                    //                         'assets/png/up_arrow_iphone.png',
                                    //                         scale: 4,
                                    //                       ),
                                    //                     ),
                                    //                     Padding(
                                    //                       padding:
                                    //                           const EdgeInsets
                                    //                                   .only(
                                    //                               bottom: 40),
                                    //                       child: CommonText
                                    //                           .textBoldWight500(
                                    //                               text:
                                    //                                   " ${response.data![index].percentage} %"),
                                    //                     )
                                    //                   ],
                                    //                 ),
                                    //                 Row(
                                    //                   children: [
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         setState(() {
                                    //                           isFavourite =
                                    //                               !isFavourite;
                                    //                         });
                                    //                       },
                                    //                       child: Icon(
                                    //                         isFavourite == true
                                    //                             ? Icons.favorite
                                    //                             : Icons
                                    //                                 .favorite_border,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     CommonText
                                    //                         .textBoldWight400(
                                    //                             text: '120.1K',
                                    //                             color: Colors
                                    //                                 .black),
                                    //                     Spacer(),
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         setState(() {
                                    //                           isFavourite1 =
                                    //                               !isFavourite1;
                                    //                         });
                                    //                       },
                                    //                       child: Icon(
                                    //                         isFavourite1 == true
                                    //                             ? Icons.bookmark
                                    //                             : Icons
                                    //                                 .bookmark_outline_sharp,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         Share.share("Test");
                                    //                       },
                                    //                       child: Icon(
                                    //                         Icons.share,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //                 CommonText.textBoldWight400(
                                    //                     text:
                                    //                         '${DateFormat('MMM dd, hh:mm').format(response.data![index].createdAt!)} ·| Source : BSE',
                                    //                     color: Colors.black),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //               ]),
                                    //         )
                                    //       : Container(
                                    //           /* margin:
                                    //           EdgeInsets.symmetric(horizontal: 20),*/
                                    //           width: double.infinity,
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: 20, vertical: 10),
                                    //           decoration: BoxDecoration(
                                    //             border: Border.all(
                                    //               color: Color(0xffD1CDCD),
                                    //             ),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(14),
                                    //           ),
                                    //           child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
                                    //               children: [
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //                 CommonText.textBoldWight700(
                                    //                     text:
                                    //                         '${response.data![index].title}',
                                    //                     color: Colors.black),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 15),
                                    //                 CommonText.textBoldWight400(
                                    //                     text:
                                    //                         '${response.data![index].companyId!.name!.toUpperCase()}',
                                    //                     color: Colors.black),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 15),
                                    //                 CommonText.textBoldWight500(
                                    //                     color:
                                    //                         Color(0xff394452),
                                    //                     fontSize: 10.sp,
                                    //                     text:
                                    //                         "${response.data![index].description}"),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 16),
                                    //                 // CommonText.textBoldWight500(
                                    //                 //     fontSize: 10.sp,
                                    //                 //     color:
                                    //                 //         Color(0xff394452),
                                    //                 //     text:
                                    //                 //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                    //                 // CommonWidget.commonSizedBox(
                                    //                 //     height: 10),
                                    //                 Row(
                                    //                   children: [
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         setState(() {
                                    //                           isFavourite =
                                    //                               !isFavourite;
                                    //                         });
                                    //                       },
                                    //                       child: Icon(
                                    //                         isFavourite == true
                                    //                             ? Icons.favorite
                                    //                             : Icons
                                    //                                 .favorite_border,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     CommonText
                                    //                         .textBoldWight400(
                                    //                             text: '120.1K',
                                    //                             color: Colors
                                    //                                 .black),
                                    //                     Spacer(),
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         setState(() {
                                    //                           isFavourite1 =
                                    //                               !isFavourite1;
                                    //                         });
                                    //                       },
                                    //                       child: Icon(
                                    //                         isFavourite1 == true
                                    //                             ? Icons.bookmark
                                    //                             : Icons
                                    //                                 .bookmark_outline_sharp,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                     SizedBox(
                                    //                       width: 10,
                                    //                     ),
                                    //                     InkResponse(
                                    //                       onTap: () {
                                    //                         Share.share("Test");
                                    //                       },
                                    //                       child: Icon(
                                    //                         Icons.share,
                                    //                         color: CommonColor
                                    //                             .yellowColorFFB800,
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //                 CommonText.textBoldWight400(
                                    //                     text:
                                    //                         'Sep 7,  12:38 ·| Source : BSE',
                                    //                     color: Colors.black),
                                    //                 CommonWidget.commonSizedBox(
                                    //                     height: 10),
                                    //               ]),
                                    //         );
                                    // },
                                  ),
                                ),
                                /*controller.currentPage == 0
                                    ?*/
                                InkWell(
                                  onTap: () {
                                    pageController!.animateToPage(
                                        ++controller.currentPage,
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.easeIn);
                                  },
                                  child: CommonWidget.commonSvgPitcher(
                                      image: 'assets/svg/right_arrow.svg'),
                                )
                                /* : SizedBox(
                                        child: CommonWidget.commonSvgPitcher(
                                            image: 'assets/svg/right_arrow.svg',
                                            color: Colors.transparent)),*/
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  } else
                    return SizedBox();
                }),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 30),
            child: CreateAccount(),
          );
  }

  SfRadialGauge gaugeWidget(GetAllMoversResponseModel response, int index) {
    return SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1500,
        axes: <RadialAxis>[
          RadialAxis(
            showFirstLabel: false,
            interval: 120,
            startAngle: 180,
            endAngle: 0,
            minimum: 0,
            maximum: 100,
            axisLineStyle: AxisLineStyle(thickness: 35),
            showTicks: false,
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 16.66,
                  color: Color(0xffFF2424),
                  startWidth: 35,
                  endWidth: 35),
              GaugeRange(
                  startValue: 16.66,
                  endValue: 33.32,
                  color: Color(0xffFC8451),
                  startWidth: 35,
                  endWidth: 35),
              GaugeRange(
                  startValue: 33.32,
                  endValue: 49.98,
                  color: Color(0xffF6AC3E),
                  startWidth: 35,
                  endWidth: 35),
              GaugeRange(
                  startValue: 49.98,
                  endValue: 66.64,
                  color: Color(0xffC6F85E),
                  startWidth: 35,
                  endWidth: 35),
              GaugeRange(
                  startValue: 66.64,
                  endValue: 83.30,
                  color: Color(0xff57F954),
                  startWidth: 35,
                  endWidth: 35),
              GaugeRange(
                  startValue: 83.30,
                  endValue: 100,
                  color: Color(0xff01B549),
                  startWidth: 35,
                  endWidth: 35)
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                  value: response.data![index].percentage!.toDouble(),
                  needleLength: 45,
                  needleStartWidth: 0.5,
                  needleEndWidth: 4,
                  knobStyle: KnobStyle(
                      knobRadius: 0.11,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: CommonColor.greenColor2ECC71),
                  lengthUnit: GaugeSizeUnit.logicalPixel)
            ],
          )
        ]);
  }
}
