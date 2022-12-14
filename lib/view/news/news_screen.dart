import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_all_news_categories_res_model.dart';
import 'package:finwizz/Models/responseModel/get_all_news_data.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
import 'package:finwizz/viewModel/get_all_news_categories_view_model.dart';
import 'package:finwizz/viewModel/get_all_news_view_model.dart';
import 'package:finwizz/viewModel/like_unlike_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../constant/image_const.dart';

class NewsScreen extends StatefulWidget {
  final bool? isCategoryVisible;

  const NewsScreen({super.key, this.isCategoryVisible = false});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<String> categories = [
    'Company \nupdates',
    'Results',
    'Sectoral',
    'Economic',
  ];

  int selected = 0;

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
  GetAllNewsViewModel getAllNewsViewModel = Get.put(GetAllNewsViewModel());
  GetAllNewsCategoriesViewModel getAllNewsCategoriesViewModel =
      Get.put(GetAllNewsCategoriesViewModel());
  LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
  FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());

  @override
  void initState() {
    getAllNewsViewModel.getNewsViewModel(
      catId: "",
    );
    getAllNewsCategoriesViewModel.getNewsCategoriesViewModel();
    super.initState();
  }

  List? showDate = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child:
          GetBuilder<GetAllNewsCategoriesViewModel>(builder: (controllerCat) {
        if (controllerCat.getNewsCategoriesApiResponse.status ==
            Status.LOADING) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controllerCat.getNewsCategoriesApiResponse.status ==
            Status.COMPLETE) {
          GetAllNewsCategoriesResponseModel resp =
              controllerCat.getNewsCategoriesApiResponse.data;

          if (resp.data!.elementAt(0).name != "All" &&
              resp.data!.elementAt(0).sId != "") {
            resp.data!.insert(
                0,
                Data(
                    name: "All",
                    sId: "",
                    updatedAt: "${DateTime.now()}",
                    createdAt: "${DateTime.now()}"));
          }

          print('Cat ====== > ${resp.data!.length}');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.commonSizedBox(height: 20),
              SizedBox(
                height: 40.sp,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 30),
                  itemCount: resp.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                      getAllNewsViewModel.getNewsViewModel(
                          isLoading: false,
                          catId: "${resp.data![selected].sId}");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      // height: 40.sp,
                      // width: 80.sp,
                      decoration: BoxDecoration(
                        color: selected == index
                            ? Color(0xffdddef6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xffdddef6), width: 1),
                      ),
                      child: CommonText.textBoldWight500(
                          text: "${resp.data![index].name}", fontSize: 9.sp),
                    ),
                  ),
                ),
              ),
              CommonWidget.commonSizedBox(height: 10),
              GetBuilder<GetAllNewsViewModel>(
                builder: (controller) {
                  if (controller.getNewsApiResponse.status == Status.LOADING) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (controller.getNewsApiResponse.status == Status.COMPLETE) {
                    GetAllNewsModel response =
                        controller.getNewsApiResponse.data;

                    showDate!.clear();

                    response.data!.forEach(
                      (element) {
                        if (showDate!.contains(element.createdAt
                                .toString()
                                .split(' ')
                                .first) ==
                            false) {
                          showDate!.add(
                              element.createdAt.toString().split(' ').first);
                        }
                      },
                    );
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 9),
                        itemCount: showDate!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index1) {
                          var dateData = showDate![index1];
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: response.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var time = DateFormat('kk:mm:a')
                                      .format(response.data![index].createdAt!);
                                  var date = DateFormat.yMMMEd()
                                      .format(response.data![index].createdAt!)
                                      .toString()
                                      .split(', ')[1];
                                  return response.data![index].createdAt
                                              .toString()
                                              .split(' ')
                                              .first ==
                                          showDate![index1]
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 20),
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
                                                // CommonText.textBoldWight400(
                                                //     text: 'TANLA', color: Colors.black),
                                                CommonWidget.commonSizedBox(
                                                    height: 15),
                                                CommonText.textBoldWight500(
                                                    color: Color(0xff394452),
                                                    fontSize: 10.sp,
                                                    text:
                                                        "${response.data![index].description}"),
                                                CommonWidget.commonSizedBox(
                                                    height: 6),
                                                // CommonText.textBoldWight500(
                                                //     fontSize: 10.sp,
                                                //     color: Color(0xff394452),
                                                //     text:
                                                //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                                CommonWidget.commonSizedBox(
                                                    height: 10),
                                                Row(
                                                  children: [
                                                    InkResponse(
                                                      onTap: () async {
                                                        // controller.updateLike(
                                                        //     response.data![index].isLiked!);
                                                        if (response
                                                                .data![index]
                                                                .isLiked ==
                                                            false) {
                                                          await likeUnLikeViewModel
                                                              .likeUnLikeViewModel(
                                                                  body: {
                                                                "type": "like",
                                                                "newsId":
                                                                    "${response.data![index].id}"
                                                              });

                                                          if (likeUnLikeViewModel
                                                                  .likeUnlikeApiResponse
                                                                  .status ==
                                                              Status
                                                                  .COMPLETE) {}
                                                          if (likeUnLikeViewModel
                                                                  .likeUnlikeApiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            // CommonWidget.getSnackBar(
                                                            //     color: Colors.red,
                                                            //     duration: 2,
                                                            //     colorText:
                                                            //         Colors.white,
                                                            //     title:
                                                            //         "Something went wrong",
                                                            //     message:
                                                            //         'Try Again.');
                                                          }
                                                        } else if (response
                                                                .data![index]
                                                                .isLiked ==
                                                            true) {
                                                          await likeUnLikeViewModel
                                                              .likeUnLikeViewModel(
                                                                  body: {
                                                                "type":
                                                                    "unlike",
                                                                "newsId":
                                                                    "${response.data![index].id}"
                                                              });
                                                          if (likeUnLikeViewModel
                                                                  .likeUnlikeApiResponse
                                                                  .status ==
                                                              Status
                                                                  .COMPLETE) {}
                                                          if (likeUnLikeViewModel
                                                                  .likeUnlikeApiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            // CommonWidget.getSnackBar(
                                                            //     color: Colors.red,
                                                            //     duration: 2,
                                                            //     colorText:
                                                            //         Colors.white,
                                                            //     title:
                                                            //         "Something went wrong",
                                                            //     message:
                                                            //         'Try Again.');
                                                          }
                                                        }
                                                        await getAllNewsViewModel
                                                            .getNewsViewModel(
                                                                isLoading:
                                                                    false,
                                                                catId:
                                                                    "${resp.data![selected].sId}");
                                                        if (getAllNewsViewModel
                                                                .getNewsApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {}
                                                        if (getAllNewsViewModel
                                                                .getNewsApiResponse
                                                                .status ==
                                                            Status.ERROR) {
                                                          CommonWidget.getSnackBar(
                                                              color: Colors.red,
                                                              duration: 2,
                                                              colorText:
                                                                  Colors.white,
                                                              title:
                                                                  "Refresh Page",
                                                              message:
                                                                  'Try Again.');
                                                        }
                                                      },
                                                      child: Icon(
                                                        response.data![index]
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
                                                    CommonText.textBoldWight400(
                                                        text: response
                                                                    .data![
                                                                        index]
                                                                    .likes !=
                                                                null
                                                            ? '${response.data![index].likes}'
                                                            : "0",
                                                        color: Colors.black),
                                                    Spacer(),
                                                    InkResponse(
                                                      onTap: () async {
                                                        if (response
                                                                .data![index]
                                                                .isFavourite ==
                                                            false) {
                                                          await favUnFavViewModel
                                                              .favUnFavViewModel(
                                                                  body: {
                                                                "type":
                                                                    "favourite",
                                                                "newsId":
                                                                    "${response.data![index].id}"
                                                              });
                                                          if (favUnFavViewModel
                                                                  .favUnFavApiResponse
                                                                  .status ==
                                                              Status
                                                                  .COMPLETE) {}
                                                          if (favUnFavViewModel
                                                                  .favUnFavApiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            // CommonWidget.getSnackBar(
                                                            //     color: Colors.red,
                                                            //     duration: 2,
                                                            //     colorText:
                                                            //         Colors.white,
                                                            //     title:
                                                            //         "Something went wrong",
                                                            //     message:
                                                            //         'Try Again.');
                                                          }
                                                        } else if (response
                                                                .data![index]
                                                                .isFavourite ==
                                                            true) {
                                                          await favUnFavViewModel
                                                              .favUnFavViewModel(
                                                                  body: {
                                                                "type":
                                                                    "unfavourite",
                                                                "newsId":
                                                                    "${response.data![index].id}"
                                                              });
                                                          if (favUnFavViewModel
                                                                  .favUnFavApiResponse
                                                                  .status ==
                                                              Status
                                                                  .COMPLETE) {}
                                                          if (favUnFavViewModel
                                                                  .favUnFavApiResponse
                                                                  .status ==
                                                              Status.ERROR) {
                                                            // CommonWidget.getSnackBar(
                                                            //     color: Colors.red,
                                                            //     duration: 2,
                                                            //     colorText:
                                                            //         Colors.white,
                                                            //     title:
                                                            //         "Something went wrong",
                                                            //     message:
                                                            //         'Try Again.');
                                                          }
                                                        }
                                                        await getAllNewsViewModel
                                                            .getNewsViewModel(
                                                                isLoading:
                                                                    false,
                                                                catId:
                                                                    "${resp.data![selected].sId}");
                                                        if (getAllNewsViewModel
                                                                .getNewsApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {}
                                                        if (getAllNewsViewModel
                                                                .getNewsApiResponse
                                                                .status ==
                                                            Status.ERROR) {
                                                          CommonWidget.getSnackBar(
                                                              color: Colors.red,
                                                              duration: 2,
                                                              colorText:
                                                                  Colors.white,
                                                              title:
                                                                  "Refresh Page",
                                                              message:
                                                                  'Try Again.');
                                                        }
                                                      },
                                                      child: Icon(
                                                        response.data![index]
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
                                                        '${date},  ${time} ·| Source : BSE',
                                                    color: Colors.black),
                                                CommonWidget.commonSizedBox(
                                                    height: 10),
                                              ]),
                                        )
                                      : SizedBox();
                                },
                              )
                            ],
                          );
                          //   Column(
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 20, horizontal: 20),
                          //       child: Column(
                          //         children: [
                          //           Divider(
                          //             color: Color(0xffD1CDCD),
                          //             height: 0,
                          //           ),
                          //           SizedBox(
                          //             height: 5,
                          //           ),
                          //           Row(
                          //             children: [
                          //               CommonWidget.commonSvgPitcher(
                          //                   image: ImageConst.calender,
                          //                   height: 20.sp,
                          //                   width: 20.sp),
                          //               SizedBox(width: 10),
                          //               CommonText.textBoldWight500(text: 'Today')
                          //             ],
                          //           ),
                          //           SizedBox(
                          //             height: 5,
                          //           ),
                          //           Divider(
                          //             color: Color(0xffD1CDCD),
                          //             height: 0,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.symmetric(horizontal: 20),
                          //       width: double.infinity,
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: 20, vertical: 10),
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           color: Color(0xffD1CDCD),
                          //         ),
                          //         borderRadius: BorderRadius.circular(14),
                          //       ),
                          //       child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             CommonWidget.commonSizedBox(height: 10),
                          //             CommonText.textBoldWight700(
                          //                 text: '${response.data![index1].title}',
                          //                 color: Colors.black),
                          //             CommonWidget.commonSizedBox(height: 15),
                          //             // CommonText.textBoldWight400(
                          //             //     text: 'TANLA', color: Colors.black),
                          //             CommonWidget.commonSizedBox(height: 15),
                          //             CommonText.textBoldWight500(
                          //                 color: Color(0xff394452),
                          //                 fontSize: 10.sp,
                          //                 text:
                          //                     "${response.data![index1].description}"),
                          //             CommonWidget.commonSizedBox(height: 6),
                          //             // CommonText.textBoldWight500(
                          //             //     fontSize: 10.sp,
                          //             //     color: Color(0xff394452),
                          //             //     text:
                          //             //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                          //             CommonWidget.commonSizedBox(height: 10),
                          //             Row(
                          //               children: [
                          //                 InkResponse(
                          //                   onTap: () {
                          //                     setState(() {
                          //                       isFavourite = !isFavourite;
                          //                     });
                          //                   },
                          //                   child: Icon(
                          //                     isFavourite == true
                          //                         ? Icons.favorite
                          //                         : Icons.favorite_border,
                          //                     color: CommonColor.yellowColorFFB800,
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   width: 10,
                          //                 ),
                          //                 CommonText.textBoldWight400(
                          //                     text: '120.1K', color: Colors.black),
                          //                 Spacer(),
                          //                 InkResponse(
                          //                   onTap: () {
                          //                     setState(() {
                          //                       isFavourite1 = !isFavourite1;
                          //                     });
                          //                   },
                          //                   child: Icon(
                          //                     isFavourite1 == true
                          //                         ? Icons.bookmark
                          //                         : Icons.bookmark_outline_sharp,
                          //                     color: CommonColor.yellowColorFFB800,
                          //                   ),
                          //                 ),
                          //                 SizedBox(
                          //                   width: 10,
                          //                 ),
                          //                 InkResponse(
                          //                   onTap: () {
                          //                     Share.share("Test");
                          //                   },
                          //                   child: Icon(
                          //                     Icons.share,
                          //                     color: CommonColor.yellowColorFFB800,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //             CommonWidget.commonSizedBox(height: 10),
                          //             CommonText.textBoldWight400(
                          //                 text: 'Sep 7,  12:38 ·| Source : BSE',
                          //                 color: Colors.black),
                          //             CommonWidget.commonSizedBox(height: 10),
                          //           ]),
                          //     ),
                          //   ],
                          // );
                        });
                  }
                  return Center(
                    child: Text('Something went wrong'),
                  );
                },
              )
            ],
          );
        } else
          return SizedBox();
      }),
    );
  }
}
