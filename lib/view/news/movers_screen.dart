import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_all_movers_res_model.dart';
import 'package:finwizz/Models/responseModel/search_movers_res_model.dart';
import 'package:finwizz/viewModel/get_all_movers_view_model.dart';
import 'package:finwizz/viewModel/movers_like_unlike_view_model.dart';
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
  final bool? isCategoryVisible;
  final bool? isLoading;
  SearchMoversResponseModel? response;
  MoversScreen(
      {Key? key,
      this.isCategoryVisible = false,
      this.isLoading = false,
      this.response})
      : super(key: key);

  @override
  State<MoversScreen> createState() => _MoversScreenState();
}

class _MoversScreenState extends State<MoversScreen> {
  bool isFavourite = true;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

  GetAllMoverViewModel getAllMoverViewModel = Get.put(GetAllMoverViewModel());
  MoversLikeUnLikeViewModel moversLikeUnLikeViewModel =
      Get.put(MoversLikeUnLikeViewModel());

  int currentPage = 0;
  List showDate = [];

  @override
  void initState() {
    getAllMoverViewModel.getMoversViewModel();
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
                widget.isCategoryVisible!
                    ? GetBuilder<GetAllMoverViewModel>(builder: (controller) {
                        if (controller.getMoversApiResponse.status ==
                            Status.LOADING) {
                          return CircularProgressIndicator();
                        }
                        if (controller.getMoversApiResponse.status ==
                            Status.COMPLETE) {
                          GetAllMoversResponseModel response =
                              controller.getMoversApiResponse.data;

                          showDate.clear();

                          response.data!.forEach((element) {
                            if (showDate.contains(element!.createdAt
                                    .toString()
                                    .split(' ')
                                    .first) ==
                                false) {
                              showDate.add(element.createdAt
                                  .toString()
                                  .split(' ')
                                  .first);
                            }
                          });

                          return Column(
                            children: [
                              ListView.builder(
                                itemCount: showDate.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index1) {
                                  var dateData = showDate[index1];
                                  var currentDate = DateTime.now()
                                      .toString()
                                      .split(' ')
                                      .first;
                                  var yesterday = DateTime.now()
                                      .subtract(Duration(days: 1))
                                      .toString()
                                      .split(' ')
                                      .first;
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
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
                                                  text: dateData == currentDate
                                                      ? 'Today'
                                                      : dateData == yesterday
                                                          ? 'Yesterday'
                                                          : '${dateData}',
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              color: Color(0xffD1CDCD),
                                              height: 0,
                                            ),
                                            SizedBox(
                                              height: 16,
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
                                          return response
                                                      .data![index]!.createdAt
                                                      .toString()
                                                      .split(' ')
                                                      .first ==
                                                  showDate[index1]
                                              ? MoverWidget(
                                                  response: response,
                                                  index: index,
                                                  isFavourite: isFavourite)
                                              : SizedBox();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        } else
                          return SizedBox();
                      })
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.response!.data!.docs!.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.sp);
                        },
                        itemBuilder: (context, index) {
                          return SearchMoverWidget(
                              response: widget.response!,
                              index: index,
                              isFavourite: isFavourite);
                        },
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

class MoverWidget extends StatefulWidget {
  GetAllMoversResponseModel response;
  int index;
  bool isFavourite;

  MoverWidget({
    Key? key,
    required this.response,
    required this.index,
    required this.isFavourite,
  }) : super(key: key);

  @override
  State<MoverWidget> createState() => _MoverWidgetState();
}

class _MoverWidgetState extends State<MoverWidget> {
  int currentPage = 0;
  double gaugeContainerWidth = Get.width - 50;
  double otherContainerWidth = 0;
  int sensitivity = 8;
  Duration duration = Duration(milliseconds: 300);

  String formatString = "";

  List tmpList = [];

  String forStStart() {
    if (widget.response.data![widget.index]!.startDate!.contains(" ")) {
      widget.response.data![widget.index]!.startDate!
          .split(" ")
          .join("")
          .replaceAll("-", "/");

      return formatString = tmpList.reversed.join("-");
    } else {
      return formatString = widget.response.data![widget.index]!.startDate!;
    }
  }

  String forStEnd() {
    if (widget.response.data![widget.index]!.endDate!.contains(" ")) {
      tmpList.clear();

      widget.response.data![widget.index]!.endDate!
          .split(" ")
          .join("")
          .split("-")
          .forEach((element) {
        if (element.length == 1) {
          tmpList.add("0" + element);
        } else {
          tmpList.add(element);
        }
      });

      return formatString = tmpList.reversed.join("-");
    } else {
      return formatString = widget.response.data![widget.index]!.endDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: Get.width,
      child: Row(
        children: [
          currentPage == 1
              ? InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 0;
                      gaugeContainerWidth = Get.width - 50;
                      otherContainerWidth = 0;
                    });
                  },
                  child: CommonWidget.commonSvgPitcher(
                      image: 'assets/svg/left_arrow.svg'),
                )
              : CommonWidget.commonSvgPitcher(
                  image: 'assets/svg/left_arrow.svg',
                  color: Colors.transparent),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -sensitivity) {
                setState(() {
                  currentPage = 1;
                  otherContainerWidth = Get.width - 50;
                  gaugeContainerWidth = 0;
                });
              }
            },
            child: AnimatedContainer(
              duration: duration,
              width: gaugeContainerWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffD1CDCD),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight700(
                        text:
                            '${widget.response.data![widget.index]!.companyId!.name}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data![widget.index]!.companyId!.shortName.toString().capitalizeFirst}',
                            color: Colors.black,
                            fontSize: 9.sp),
                        CommonWidget.commonSizedBox(width: 10),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data![widget.index]!.startPrice} - ${widget.response.data![widget.index]!.currentPrice}',
                            color: Colors.black,
                            fontSize: 9.sp),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data![widget.index]!.startDate!.split(" ").join("").replaceAll("-", "/")} - ${widget.response.data![widget.index]!.endDate!.split(" ").join("").replaceAll("-", "/")}',
                            color: Colors.black,
                            fontSize: 9.sp),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 100.sp,
                            width: 125.sp,
                            child: gaugeWidget(widget.response, widget.index)),
                        CommonWidget.commonSizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Image.asset(
                            'assets/png/up_arrow_iphone.png',
                            scale: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: CommonText.textBoldWight500(
                              text:
                                  " ${widget.response.data![widget.index]!.percentage} %"),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkResponse(
                          onTap: () {
                            setState(() {
                              widget.isFavourite = !widget.isFavourite;
                            });
                          },
                          // onTap: () async {
                          //   // controller.updateLike(
                          //   //     response.data![index].isLiked!);
                          //   if (response.data![index].
                          //           .isLiked ==
                          //       false) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "like",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //
                          //     if (moversLikeUnLikeViewModel
                          //             .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   } else if (response
                          //           .data![index]
                          //           .isLiked ==
                          //       true) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "unlike",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   }
                          //   await getAllMoverViewModel
                          //       .getMoversViewModel(
                          //           isLoading: false
                          //   );
                          //   if (getAllMoverViewModel
                          //           .getMoversApiResponse
                          //           .status ==
                          //       Status.COMPLETE) {}
                          //   if (getAllMoverViewModel
                          //       .getMoversApiResponse
                          //           .status ==
                          //       Status.ERROR) {
                          //     CommonWidget.getSnackBar(
                          //         color: Colors.red,
                          //         duration: 2,
                          //         colorText:
                          //             Colors.white,
                          //         title:
                          //             "Refresh Page",
                          //         message:
                          //             'Try Again.');
                          //   }
                          // },
                          child: Icon(
                            widget.isFavourite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data![widget.index]!.likes}',
                            color: Colors.black),
                        Spacer(),
                        // InkResponse(
                        //   onTap: () {
                        //     setState(() {
                        //       isFavourite1 =
                        //           !isFavourite1;
                        //     });
                        //   },
                        //   child: Icon(
                        //     isFavourite1 == true
                        //         ? Icons.bookmark
                        //         : Icons
                        //             .bookmark_outline_sharp,
                        //     color: CommonColor
                        //         .yellowColorFFB800,
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        InkResponse(
                          onTap: () {
                            Share.share("Test");
                          },
                          child: Icon(
                            Icons.share,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight400(
                        text:
                            '${DateFormat('MMM dd, kk:mm a').format(widget.response.data![widget.index]!.createdAt!)} ·| Source : BSE',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                  ]),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > sensitivity) {
                setState(() {
                  currentPage = 0;
                  gaugeContainerWidth = Get.width - 50;
                  otherContainerWidth = 0;
                });
              }
            },
            child: AnimatedContainer(
              duration: duration,
              width: otherContainerWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffD1CDCD),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight700(
                        text:
                            '${widget.response.data![widget.index]!.companyId!.name}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 15),
                    CommonText.textBoldWight400(
                        text:
                            '${widget.response.data![widget.index]!.companyId!.shortName!.toUpperCase()}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 15),
                    // CommonText.textBoldWight500(
                    //     color: Color(0xff394452),
                    //     fontSize: 10.sp,
                    //     text:
                    //         "${widget.response.data![widget.index]!.description}"),
                    CommonWidget.commonSizedBox(height: 16),
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
                              widget.isFavourite = !widget.isFavourite;
                            });
                          },

                          // onTap: () async {
                          //   // controller.updateLike(
                          //   //     response.data![index].isLiked!);
                          //   if (response.data![index].
                          //           .isLiked ==
                          //       false) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "like",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //
                          //     if (moversLikeUnLikeViewModel
                          //             .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   } else if (response
                          //           .data![index]
                          //           .isLiked ==
                          //       true) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "unlike",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   }
                          //   await getAllMoverViewModel
                          //       .getMoversViewModel(
                          //           isLoading: false
                          //   );
                          //   if (getAllMoverViewModel
                          //           .getMoversApiResponse
                          //           .status ==
                          //       Status.COMPLETE) {}
                          //   if (getAllMoverViewModel
                          //       .getMoversApiResponse
                          //           .status ==
                          //       Status.ERROR) {
                          //     CommonWidget.getSnackBar(
                          //         color: Colors.red,
                          //         duration: 2,
                          //         colorText:
                          //             Colors.white,
                          //         title:
                          //             "Refresh Page",
                          //         message:
                          //             'Try Again.');
                          //   }
                          // },

                          child: Icon(
                            widget.isFavourite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data![widget.index]!.likes}',
                            color: Colors.black),
                        Spacer(),
                        // InkResponse(
                        //   onTap: () {
                        //     setState(() {
                        //       isFavourite1 =
                        //           !isFavourite1;
                        //     });
                        //   },
                        //   child: Icon(
                        //     isFavourite1 == true
                        //         ? Icons.bookmark
                        //         : Icons
                        //             .bookmark_outline_sharp,
                        //     color: CommonColor
                        //         .yellowColorFFB800,
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        InkResponse(
                          onTap: () {
                            Share.share("Test");
                          },
                          child: Icon(
                            Icons.share,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight400(
                        text:
                            '${DateFormat('MMM dd, kk:mm a').format(widget.response.data![widget.index]!.createdAt!)} ·| Source : BSE',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                  ]),
            ),
          ),
          currentPage == 0
              ? InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 1;
                      otherContainerWidth = Get.width - 50;
                      gaugeContainerWidth = 0;
                    });
                  },
                  child: CommonWidget.commonSvgPitcher(
                      image: 'assets/svg/right_arrow.svg'),
                )
              : CommonWidget.commonSvgPitcher(
                  image: 'assets/svg/left_arrow.svg', color: Colors.transparent)
        ],
      ),
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
                  value: response.data![index]!.percentage!.toDouble(),
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

