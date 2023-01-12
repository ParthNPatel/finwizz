import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/search_news_res_model.dart';
import 'package:finwizz/Models/responseModel/single_insider_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
import 'package:finwizz/viewModel/insider_view_model.dart';
import 'package:finwizz/viewModel/like_unlike_view_model.dart';
import 'package:finwizz/viewModel/search_news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class SingleStockSceen extends StatefulWidget {
  final String companyId;
  final String companyName;

  const SingleStockSceen(
      {Key? key, required this.companyId, required this.companyName})
      : super(key: key);

  @override
  State<SingleStockSceen> createState() => _SingleStockSceenState();
}

class _SingleStockSceenState extends State<SingleStockSceen>
    with SingleTickerProviderStateMixin {
  int selected = 0;
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController!.animation!.addListener(tabListener);
    super.initState();
  }

  void tabListener() {
    if (selected != tabController!.animation!.value.round()) {
      selected = tabController!.animation!.value.round();
    }
  }

  int filterSelected = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          appWidget(),
          CommonText.textBoldWight700(
              text: "${widget.companyName}",
              color: Color(0xff9295E2),
              fontSize: 17.sp),
          tabBarTitleWidget(),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                SingleNewsScreen(
                    companyName: widget.companyName,
                    companyId: widget.companyId,
                    filterSelected: filterSelected),
                SingleInsiderScreen(
                    companyId: widget.companyId,
                    companyName: widget.companyName)
              ],
            ),
          )
        ],
      )),
    );
  }

  TabBar tabBarTitleWidget() {
    return TabBar(
      controller: tabController,
      onTap: (value) {
        selected = tabController!.index;
      },
      labelPadding: EdgeInsets.symmetric(vertical: 9.sp),
      unselectedLabelColor: Colors.black,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff9295E2), width: 4),
      ),
      tabs: [
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
          InkWell(
              onTap: () {
                Get.back();
              },
              child:
                  Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20.sp)),
          CommonText.textBoldWight700(text: 'Hello 🙌', fontSize: 16.sp),
          Spacer(),
          selected == 0
              ? InkWell(
                  onTap: () {
                    showMenu(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      color: Color(0xffE4E3E3),
                      context: context,
                      position: RelativeRect.fromLTRB(Get.width, 0, 0, 0.0),
                      items: [
                        PopupMenuItem(
                          child: Text("All"),
                          value: 0,
                          onTap: () {
                            setState(() {
                              filterSelected = 10;
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text("Positive"),
                          value: 1,
                          onTap: () {
                            setState(() {
                              filterSelected = 1;
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text("Negative"),
                          value: 2,
                          onTap: () {
                            setState(() {
                              filterSelected = -1;
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text("Neutral"),
                          value: 3,
                          onTap: () {
                            setState(() {
                              filterSelected = 0;
                            });
                          },
                        ),
                      ],
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                      child: CommonWidget.commonSvgPitcher(
                          image: ImageConst.filterIcon, color: Colors.black)),
                )
              : SizedBox(height: 45.sp, width: 45.sp),
        ],
      ),
    );
  }
}

class SingleNewsScreen extends StatefulWidget {
  final String companyId;
  final String companyName;

  final int filterSelected;

  const SingleNewsScreen(
      {Key? key,
      required this.companyId,
      required this.filterSelected,
      required this.companyName})
      : super(key: key);

  @override
  State<SingleNewsScreen> createState() => _SingleNewsScreenState();
}

class _SingleNewsScreenState extends State<SingleNewsScreen> {
  SearchNewsViewModel searchNewsViewModel = Get.put(SearchNewsViewModel());
  LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
  FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());

  List showDate = [];

  @override
  void initState() {
    // TODO: implement initState
    searchNewsViewModel.searchNewsViewModel(companyId: "${widget.companyId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchNewsViewModel>(builder: (controller) {
      if (controller.searchNewsApiResponse.status == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (controller.searchNewsApiResponse.status == Status.COMPLETE) {
        SearchNewsResponseModel response =
            controller.searchNewsApiResponse.data;

        if (response.data!.isNotEmpty && response.data! != []) {
          showDate.clear();

          response.data!.forEach((element) {
            if (widget.filterSelected != 10) {
              if (showDate.contains(
                          element!.createdAt.toString().split(' ').first) ==
                      false &&
                  element.type == widget.filterSelected) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            } else {
              if (showDate.contains(
                      element!.createdAt.toString().split(' ').first) ==
                  false) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            }
          });

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 9),
                itemCount: showDate.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index1) {
                  var dateData = showDate[index1];
                  var currentDate = DateTime.now().toString().split(' ').first;
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
                        itemCount: response.data!.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var time = DateFormat('kk:mm:a')
                              .format(response.data![index]!.createdAt!);
                          var date = DateFormat.yMMMEd()
                              .format(response.data![index]!.createdAt!)
                              .toString()
                              .split(', ')[1];
                          return widget.filterSelected == 10
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: response.data![index]!.type == 1
                                          ? Colors.green.shade500
                                          : response.data![index]!.type == -1
                                              ? Colors.red.shade500
                                              : Color(0xffD1CDCD),
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonWidget.commonSizedBox(height: 10),
                                        CommonText.textBoldWight700(
                                            text:
                                                '${response.data![index]!.title}',
                                            color: Colors.black),
                                        CommonWidget.commonSizedBox(height: 15),
                                        CommonWidget.commonSizedBox(height: 15),
                                        CommonText.textBoldWight500(
                                            color: Color(0xff394452),
                                            fontSize: 10.sp,
                                            text:
                                                "${response.data![index]!.description}"),
                                        CommonWidget.commonSizedBox(height: 6),
                                        CommonWidget.commonSizedBox(height: 10),
                                        Row(
                                          children: [
                                            InkResponse(
                                              onTap: () async {
                                                if (GetStorageServices
                                                        .getUserLoggedInStatus() ==
                                                    true) {
                                                  if (response.data![index]!
                                                          .generic ==
                                                      false) {
                                                    await likeUnLikeViewModel
                                                        .likeUnLikeViewModel(
                                                            body: {
                                                          "type": "like",
                                                          "newsId":
                                                              "${response.data![index]!.id}"
                                                        });

                                                    if (likeUnLikeViewModel
                                                            .likeUnlikeApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      // await getNewsByPage(
                                                      //     isRefresh: false,
                                                      //     catId:
                                                      //         "${resp.data![selected].sId}",
                                                      //     isLike: true,
                                                      //     index: index,
                                                      //     like: true);
                                                    }
                                                    if (likeUnLikeViewModel
                                                            .likeUnlikeApiResponse
                                                            .status ==
                                                        Status.ERROR) {}
                                                  } else if (response
                                                          .data![index]!
                                                          .generic ==
                                                      true) {
                                                    await likeUnLikeViewModel
                                                        .likeUnLikeViewModel(
                                                            body: {
                                                          "type": "unlike",
                                                          "newsId":
                                                              "${response.data![index]!.id}"
                                                        });
                                                    if (likeUnLikeViewModel
                                                            .likeUnlikeApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      // await getNewsByPage(
                                                      //     isRefresh: false,
                                                      //     catId:
                                                      //         "${resp.data![selected].sId}",
                                                      //     isLike: true,
                                                      //     index: index,
                                                      //     like: false);
                                                    }
                                                    if (likeUnLikeViewModel
                                                            .likeUnlikeApiResponse
                                                            .status ==
                                                        Status.ERROR) {}
                                                  }
                                                } else {
                                                  CommonWidget.getSnackBar(
                                                      color: Colors.red
                                                          .withOpacity(.5),
                                                      duration: 2,
                                                      colorText: Colors.white,
                                                      title:
                                                          "Want to like news ??",
                                                      message:
                                                          'Need to login first, Please complete login steps');
                                                }
                                              },
                                              child: Icon(
                                                response.data![index]!
                                                            .generic ==
                                                        true
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: CommonColor
                                                    .yellowColorFFB800,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            CommonText.textBoldWight400(
                                                text: response.data![index]!
                                                            .likes !=
                                                        null
                                                    ? '${response.data![index]!.likes}'
                                                    : "0",
                                                color: Colors.black),
                                            Spacer(),
                                            InkResponse(
                                              onTap: () async {
                                                if (GetStorageServices
                                                        .getUserLoggedInStatus() ==
                                                    true) {
                                                  if (response.data![index]!
                                                          .generic ==
                                                      false) {
                                                    await favUnFavViewModel
                                                        .favUnFavViewModel(
                                                            body: {
                                                          "type": "favourite",
                                                          "newsId":
                                                              "${response.data![index]!.id}"
                                                        });
                                                    if (favUnFavViewModel
                                                            .favUnFavApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      // await getNewsByPage(
                                                      //     isRefresh: false,
                                                      //     catId:
                                                      //         "${resp.data![selected].sId}",
                                                      //     isFavourite: true,
                                                      //     fav: true,
                                                      //     index: index);
                                                    }
                                                    if (favUnFavViewModel
                                                            .favUnFavApiResponse
                                                            .status ==
                                                        Status.ERROR) {}
                                                  } else if (response
                                                          .data![index]!
                                                          .generic ==
                                                      true) {
                                                    await favUnFavViewModel
                                                        .favUnFavViewModel(
                                                            body: {
                                                          "type": "unfavourite",
                                                          "newsId":
                                                              "${response.data![index]!.id}"
                                                        });
                                                    if (favUnFavViewModel
                                                            .favUnFavApiResponse
                                                            .status ==
                                                        Status.COMPLETE) {
                                                      // await getNewsByPage(
                                                      //     isRefresh: false,
                                                      //     catId:
                                                      //         "${resp.data![selected].sId}",
                                                      //     isFavourite: true,
                                                      //     fav: false,
                                                      //     index: index);
                                                    }
                                                    if (favUnFavViewModel
                                                            .favUnFavApiResponse
                                                            .status ==
                                                        Status.ERROR) {}
                                                  }
                                                } else {
                                                  CommonWidget.getSnackBar(
                                                      color: Colors.red
                                                          .withOpacity(.5),
                                                      duration: 2,
                                                      colorText: Colors.white,
                                                      title:
                                                          "Want to save news ??",
                                                      message:
                                                          'Need to login first, Please complete login steps');
                                                }
                                              },
                                              child: Icon(
                                                response.data![index]!
                                                            .generic ==
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
                                        CommonWidget.commonSizedBox(height: 10),
                                        CommonText.textBoldWight400(
                                            text:
                                                '${date},  ${time} ·|  ${response.data![index]!.source != null ? "Source : ${response.data![index]!.source}" : ""}',
                                            color: Colors.black),
                                        CommonWidget.commonSizedBox(height: 10),
                                      ]),
                                )
                              : widget.filterSelected ==
                                      response.data![index]!.type
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, bottom: 20),
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: response.data![index]!.type ==
                                                  1
                                              ? Colors.green.shade500
                                              : response.data![index]!.type ==
                                                      -1
                                                  ? Colors.red.shade500
                                                  : Color(0xffD1CDCD),
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonWidget.commonSizedBox(
                                                height: 10),
                                            CommonText.textBoldWight700(
                                                text:
                                                    '${response.data![index]!.title}',
                                                color: Colors.black),
                                            CommonWidget.commonSizedBox(
                                                height: 15),
                                            CommonWidget.commonSizedBox(
                                                height: 15),
                                            CommonText.textBoldWight500(
                                                color: Color(0xff394452),
                                                fontSize: 10.sp,
                                                text:
                                                    "${response.data![index]!.description}"),
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
                                                      if (response.data![index]!
                                                              .generic ==
                                                          false) {
                                                        await likeUnLikeViewModel
                                                            .likeUnLikeViewModel(
                                                                body: {
                                                              "type": "like",
                                                              "newsId":
                                                                  "${response.data![index]!.id}"
                                                            });

                                                        if (likeUnLikeViewModel
                                                                .likeUnlikeApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          // await getNewsByPage(
                                                          //     isRefresh: false,
                                                          //     catId:
                                                          //         "${resp.data![selected].sId}",
                                                          //     isLike: true,
                                                          //     index: index,
                                                          //     like: true);
                                                        }
                                                        if (likeUnLikeViewModel
                                                                .likeUnlikeApiResponse
                                                                .status ==
                                                            Status.ERROR) {}
                                                      } else if (response
                                                              .data![index]!
                                                              .generic ==
                                                          true) {
                                                        await likeUnLikeViewModel
                                                            .likeUnLikeViewModel(
                                                                body: {
                                                              "type": "unlike",
                                                              "newsId":
                                                                  "${response.data![index]!.id}"
                                                            });
                                                        if (likeUnLikeViewModel
                                                                .likeUnlikeApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          // await getNewsByPage(
                                                          //     isRefresh: false,
                                                          //     catId:
                                                          //         "${resp.data![selected].sId}",
                                                          //     isLike: true,
                                                          //     index: index,
                                                          //     like: false);
                                                        }
                                                        if (likeUnLikeViewModel
                                                                .likeUnlikeApiResponse
                                                                .status ==
                                                            Status.ERROR) {}
                                                      }
                                                    } else {
                                                      CommonWidget.getSnackBar(
                                                          color: Colors.red
                                                              .withOpacity(.5),
                                                          duration: 2,
                                                          colorText:
                                                              Colors.white,
                                                          title:
                                                              "Want to like news ??",
                                                          message:
                                                              'Need to login first, Please complete login steps');
                                                    }
                                                  },
                                                  child: Icon(
                                                    response.data![index]!
                                                                .generic ==
                                                            true
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: CommonColor
                                                        .yellowColorFFB800,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                CommonText.textBoldWight400(
                                                    text: response.data![index]!
                                                                .likes !=
                                                            null
                                                        ? '${response.data![index]!.likes}'
                                                        : "0",
                                                    color: Colors.black),
                                                Spacer(),
                                                InkResponse(
                                                  onTap: () async {
                                                    if (GetStorageServices
                                                            .getUserLoggedInStatus() ==
                                                        true) {
                                                      if (response.data![index]!
                                                              .generic ==
                                                          false) {
                                                        await favUnFavViewModel
                                                            .favUnFavViewModel(
                                                                body: {
                                                              "type":
                                                                  "favourite",
                                                              "newsId":
                                                                  "${response.data![index]!.id}"
                                                            });
                                                        if (favUnFavViewModel
                                                                .favUnFavApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          // await getNewsByPage(
                                                          //     isRefresh: false,
                                                          //     catId:
                                                          //         "${resp.data![selected].sId}",
                                                          //     isFavourite: true,
                                                          //     fav: true,
                                                          //     index: index);
                                                        }
                                                        if (favUnFavViewModel
                                                                .favUnFavApiResponse
                                                                .status ==
                                                            Status.ERROR) {}
                                                      } else if (response
                                                              .data![index]!
                                                              .generic ==
                                                          true) {
                                                        await favUnFavViewModel
                                                            .favUnFavViewModel(
                                                                body: {
                                                              "type":
                                                                  "unfavourite",
                                                              "newsId":
                                                                  "${response.data![index]!.id}"
                                                            });
                                                        if (favUnFavViewModel
                                                                .favUnFavApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          // await getNewsByPage(
                                                          //     isRefresh: false,
                                                          //     catId:
                                                          //         "${resp.data![selected].sId}",
                                                          //     isFavourite: true,
                                                          //     fav: false,
                                                          //     index: index);
                                                        }
                                                        if (favUnFavViewModel
                                                                .favUnFavApiResponse
                                                                .status ==
                                                            Status.ERROR) {}
                                                      }
                                                    } else {
                                                      CommonWidget.getSnackBar(
                                                          color: Colors.red
                                                              .withOpacity(.5),
                                                          duration: 2,
                                                          colorText:
                                                              Colors.white,
                                                          title:
                                                              "Want to save news ??",
                                                          message:
                                                              'Need to login first, Please complete login steps');
                                                    }
                                                  },
                                                  child: Icon(
                                                    response.data![index]!
                                                                .generic ==
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
                                                    '${date},  ${time} ·|  ${response.data![index]!.source != null ? "Source : ${response.data![index]!.source}" : ""}',
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
                }),
          );
        } else
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30.sp),
            child: Align(
              alignment: Alignment.topCenter,
              child: CommonText.textBoldWight600(
                  text: "Not have any major updates for ${widget.companyName}",
                  color: Colors.black,
                  fontSize: 14.sp),
            ),
          );
      } else
        return SizedBox();
    });
  }
}

class SingleInsiderScreen extends StatefulWidget {
  final String companyId;
  final String companyName;
  const SingleInsiderScreen(
      {Key? key, required this.companyId, required this.companyName})
      : super(key: key);

  @override
  State<SingleInsiderScreen> createState() => _SingleInsiderScreenState();
}

class _SingleInsiderScreenState extends State<SingleInsiderScreen> {
  InsiderViewModel insiderViewModel = Get.put(InsiderViewModel());

  int? viewAllIndex;
  bool isViewAll = false;

  @override
  void initState() {
    insiderViewModel.getSingleInsiderViewModel(
        companyId: "${widget.companyId}");
    super.initState();
  }

  double? bought = 30;
  double? sold = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<InsiderViewModel>(builder: (controller) {
        if (controller.getSingleInsidersApiResponse.status == Status.LOADING) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.getSingleInsidersApiResponse.status == Status.COMPLETE) {
          SingleInsiderResponseModel response =
              controller.getSingleInsidersApiResponse.data;

          if (response.data != null &&
              response.data!.insiders != null &&
              response.data!.insiders!.table!.isNotEmpty &&
              response.data!.insiders?.table != []) {
            if (response.data!.insiders != null) {
              bought = response.data!.insiders!.sharesBought!.shares! /
                  (response.data!.insiders!.sharesBought!.shares! +
                      response.data!.insiders!.sharesSold!.shares!) *
                  100;
              sold = response.data!.insiders!.sharesSold!.shares! /
                  (response.data!.insiders!.sharesBought!.shares! +
                      response.data!.insiders!.sharesSold!.shares!) *
                  100;
            }

            return Column(children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonWidget.commonDivider(),
                      Row(children: [
                        Expanded(
                            child: Container(
                          height: 120,
                          child: Column(children: [
                            CommonText.textBoldWight600(
                                text: response.data!.name!),
                            CommonWidget.commonSizedBox(height: 10),
                            CommonText.textBoldWight400(text: 'Shares sold'),
                            CommonWidget.commonSizedBox(height: 16),
                            Row(children: [
                              CommonText.textBoldWight400(
                                  text:
                                      "0${response.data!.createdAt!.difference(DateTime.now()).inDays} Days"),
                              CommonWidget.commonSizedBox(width: 7),
                              Container(
                                  height: 20,
                                  width: sold!.w / 2.5,
                                  color: CommonColor.lightRedColorFD7E7E),
                            ]),
                            CommonWidget.commonSizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonText.textBoldWight400(
                                      text:
                                          "${response.data!.insiders!.sharesSold!.shares}"),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonText.textBoldWight400(text: 'shares'),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonWidget.commonSvgPitcher(
                                      image: ImageConst.personIconApp,
                                      height: 15,
                                      color: Colors.black),
                                  CommonWidget.commonSizedBox(width: 3),
                                  CommonText.textBoldWight400(
                                      text:
                                          "${response.data!.insiders!.sharesSold!.person}"),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonWidget.commonSvgPitcher(
                                      image: ImageConst.postIconApp,
                                      height: 15,
                                      color: Colors.black),
                                  CommonWidget.commonSizedBox(width: 3),
                                  CommonText.textBoldWight400(text: "0")
                                ]),
                          ]),
                        )),
                        SizedBox(
                          height: 50,
                          child: VerticalDivider(color: Colors.black),
                        ),
                        Container(
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isViewAll = !isViewAll;
                                          });
                                        },
                                        child: Text(
                                          'View all',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              // fontSize: fontSize,
                                              fontFamily: TextConst.fontFamily,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color(0xff043278)),
                                        ),
                                      ),
                                      CommonWidget.commonSizedBox(height: 10),
                                      CommonText.textBoldWight400(
                                          text: 'Shares Bought'),
                                      CommonWidget.commonSizedBox(height: 16),
                                    ]),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: 20,
                                      width: bought!.w / 2.5,
                                      color: CommonColor.greenColor2ECC71),
                                ),
                                CommonWidget.commonSizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CommonText.textBoldWight400(
                                          text:
                                              "${response.data!.insiders!.sharesBought!.shares}"),
                                      CommonWidget.commonSizedBox(width: 5),
                                      CommonText.textBoldWight400(
                                          text: 'shares'),
                                      CommonWidget.commonSizedBox(width: 5),
                                      CommonWidget.commonSvgPitcher(
                                          image: ImageConst.personIconApp,
                                          height: 15,
                                          color: Colors.black),
                                      CommonWidget.commonSizedBox(width: 3),
                                      CommonText.textBoldWight400(
                                          text:
                                              "${response.data!.insiders!.sharesBought!.person}"),
                                      CommonWidget.commonSizedBox(width: 5),
                                      CommonWidget.commonSvgPitcher(
                                          image: ImageConst.postIconApp,
                                          height: 15,
                                          color: Colors.black),
                                      CommonWidget.commonSizedBox(width: 3),
                                      // response.data!['post'] ==
                                      //         null
                                      //     ? SizedBox()
                                      //     : CommonText
                                      //         .textBoldWight400(
                                      //             text: response.data![
                                      //                         index]
                                      //                     ['post'] ??
                                      //                 ''),
                                      CommonText.textBoldWight400(text: "0")
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      CommonWidget.commonDivider(),
                      isViewAll
                          ? Container(
                              padding: EdgeInsets.only(top: 30),
                              child: DataTable(
                                columnSpacing: 7.sp,
                                horizontalMargin: 5.sp,
                                dataTextStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: TextConst.fontFamily),
                                border: TableBorder.symmetric(
                                    inside: BorderSide(
                                        width: 1, color: Color(0xffD1CDCD)),
                                    outside: BorderSide(
                                        width: 1, color: Color(0xffD1CDCD))),
                                columns: [
                                  DataColumn(
                                      label: CommonText.textBoldWight400(
                                          text: 'Category of\nperson',
                                          fontSize: 10.sp)),
                                  DataColumn(
                                      label: CommonText.textBoldWight400(
                                          text: 'Shares', fontSize: 10.sp)),
                                  DataColumn(
                                      label: CommonText.textBoldWight400(
                                          text: 'Value', fontSize: 10.sp)),
                                  DataColumn(
                                      label: CommonText.textBoldWight400(
                                          text: 'Transaction\ntype',
                                          fontSize: 10.sp)),
                                  DataColumn(
                                      label: CommonText.textBoldWight400(
                                          text: 'Mode of\nacquisition',
                                          fontSize: 10.sp)),
                                ],
                                rows: List.generate(
                                    response.data!.insiders!.table!.length,
                                    (indexRow) =>
                                        DataRow(selected: false, cells: [
                                          DataCell(Text(
                                              '${response.data!.insiders!.table![indexRow].personCategory}')),
                                          DataCell(Text(
                                              '${response.data!.insiders!.table![indexRow].shares}')),
                                          DataCell(Text(
                                              '${response.data!.insiders!.table![indexRow].value}')),
                                          DataCell(Text(
                                              '${response.data!.insiders!.table![indexRow].transactionType}')),
                                          DataCell(Text(
                                              '${response.data!.insiders!.table![indexRow].mode}')),
                                        ])),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              )
            ]);
          } else
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30.sp),
              child: Align(
                alignment: Alignment.topCenter,
                child: CommonText.textBoldWight600(
                    text: "No insiders available for ${widget.companyName}",
                    color: Colors.black,
                    fontSize: 14.sp),
              ),
            );
        } else
          return SizedBox();
      }),
    );
  }
}
