import 'dart:developer';

import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/stock_news_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
import 'package:finwizz/viewModel/like_unlike_view_model.dart';
import 'package:finwizz/viewModel/stock_news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import 'search_screen.dart';

class PortfolioNewsScreen extends StatefulWidget {
  PortfolioNewsScreen({
    super.key,
  });

  @override
  State<PortfolioNewsScreen> createState() => _PortfolioNewsScreenState();
}

class _PortfolioNewsScreenState extends State<PortfolioNewsScreen> {
  List<String> categories = [
    'Company \nupdates',
    'Results',
    'Sectoral',
    'Economic',
  ];

  int selected = 0;

  bool isFavourite = true;

  StockNewsViewModel stockNewsViewModel = Get.put(StockNewsViewModel());
  LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
  FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());

  @override
  void initState() {
    stockNewsViewModel.stockNewsViewModel();

    super.initState();

    log('TOKEN :- ${GetStorageServices.getBarrierToken()}');
  }

  List showDate = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockNewsViewModel>(builder: (controller) {
      if (controller.stockNewsApiResponse.status == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (controller.stockNewsApiResponse.status == Status.COMPLETE) {
        StockNewsResponseModel resp = controller.stockNewsApiResponse.data;

        showDate.clear();

        resp.data!.forEach(
          (element) {
            if (controller.newsIndicator != 10) {
              if (showDate.contains(
                          element!.createdAt.toString().split(' ').first) ==
                      false &&
                  element.type == controller.newsIndicator) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            } else {
              if (showDate.contains(
                      element!.createdAt.toString().split(' ').first) ==
                  false) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            }
          },
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.commonSizedBox(height: 20),
            resp.data!.length > 0
                ? Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 9),
                        itemCount: showDate.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index1) {
                          var dateData = showDate[index1];
                          var currentDate =
                              DateTime.now().toString().split(' ').first;
                          var yesterday = DateTime.now()
                              .subtract(Duration(days: 1))
                              .toString()
                              .split(' ')
                              .first;
                          return Column(
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
                              ListView.builder(
                                itemCount: resp.data!.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var time = DateFormat('kk:mm:a')
                                      .format(resp.data![index]!.createdAt!);
                                  var date = DateFormat.yMMMEd()
                                      .format(resp.data![index]!.createdAt!)
                                      .toString()
                                      .split(', ')[1];
                                  return controller.newsIndicator == 10
                                      ? resp.data![index]!.createdAt
                                                  .toString()
                                                  .split(' ')
                                                  .first ==
                                              showDate[index1]
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: resp.data![index]!
                                                              .type ==
                                                          1
                                                      ? Colors.green.shade500
                                                      : resp.data![index]!
                                                                  .type ==
                                                              -1
                                                          ? Colors.red.shade500
                                                          : Colors.blue,
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
                                                            '${resp.data![index]!.title}',
                                                        color: Colors.black),
                                                    CommonWidget.commonSizedBox(
                                                        height: 15),
                                                    CommonWidget.commonSizedBox(
                                                        height: 15),
                                                    CommonText.textBoldWight500(
                                                        color:
                                                            Color(0xff394452),
                                                        fontSize: 10.sp,
                                                        text:
                                                            "${resp.data![index]!.description}"),
                                                    CommonWidget.commonSizedBox(
                                                        height: 6),
                                                    CommonWidget.commonSizedBox(
                                                        height: 10),
                                                    Row(
                                                      children: [
                                                        InkResponse(
                                                          onTap: () async {
                                                            if (GetStorageServices
                                                                    .getUserLoggedInStatus() ==
                                                                true) {
                                                              if (resp
                                                                      .data![
                                                                          index]!
                                                                      .isLiked ==
                                                                  false) {
                                                                await likeUnLikeViewModel
                                                                    .likeUnLikeViewModel(
                                                                        body: {
                                                                      "type":
                                                                          "like",
                                                                      "newsId":
                                                                          "${resp.data![index]!.id}"
                                                                    });
                                                              } else if (resp
                                                                      .data![
                                                                          index]!
                                                                      .isLiked ==
                                                                  true) {
                                                                await likeUnLikeViewModel
                                                                    .likeUnLikeViewModel(
                                                                        body: {
                                                                      "type":
                                                                          "unlike",
                                                                      "newsId":
                                                                          "${resp.data![index]!.id}"
                                                                    });
                                                              }
                                                            } else {
                                                              CommonWidget.getSnackBar(
                                                                  color: Colors
                                                                      .red
                                                                      .withOpacity(
                                                                          .5),
                                                                  duration: 2,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  title:
                                                                      "Want to like news ??",
                                                                  message:
                                                                      'Need to login first, Please complete login steps');
                                                            }
                                                            await stockNewsViewModel
                                                                .stockNewsViewModel(
                                                                    isLoading:
                                                                        false);
                                                          },
                                                          child: Icon(
                                                            resp.data![index]!
                                                                        .isLiked ==
                                                                    true
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
                                                        CommonText.textBoldWight700(
                                                            text: resp
                                                                        .data![
                                                                            index]!
                                                                        .likes !=
                                                                    null
                                                                ? '${resp.data![index]!.likes}'
                                                                : "0",
                                                            color:
                                                                Colors.black),
                                                        Spacer(),
                                                        InkResponse(
                                                          onTap: () async {
                                                            if (GetStorageServices
                                                                    .getUserLoggedInStatus() ==
                                                                true) {
                                                              if (resp
                                                                      .data![
                                                                          index]!
                                                                      .isFavourite ==
                                                                  false) {
                                                                await favUnFavViewModel
                                                                    .favUnFavViewModel(
                                                                        body: {
                                                                      "type":
                                                                          "favourite",
                                                                      "newsId":
                                                                          "${resp.data![index]!.id}"
                                                                    });
                                                              } else if (resp
                                                                      .data![
                                                                          index]!
                                                                      .isFavourite ==
                                                                  true) {
                                                                await favUnFavViewModel
                                                                    .favUnFavViewModel(
                                                                        body: {
                                                                      "type":
                                                                          "unfavourite",
                                                                      "newsId":
                                                                          "${resp.data![index]!.id}"
                                                                    });
                                                              }
                                                            } else {
                                                              CommonWidget.getSnackBar(
                                                                  color: Colors
                                                                      .red
                                                                      .withOpacity(
                                                                          .5),
                                                                  duration: 2,
                                                                  colorText:
                                                                      Colors
                                                                          .white,
                                                                  title:
                                                                      "Want to save news ??",
                                                                  message:
                                                                      'Need to login first, Please complete login steps');
                                                            }
                                                            await stockNewsViewModel
                                                                .stockNewsViewModel(
                                                                    isLoading:
                                                                        false);
                                                          },
                                                          child: Icon(
                                                            resp.data![index]!
                                                                        .isFavourite ==
                                                                    true
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
                                                            '${date},  ${time} ·|  ${resp.data![index]!.source != null ? "Source : ${resp.data![index]!.source}" : ""}',
                                                        color: Colors.black),
                                                    CommonWidget.commonSizedBox(
                                                        height: 10),
                                                  ]),
                                            )
                                          : SizedBox()
                                      : resp.data![index]!.type ==
                                              controller.newsIndicator
                                          ? resp.data![index]!.createdAt
                                                      .toString()
                                                      .split(' ')
                                                      .first ==
                                                  showDate[index1]
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 20),
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: resp.data![index]!
                                                                  .type ==
                                                              1
                                                          ? Colors
                                                              .green.shade500
                                                          : resp.data![index]!
                                                                      .type ==
                                                                  -1
                                                              ? Colors
                                                                  .red.shade500
                                                              : Colors.blue,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                  ),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 10),
                                                        CommonText.textBoldWight700(
                                                            text:
                                                                '${resp.data![index]!.title}',
                                                            color:
                                                                Colors.black),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 15),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 15),
                                                        CommonText.textBoldWight500(
                                                            color: Color(
                                                                0xff394452),
                                                            fontSize: 10.sp,
                                                            text:
                                                                "${resp.data![index]!.description}"),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 6),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 10),
                                                        Row(
                                                          children: [
                                                            InkResponse(
                                                              onTap: () async {
                                                                if (GetStorageServices
                                                                        .getUserLoggedInStatus() ==
                                                                    true) {
                                                                  if (resp
                                                                          .data![
                                                                              index]!
                                                                          .isLiked ==
                                                                      false) {
                                                                    await likeUnLikeViewModel
                                                                        .likeUnLikeViewModel(
                                                                            body: {
                                                                          "type":
                                                                              "like",
                                                                          "newsId":
                                                                              "${resp.data![index]!.id}"
                                                                        });
                                                                  } else if (resp
                                                                          .data![
                                                                              index]!
                                                                          .isLiked ==
                                                                      true) {
                                                                    await likeUnLikeViewModel
                                                                        .likeUnLikeViewModel(
                                                                            body: {
                                                                          "type":
                                                                              "unlike",
                                                                          "newsId":
                                                                              "${resp.data![index]!.id}"
                                                                        });
                                                                  }
                                                                } else {
                                                                  CommonWidget.getSnackBar(
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              .5),
                                                                      duration:
                                                                          2,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      title:
                                                                          "Want to like news ??",
                                                                      message:
                                                                          'Need to login first, Please complete login steps');
                                                                }
                                                                await stockNewsViewModel
                                                                    .stockNewsViewModel(
                                                                        isLoading:
                                                                            false);
                                                              },
                                                              child: Icon(
                                                                resp.data![index]!.isLiked ==
                                                                        true
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                color: CommonColor
                                                                    .yellowColorFFB800,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            CommonText.textBoldWight700(
                                                                text: resp
                                                                            .data![
                                                                                index]!
                                                                            .likes !=
                                                                        null
                                                                    ? '${resp.data![index]!.likes}'
                                                                    : "0",
                                                                color: Colors
                                                                    .black),
                                                            Spacer(),
                                                            InkResponse(
                                                              onTap: () async {
                                                                if (GetStorageServices
                                                                        .getUserLoggedInStatus() ==
                                                                    true) {
                                                                  if (resp
                                                                          .data![
                                                                              index]!
                                                                          .isFavourite ==
                                                                      false) {
                                                                    await favUnFavViewModel
                                                                        .favUnFavViewModel(
                                                                            body: {
                                                                          "type":
                                                                              "favourite",
                                                                          "newsId":
                                                                              "${resp.data![index]!.id}"
                                                                        });
                                                                  } else if (resp
                                                                          .data![
                                                                              index]!
                                                                          .isFavourite ==
                                                                      true) {
                                                                    await favUnFavViewModel
                                                                        .favUnFavViewModel(
                                                                            body: {
                                                                          "type":
                                                                              "unfavourite",
                                                                          "newsId":
                                                                              "${resp.data![index]!.id}"
                                                                        });
                                                                  }
                                                                } else {
                                                                  CommonWidget.getSnackBar(
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              .5),
                                                                      duration:
                                                                          2,
                                                                      colorText:
                                                                          Colors
                                                                              .white,
                                                                      title:
                                                                          "Want to save news ??",
                                                                      message:
                                                                          'Need to login first, Please complete login steps');
                                                                }
                                                                await stockNewsViewModel
                                                                    .stockNewsViewModel(
                                                                        isLoading:
                                                                            false);
                                                              },
                                                              child: Icon(
                                                                resp.data![index]!.isFavourite ==
                                                                        true
                                                                    ? Icons
                                                                        .bookmark
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
                                                                Share.share(
                                                                    "Test");
                                                              },
                                                              child: Icon(
                                                                Icons.share,
                                                                color: CommonColor
                                                                    .yellowColorFFB800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 10),
                                                        CommonText.textBoldWight400(
                                                            text:
                                                                '${date},  ${time} ·|  ${resp.data![index]!.source != null ? "Source : ${resp.data![index]!.source}" : ""}',
                                                            color:
                                                                Colors.black),
                                                        CommonWidget
                                                            .commonSizedBox(
                                                                height: 10),
                                                      ]),
                                                )
                                              : SizedBox()
                                          : SizedBox();
                                },
                              )
                            ],
                          );
                        }))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 85.sp, bottom: 20.sp),
                        child: Center(
                          child: CommonText.textBoldWight500(
                              fontSize: 12.sp,
                              text:
                                  "Please add your portfolio stocks and\nkeep updated with what’s happening\n                     in the company"),
                        ),
                      ),
                      SizedBox(
                        height: 50.sp,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => SearchScreen());
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: CommonText.textBoldWight700(
                                  text: 'ADD STOCKS',
                                  fontSize: 10.sp,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CommonColor.themColor9295E2)),
                        ),
                      ),
                    ],
                  ),
          ],
        );
      } else
        return SizedBox();
    });
  }
}