class SearchMoverWidget extends StatefulWidget {
  SearchMoversResponseModel response;
  int index;
  bool isFavourite;

  SearchMoverWidget({
    Key? key,
    required this.response,
    required this.index,
    required this.isFavourite,
  }) : super(key: key);

  @override
  State<SearchMoverWidget> createState() => _SearchMoverWidgetState();
}

class _SearchMoverWidgetState extends State<SearchMoverWidget> {
  int currentPage = 0;
  double gaugeContainerWidth = Get.width - 50;
  double otherContainerWidth = 0;
  int sensitivity = 8;
  Duration duration = Duration(milliseconds: 300);

  String formatString = "";

  List tmpList = [];

  String forStStart() {
    if (widget.response.data!.docs![widget.index]!.startDate!.contains(" ")) {
      widget.response.data!.docs![widget.index]!.startDate!
          .split(" ")
          .join("")
          .replaceAll("-", "/");

      return formatString = tmpList.reversed.join("-");
    } else {
      return formatString =
          widget.response.data!.docs![widget.index]!.startDate!;
    }
  }

  String forStEnd() {
    if (widget.response.data!.docs![widget.index]!.endDate!.contains(" ")) {
      tmpList.clear();

      widget.response.data!.docs![widget.index]!.endDate!
          .split(" ")
          .join("")
          .split("-")
          .forEach((element) {
        if (element.length == 1) {
          tmpList.add("0" + element);
        } else {
          tmpList.add(element);
        }
      });

      return formatString = tmpList.reversed.join("-");
    } else {
      return formatString = widget.response.data!.docs![widget.index]!.endDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: Get.width,
      child: Row(
        children: [
          currentPage == 1
              ? InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 0;
                      gaugeContainerWidth = Get.width - 50;
                      otherContainerWidth = 0;
                    });
                  },
                  child: CommonWidget.commonSvgPitcher(
                      image: 'assets/svg/left_arrow.svg'),
                )
              : CommonWidget.commonSvgPitcher(
                  image: 'assets/svg/left_arrow.svg',
                  color: Colors.transparent),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -sensitivity) {
                setState(() {
                  currentPage = 1;
                  otherContainerWidth = Get.width - 50;
                  gaugeContainerWidth = 0;
                });
              }
            },
            child: AnimatedContainer(
              duration: duration,
              width: gaugeContainerWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffD1CDCD),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight700(
                        text:
                            '${widget.response.data!.docs![widget.index]!.companyId!}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data!.docs![widget.index]!.companyId!.toString().capitalizeFirst}',
                            color: Colors.black,
                            fontSize: 9.sp),
                        CommonWidget.commonSizedBox(width: 10),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data!.docs![widget.index]!.startPrice} - ${widget.response.data!.docs![widget.index]!.currentPrice}',
                            color: Colors.black,
                            fontSize: 9.sp),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data!.docs![widget.index]!.startDate!.split(" ").join("").replaceAll("-", "/")} - ${widget.response.data!.docs![widget.index]!.endDate!.split(" ").join("").replaceAll("-", "/")}',
                            color: Colors.black,
                            fontSize: 9.sp),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 100.sp,
                            width: 125.sp,
                            child: gaugeSearchWidget(
                                widget.response, widget.index)),
                        CommonWidget.commonSizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Image.asset(
                            'assets/png/up_arrow_iphone.png',
                            scale: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: CommonText.textBoldWight500(
                              text:
                                  " ${widget.response.data!.docs![widget.index]!.percentage} %"),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkResponse(
                          onTap: () {
                            setState(() {
                              widget.isFavourite = !widget.isFavourite;
                            });
                          },
                          // onTap: () async {
                          //   // controller.updateLike(
                          //   //     response.data![index].isLiked!);
                          //   if (response.data![index].
                          //           .isLiked ==
                          //       false) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "like",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //
                          //     if (moversLikeUnLikeViewModel
                          //             .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   } else if (response
                          //           .data![index]
                          //           .isLiked ==
                          //       true) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "unlike",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   }
                          //   await getAllMoverViewModel
                          //       .getMoversViewModel(
                          //           isLoading: false
                          //   );
                          //   if (getAllMoverViewModel
                          //           .getMoversApiResponse
                          //           .status ==
                          //       Status.COMPLETE) {}
                          //   if (getAllMoverViewModel
                          //       .getMoversApiResponse
                          //           .status ==
                          //       Status.ERROR) {
                          //     CommonWidget.getSnackBar(
                          //         color: Colors.red,
                          //         duration: 2,
                          //         colorText:
                          //             Colors.white,
                          //         title:
                          //             "Refresh Page",
                          //         message:
                          //             'Try Again.');
                          //   }
                          // },
                          child: Icon(
                            widget.isFavourite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data!.docs![widget.index]!.likes}',
                            color: Colors.black),
                        Spacer(),
                        // InkResponse(
                        //   onTap: () {
                        //     setState(() {
                        //       isFavourite1 =
                        //           !isFavourite1;
                        //     });
                        //   },
                        //   child: Icon(
                        //     isFavourite1 == true
                        //         ? Icons.bookmark
                        //         : Icons
                        //             .bookmark_outline_sharp,
                        //     color: CommonColor
                        //         .yellowColorFFB800,
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        InkResponse(
                          onTap: () {
                            Share.share("Test");
                          },
                          child: Icon(
                            Icons.share,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight400(
                        text:
                            '${DateFormat('MMM dd, kk:mm a').format(widget.response.data!.docs![widget.index]!.createdAt!)} ·| Source : BSE',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                  ]),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > sensitivity) {
                setState(() {
                  currentPage = 0;
                  gaugeContainerWidth = Get.width - 50;
                  otherContainerWidth = 0;
                });
              }
            },
            child: AnimatedContainer(
              duration: duration,
              width: otherContainerWidth,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffD1CDCD),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight700(
                        text:
                            '${widget.response.data!.docs![widget.index]!.companyId!}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 15),
                    CommonText.textBoldWight400(
                        text:
                            '${widget.response.data!.docs![widget.index]!.companyId!.toUpperCase()}',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 15),
                    // CommonText.textBoldWight500(
                    //     color: Color(0xff394452),
                    //     fontSize: 10.sp,
                    //     text:
                    //         "${widget.response.data![widget.index]!.description}"),
                    CommonWidget.commonSizedBox(height: 16),
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
                              widget.isFavourite = !widget.isFavourite;
                            });
                          },

                          // onTap: () async {
                          //   // controller.updateLike(
                          //   //     response.data![index].isLiked!);
                          //   if (response.data![index].
                          //           .isLiked ==
                          //       false) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "like",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //
                          //     if (moversLikeUnLikeViewModel
                          //             .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   } else if (response
                          //           .data![index]
                          //           .isLiked ==
                          //       true) {
                          //     await moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeViewModel(
                          //             body: {
                          //           "type": "unlike",
                          //           "newsId":
                          //               "${response.data![index].id}"
                          //         });
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.COMPLETE) {}
                          //     if (moversLikeUnLikeViewModel
                          //         .moversLikeUnLikeApiResponse
                          //             .status ==
                          //         Status.ERROR) {
                          //       // CommonWidget.getSnackBar(
                          //       //     color: Colors.red,
                          //       //     duration: 2,
                          //       //     colorText:
                          //       //         Colors.white,
                          //       //     title:
                          //       //         "Something went wrong",
                          //       //     message:
                          //       //         'Try Again.');
                          //     }
                          //   }
                          //   await getAllMoverViewModel
                          //       .getMoversViewModel(
                          //           isLoading: false
                          //   );
                          //   if (getAllMoverViewModel
                          //           .getMoversApiResponse
                          //           .status ==
                          //       Status.COMPLETE) {}
                          //   if (getAllMoverViewModel
                          //       .getMoversApiResponse
                          //           .status ==
                          //       Status.ERROR) {
                          //     CommonWidget.getSnackBar(
                          //         color: Colors.red,
                          //         duration: 2,
                          //         colorText:
                          //             Colors.white,
                          //         title:
                          //             "Refresh Page",
                          //         message:
                          //             'Try Again.');
                          //   }
                          // },

                          child: Icon(
                            widget.isFavourite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CommonText.textBoldWight400(
                            text:
                                '${widget.response.data!.docs![widget.index]!.likes}',
                            color: Colors.black),
                        Spacer(),
                        // InkResponse(
                        //   onTap: () {
                        //     setState(() {
                        //       isFavourite1 =
                        //           !isFavourite1;
                        //     });
                        //   },
                        //   child: Icon(
                        //     isFavourite1 == true
                        //         ? Icons.bookmark
                        //         : Icons
                        //             .bookmark_outline_sharp,
                        //     color: CommonColor
                        //         .yellowColorFFB800,
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        InkResponse(
                          onTap: () {
                            Share.share("Test");
                          },
                          child: Icon(
                            Icons.share,
                            color: CommonColor.yellowColorFFB800,
                          ),
                        ),
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonText.textBoldWight400(
                        text:
                            '${DateFormat('MMM dd, kk:mm a').format(widget.response.data!.docs![widget.index]!.createdAt!)} ·| Source : BSE',
                        color: Colors.black),
                    CommonWidget.commonSizedBox(height: 10),
                  ]),
            ),
          ),
          currentPage == 0
              ? InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = 1;
                      otherContainerWidth = Get.width - 50;
                      gaugeContainerWidth = 0;
                    });
                  },
                  child: CommonWidget.commonSvgPitcher(
                      image: 'assets/svg/right_arrow.svg'),
                )
              : CommonWidget.commonSvgPitcher(
                  image: 'assets/svg/left_arrow.svg', color: Colors.transparent)
        ],
      ),
    );
  }

  SfRadialGauge gaugeSearchWidget(
      SearchMoversResponseModel response, int index) {
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
                  value: response.data!.docs![index]!.percentage!.toDouble(),
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

//   SizedBox moverWidget(
//     GetAllMoverViewModel controller,
//     GetAllMoversResponseModel response,
//     int index,
//   ) {
//     int currentPage = 0;
//     return SizedBox(
//       height: 300,
//       width: Get.width,
//       child: Row(
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 currentPage = 0;
//               });
//             },
//             child: CommonWidget.commonSvgPitcher(
//                 image: 'assets/svg/left_arrow.svg'),
//           ),
//           currentPage == 0
//               ? Container(
//                   width: Get.width - 50,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Color(0xffD1CDCD),
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CommonWidget.commonSizedBox(height: 10),
//                         CommonText.textBoldWight700(
//                             text: '${response.data![index].title}',
//                             color: Colors.black),
//                         CommonWidget.commonSizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CommonText.textBoldWight400(
//                                 text:
//                                     '${response.data![index].companyId!.name.toString().capitalizeFirst}',
//                                 color: Colors.black,
//                                 fontSize: 9.sp),
//                             CommonWidget.commonSizedBox(width: 10),
//                             CommonText.textBoldWight400(
//                                 text: '${response.data![index].priceRange}',
//                                 color: Colors.black,
//                                 fontSize: 9.sp),
//                             CommonText.textBoldWight400(
//                                 text:
//                                     '${DateFormat("d MMM").format(response.data![index].createdAt!)} - ${DateFormat("d MMM").format(DateTime.now())}',
//                                 color: Colors.black,
//                                 fontSize: 9.sp),
//                           ],
//                         ),
//                         Spacer(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                                 height: 125.sp,
//                                 width: 125.sp,
//                                 child: gaugeWidget(response, index)),
//                             CommonWidget.commonSizedBox(width: 20),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 40),
//                               child: Image.asset(
//                                 'assets/png/up_arrow_iphone.png',
//                                 scale: 4,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 40),
//                               child: CommonText.textBoldWight500(
//                                   text:
//                                       " ${response.data![index].percentage} %"),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             InkResponse(
//                               onTap: () {
//                                 setState(() {
//                                   isFavourite = !isFavourite;
//                                 });
//                               },
//
//                               // onTap: () async {
//                               //   // controller.updateLike(
//                               //   //     response.data![index].isLiked!);
//                               //   if (response.data![index].
//                               //           .isLiked ==
//                               //       false) {
//                               //     await moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeViewModel(
//                               //             body: {
//                               //           "type": "like",
//                               //           "newsId":
//                               //               "${response.data![index].id}"
//                               //         });
//                               //
//                               //     if (moversLikeUnLikeViewModel
//                               //             .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.COMPLETE) {}
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.ERROR) {
//                               //       // CommonWidget.getSnackBar(
//                               //       //     color: Colors.red,
//                               //       //     duration: 2,
//                               //       //     colorText:
//                               //       //         Colors.white,
//                               //       //     title:
//                               //       //         "Something went wrong",
//                               //       //     message:
//                               //       //         'Try Again.');
//                               //     }
//                               //   } else if (response
//                               //           .data![index]
//                               //           .isLiked ==
//                               //       true) {
//                               //     await moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeViewModel(
//                               //             body: {
//                               //           "type": "unlike",
//                               //           "newsId":
//                               //               "${response.data![index].id}"
//                               //         });
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.COMPLETE) {}
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.ERROR) {
//                               //       // CommonWidget.getSnackBar(
//                               //       //     color: Colors.red,
//                               //       //     duration: 2,
//                               //       //     colorText:
//                               //       //         Colors.white,
//                               //       //     title:
//                               //       //         "Something went wrong",
//                               //       //     message:
//                               //       //         'Try Again.');
//                               //     }
//                               //   }
//                               //   await getAllMoverViewModel
//                               //       .getMoversViewModel(
//                               //           isLoading: false
//                               //   );
//                               //   if (getAllMoverViewModel
//                               //           .getMoversApiResponse
//                               //           .status ==
//                               //       Status.COMPLETE) {}
//                               //   if (getAllMoverViewModel
//                               //       .getMoversApiResponse
//                               //           .status ==
//                               //       Status.ERROR) {
//                               //     CommonWidget.getSnackBar(
//                               //         color: Colors.red,
//                               //         duration: 2,
//                               //         colorText:
//                               //             Colors.white,
//                               //         title:
//                               //             "Refresh Page",
//                               //         message:
//                               //             'Try Again.');
//                               //   }
//                               // },
//
//                               child: Icon(
//                                 isFavourite == true
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: CommonColor.yellowColorFFB800,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             CommonText.textBoldWight400(
//                                 text: '${response.data![index].likes}',
//                                 color: Colors.black),
//                             Spacer(),
//                             // InkResponse(
//                             //   onTap: () {
//                             //     setState(() {
//                             //       isFavourite1 =
//                             //           !isFavourite1;
//                             //     });
//                             //   },
//                             //   child: Icon(
//                             //     isFavourite1 == true
//                             //         ? Icons.bookmark
//                             //         : Icons
//                             //             .bookmark_outline_sharp,
//                             //     color: CommonColor
//                             //         .yellowColorFFB800,
//                             //   ),
//                             // ),
//                             // SizedBox(
//                             //   width: 10,
//                             // ),
//                             InkResponse(
//                               onTap: () {
//                                 Share.share("Test");
//                               },
//                               child: Icon(
//                                 Icons.share,
//                                 color: CommonColor.yellowColorFFB800,
//                               ),
//                             ),
//                           ],
//                         ),
//                         CommonWidget.commonSizedBox(height: 10),
//                         CommonText.textBoldWight400(
//                             text:
//                                 '${DateFormat('MMM dd, kk:mm a').format(response.data![index].createdAt!)} ·| Source : BSE',
//                             color: Colors.black),
//                         CommonWidget.commonSizedBox(height: 10),
//                       ]),
//                 )
//               : Container(
//                   width: Get.width - 50,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Color(0xffD1CDCD),
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CommonWidget.commonSizedBox(height: 10),
//                         CommonText.textBoldWight700(
//                             text: '${response.data![index].title}',
//                             color: Colors.black),
//                         CommonWidget.commonSizedBox(height: 15),
//                         CommonText.textBoldWight400(
//                             text:
//                                 '${response.data![index].companyId!.name!.toUpperCase()}',
//                             color: Colors.black),
//                         CommonWidget.commonSizedBox(height: 15),
//                         CommonText.textBoldWight500(
//                             color: Color(0xff394452),
//                             fontSize: 10.sp,
//                             text: "${response.data![index].description}"),
//                         CommonWidget.commonSizedBox(height: 16),
//                         // CommonText.textBoldWight500(
//                         //     fontSize: 10.sp,
//                         //     color:
//                         //         Color(0xff394452),
//                         //     text:
//                         //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
//                         // CommonWidget.commonSizedBox(
//                         //     height: 10),
//                         Row(
//                           children: [
//                             InkResponse(
//                               onTap: () {
//                                 setState(() {
//                                   isFavourite = !isFavourite;
//                                 });
//                               },
//
//                               // onTap: () async {
//                               //   // controller.updateLike(
//                               //   //     response.data![index].isLiked!);
//                               //   if (response.data![index].
//                               //           .isLiked ==
//                               //       false) {
//                               //     await moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeViewModel(
//                               //             body: {
//                               //           "type": "like",
//                               //           "newsId":
//                               //               "${response.data![index].id}"
//                               //         });
//                               //
//                               //     if (moversLikeUnLikeViewModel
//                               //             .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.COMPLETE) {}
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.ERROR) {
//                               //       // CommonWidget.getSnackBar(
//                               //       //     color: Colors.red,
//                               //       //     duration: 2,
//                               //       //     colorText:
//                               //       //         Colors.white,
//                               //       //     title:
//                               //       //         "Something went wrong",
//                               //       //     message:
//                               //       //         'Try Again.');
//                               //     }
//                               //   } else if (response
//                               //           .data![index]
//                               //           .isLiked ==
//                               //       true) {
//                               //     await moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeViewModel(
//                               //             body: {
//                               //           "type": "unlike",
//                               //           "newsId":
//                               //               "${response.data![index].id}"
//                               //         });
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.COMPLETE) {}
//                               //     if (moversLikeUnLikeViewModel
//                               //         .moversLikeUnLikeApiResponse
//                               //             .status ==
//                               //         Status.ERROR) {
//                               //       // CommonWidget.getSnackBar(
//                               //       //     color: Colors.red,
//                               //       //     duration: 2,
//                               //       //     colorText:
//                               //       //         Colors.white,
//                               //       //     title:
//                               //       //         "Something went wrong",
//                               //       //     message:
//                               //       //         'Try Again.');
//                               //     }
//                               //   }
//                               //   await getAllMoverViewModel
//                               //       .getMoversViewModel(
//                               //           isLoading: false
//                               //   );
//                               //   if (getAllMoverViewModel
//                               //           .getMoversApiResponse
//                               //           .status ==
//                               //       Status.COMPLETE) {}
//                               //   if (getAllMoverViewModel
//                               //       .getMoversApiResponse
//                               //           .status ==
//                               //       Status.ERROR) {
//                               //     CommonWidget.getSnackBar(
//                               //         color: Colors.red,
//                               //         duration: 2,
//                               //         colorText:
//                               //             Colors.white,
//                               //         title:
//                               //             "Refresh Page",
//                               //         message:
//                               //             'Try Again.');
//                               //   }
//                               // },
//
//                               child: Icon(
//                                 isFavourite == true
//                                     ? Icons.favorite
//                                     : Icons.favorite_border,
//                                 color: CommonColor.yellowColorFFB800,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             CommonText.textBoldWight400(
//                                 text: '${response.data![index].likes}',
//                                 color: Colors.black),
//                             Spacer(),
//                             // InkResponse(
//                             //   onTap: () {
//                             //     setState(() {
//                             //       isFavourite1 =
//                             //           !isFavourite1;
//                             //     });
//                             //   },
//                             //   child: Icon(
//                             //     isFavourite1 == true
//                             //         ? Icons.bookmark
//                             //         : Icons
//                             //             .bookmark_outline_sharp,
//                             //     color: CommonColor
//                             //         .yellowColorFFB800,
//                             //   ),
//                             // ),
//                             // SizedBox(
//                             //   width: 10,
//                             // ),
//                             InkResponse(
//                               onTap: () {
//                                 Share.share("Test");
//                               },
//                               child: Icon(
//                                 Icons.share,
//                                 color: CommonColor.yellowColorFFB800,
//                               ),
//                             ),
//                           ],
//                         ),
//                         CommonWidget.commonSizedBox(height: 10),
//                         CommonText.textBoldWight400(
//                             text:
//                                 '${DateFormat('MMM dd, kk:mm a').format(response.data![index].createdAt!)} ·| Source : BSE',
//                             color: Colors.black),
//                         CommonWidget.commonSizedBox(height: 10),
//                       ]),
//                 ),
//           InkWell(
//             onTap: () {
//               setState(() {
//                 currentPage = 1;
//               });
//             },
//             child: CommonWidget.commonSvgPitcher(
//                 image: 'assets/svg/right_arrow.svg'),
//           )
//         ],
//       ),
//     );
//
// //     return Row(
// //       children: [
// //         /*      currentPage == 1
// //             ? */
// //         InkWell(
// //           onTap: () {
// //             pageController.animateToPage(--currentPage,
// //                 duration: Duration(milliseconds: 600), curve: Curves.easeIn);
// //           },
// //           child:
// //               CommonWidget.commonSvgPitcher(image: 'assets/svg/left_arrow.svg'),
// //         )
// // /*            : SizedBox(
// //                 child: CommonWidget.commonSvgPitcher(
// //                     image: 'assets/svg/left_arrow.svg',
// //                     color: Colors.transparent))*/
// //         ,
// //         SizedBox(
// //           height: 300,
// //           width: Get.width - 50,
// //           child: PageView(
// //             pageSnapping: true,
// //             controller: pageController,
// //             scrollDirection: Axis.horizontal,
// //             // onPageChanged: (value) {
// //             //   setState(() {
// //             //     currentPage = value;
// //             //   });
// //             //
// //             //   print(' ==== 1 ? ${currentPage}');
// //             // },
// //             children: [
// //
// //
// //             ],
// //             //scrollDirection: Axis.horizontal,
// //             // itemBuilder: (context, indexPage) {
// //             //   return indexPage == 0
// //             //       ? Container(
// //             //           /* margin:
// //             //           EdgeInsets.symmetric(horizontal: 20),*/
// //             //           width: double.infinity,
// //             //           padding: EdgeInsets.symmetric(
// //             //               horizontal: 20, vertical: 10),
// //             //           decoration: BoxDecoration(
// //             //             border: Border.all(
// //             //               color: Color(0xffD1CDCD),
// //             //             ),
// //             //             borderRadius:
// //             //                 BorderRadius.circular(14),
// //             //           ),
// //             //           child: Column(
// //             //               crossAxisAlignment:
// //             //                   CrossAxisAlignment.start,
// //             //               children: [
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //                 CommonText.textBoldWight700(
// //             //                     text:
// //             //                         '${response.data![index].title}',
// //             //                     color: Colors.black),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 15),
// //             //                 Row(
// //             //                   mainAxisAlignment:
// //             //                       MainAxisAlignment
// //             //                           .spaceBetween,
// //             //                   children: [
// //             //                     CommonText.textBoldWight400(
// //             //                         text:
// //             //                             '${response.data![index].companyId!.name.toString().capitalizeFirst}',
// //             //                         color: Colors.black,
// //             //                         fontSize: 9.sp),
// //             //                     CommonWidget
// //             //                         .commonSizedBox(
// //             //                             width: 10),
// //             //                     CommonText.textBoldWight400(
// //             //                         text:
// //             //                             '${response.data![index].priceRange}',
// //             //                         color: Colors.black,
// //             //                         fontSize: 9.sp),
// //             //                     CommonText.textBoldWight400(
// //             //                         text:
// //             //                             '29 jul - 2 sep',
// //             //                         color: Colors.black,
// //             //                         fontSize: 9.sp),
// //             //                   ],
// //             //                 ),
// //             //                 Spacer(),
// //             //                 Row(
// //             //                   mainAxisAlignment:
// //             //                       MainAxisAlignment
// //             //                           .start,
// //             //                   children: [
// //             //                     SizedBox(
// //             //                         height: 125.sp,
// //             //                         width: 125.sp,
// //             //                         child: gaugeWidget(
// //             //                             response,
// //             //                             index)),
// //             //                     CommonWidget
// //             //                         .commonSizedBox(
// //             //                             width: 20),
// //             //                     Padding(
// //             //                       padding:
// //             //                           const EdgeInsets
// //             //                                   .only(
// //             //                               bottom: 40),
// //             //                       child: Image.asset(
// //             //                         'assets/png/up_arrow_iphone.png',
// //             //                         scale: 4,
// //             //                       ),
// //             //                     ),
// //             //                     Padding(
// //             //                       padding:
// //             //                           const EdgeInsets
// //             //                                   .only(
// //             //                               bottom: 40),
// //             //                       child: CommonText
// //             //                           .textBoldWight500(
// //             //                               text:
// //             //                                   " ${response.data![index].percentage} %"),
// //             //                     )
// //             //                   ],
// //             //                 ),
// //             //                 Row(
// //             //                   children: [
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         setState(() {
// //             //                           isFavourite =
// //             //                               !isFavourite;
// //             //                         });
// //             //                       },
// //             //                       child: Icon(
// //             //                         isFavourite == true
// //             //                             ? Icons.favorite
// //             //                             : Icons
// //             //                                 .favorite_border,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                     SizedBox(
// //             //                       width: 10,
// //             //                     ),
// //             //                     CommonText
// //             //                         .textBoldWight400(
// //             //                             text: '120.1K',
// //             //                             color: Colors
// //             //                                 .black),
// //             //                     Spacer(),
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         setState(() {
// //             //                           isFavourite1 =
// //             //                               !isFavourite1;
// //             //                         });
// //             //                       },
// //             //                       child: Icon(
// //             //                         isFavourite1 == true
// //             //                             ? Icons.bookmark
// //             //                             : Icons
// //             //                                 .bookmark_outline_sharp,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                     SizedBox(
// //             //                       width: 10,
// //             //                     ),
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         Share.share("Test");
// //             //                       },
// //             //                       child: Icon(
// //             //                         Icons.share,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                   ],
// //             //                 ),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //                 CommonText.textBoldWight400(
// //             //                     text:
// //             //                         '${DateFormat('MMM dd, hh:mm').format(response.data![index].createdAt!)} ·| Source : BSE',
// //             //                     color: Colors.black),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //               ]),
// //             //         )
// //             //       : Container(
// //             //           /* margin:
// //             //           EdgeInsets.symmetric(horizontal: 20),*/
// //             //           width: double.infinity,
// //             //           padding: EdgeInsets.symmetric(
// //             //               horizontal: 20, vertical: 10),
// //             //           decoration: BoxDecoration(
// //             //             border: Border.all(
// //             //               color: Color(0xffD1CDCD),
// //             //             ),
// //             //             borderRadius:
// //             //                 BorderRadius.circular(14),
// //             //           ),
// //             //           child: Column(
// //             //               crossAxisAlignment:
// //             //                   CrossAxisAlignment.start,
// //             //               children: [
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //                 CommonText.textBoldWight700(
// //             //                     text:
// //             //                         '${response.data![index].title}',
// //             //                     color: Colors.black),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 15),
// //             //                 CommonText.textBoldWight400(
// //             //                     text:
// //             //                         '${response.data![index].companyId!.name!.toUpperCase()}',
// //             //                     color: Colors.black),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 15),
// //             //                 CommonText.textBoldWight500(
// //             //                     color:
// //             //                         Color(0xff394452),
// //             //                     fontSize: 10.sp,
// //             //                     text:
// //             //                         "${response.data![index].description}"),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 16),
// //             //                 // CommonText.textBoldWight500(
// //             //                 //     fontSize: 10.sp,
// //             //                 //     color:
// //             //                 //         Color(0xff394452),
// //             //                 //     text:
// //             //                 //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
// //             //                 // CommonWidget.commonSizedBox(
// //             //                 //     height: 10),
// //             //                 Row(
// //             //                   children: [
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         setState(() {
// //             //                           isFavourite =
// //             //                               !isFavourite;
// //             //                         });
// //             //                       },
// //             //                       child: Icon(
// //             //                         isFavourite == true
// //             //                             ? Icons.favorite
// //             //                             : Icons
// //             //                                 .favorite_border,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                     SizedBox(
// //             //                       width: 10,
// //             //                     ),
// //             //                     CommonText
// //             //                         .textBoldWight400(
// //             //                             text: '120.1K',
// //             //                             color: Colors
// //             //                                 .black),
// //             //                     Spacer(),
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         setState(() {
// //             //                           isFavourite1 =
// //             //                               !isFavourite1;
// //             //                         });
// //             //                       },
// //             //                       child: Icon(
// //             //                         isFavourite1 == true
// //             //                             ? Icons.bookmark
// //             //                             : Icons
// //             //                                 .bookmark_outline_sharp,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                     SizedBox(
// //             //                       width: 10,
// //             //                     ),
// //             //                     InkResponse(
// //             //                       onTap: () {
// //             //                         Share.share("Test");
// //             //                       },
// //             //                       child: Icon(
// //             //                         Icons.share,
// //             //                         color: CommonColor
// //             //                             .yellowColorFFB800,
// //             //                       ),
// //             //                     ),
// //             //                   ],
// //             //                 ),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //                 CommonText.textBoldWight400(
// //             //                     text:
// //             //                         'Sep 7,  12:38 ·| Source : BSE',
// //             //                     color: Colors.black),
// //             //                 CommonWidget.commonSizedBox(
// //             //                     height: 10),
// //             //               ]),
// //             //         );
// //             // },
// //           ),
// //         ),
// //         /*   currentPage == 0
// //             ?*/
// //         InkWell(
// //           onTap: () {
// //             pageController.animateToPage(++currentPage,
// //                 duration: Duration(milliseconds: 600), curve: Curves.easeIn);
// //           },
// //           child: CommonWidget.commonSvgPitcher(
// //               image: 'assets/svg/right_arrow.svg'),
// //         )
// //         /* : SizedBox(
// //                 child: CommonWidget.commonSvgPitcher(
// //                     image: 'assets/svg/right_arrow.svg',
// //                     color: Colors.transparent)),*/
// //       ],
// //     );
//   }
