import 'dart:developer';

import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_all_news_categories_res_model.dart';
import 'package:finwizz/Models/responseModel/get_all_news_data.dart';
import 'package:finwizz/Models/responseModel/search_news_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/api_const.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
import 'package:finwizz/viewModel/get_all_news_categories_view_model.dart';
import 'package:finwizz/viewModel/get_all_news_view_model.dart';
import 'package:finwizz/viewModel/like_unlike_view_model.dart';
import 'package:finwizz/viewModel/search_news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class NewsScreen extends StatefulWidget {
  final bool? isCategoryVisible;
  final bool? isLoading;
  final String? searchText;
  SearchNewsResponseModel? response;

  NewsScreen(
      {super.key,
      this.isCategoryVisible = false,
      this.isLoading = false,
      this.response,
      this.searchText});

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

  GetAllNewsViewModel getAllNewsViewModel = Get.put(GetAllNewsViewModel());
  GetAllNewsCategoriesViewModel getAllNewsCategoriesViewModel =
      Get.put(GetAllNewsCategoriesViewModel());
  SearchNewsViewModel searchNewsViewModel = Get.put(SearchNewsViewModel());
  LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
  FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());

  @override
  void initState() {
    getAllNewsCategoriesViewModel.getNewsCategoriesViewModel();
    getNewsByPage(catId: "", isRefresh: true);
    super.initState();

    log('TOKEN :- ${GetStorageServices.getBarrierToken()}');
  }

  List showDate = [];
  List showSearchDate = [];

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int currentNews = 10;
  int currentPage = 1;
  late int totalNews;
  List<News> news = [];

  Future<bool> getNewsByPage(
      {String? catId,
      bool isRefresh = false,
      bool isLike = false,
      bool isFavourite = false,
      int? index,
      bool? like,
      bool? fav}) async {
    if (isRefresh) {
      currentPage = 1;
    } else {
      if (currentPage >= totalNews) {
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse('${APIConst.baseUrl}' +
        '${APIConst.getAllNews}' +
        '?categoryId=${catId}' +
        '&limit=${currentNews}&page=${currentPage}');

    Map<String, String> headers = GetStorageServices.getBarrierToken() != null
        ? {
            'Authorization': 'Bearer ${GetStorageServices.getBarrierToken()}',
            'Content-Type': 'application/json'
          }
        : {'Content-Type': 'application/json'};

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final result = getAllNewsModelFromJson(response.body);

      news.addAll(result!.data!);

      if (isLike) {
        news[index!] = News(
          id: news[index].id,
          createdAt: news[index].createdAt,
          updatedAt: news[index].updatedAt,
          title: news[index].title,
          type: news[index].type,
          description: news[index].description,
          categoryId: news[index].categoryId,
          companyId: news[index].companyId,
          isLiked: like,
          isFavourite: news[index].isFavourite,
          likes: like == true ? news[index].likes! + 1 : news[index].likes! - 1,
          generic: news[index].generic,
          source: news[index].source,
        );
      }

      if (isFavourite) {
        news[index!] = News(
          id: news[index].id,
          createdAt: news[index].createdAt,
          updatedAt: news[index].updatedAt,
          title: news[index].title,
          type: news[index].type,
          description: news[index].description,
          categoryId: news[index].categoryId,
          companyId: news[index].companyId,
          isLiked: news[index].isLiked,
          isFavourite: fav,
          likes: news[index].likes,
          generic: news[index].generic,
          source: news[index].source,
        );
      }

      currentPage = currentPage + 1;
      totalNews = 10;
      print(response.body);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAllNewsCategoriesViewModel>(builder: (controllerCat) {
      if (controllerCat.getNewsCategoriesApiResponse.status == Status.LOADING) {
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

        showDate.clear();

        news.forEach(
          (element) {
            if (controllerCat.newsIndicator != 10) {
              if (showDate.contains(
                          element.createdAt.toString().split(' ').first) ==
                      false &&
                  element.type == controllerCat.newsIndicator) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            } else {
              if (showDate.contains(
                      element.createdAt.toString().split(' ').first) ==
                  false) {
                showDate.add(element.createdAt.toString().split(' ').first);
              }
            }
          },
        );

        showSearchDate.clear();

        if (!widget.isCategoryVisible!) {
          widget.response?.data!.forEach((element) {
            if (showSearchDate
                    .contains(element.createdAt.toString().split(' ').first) ==
                false) {
              showSearchDate.add(element.createdAt.toString().split(' ').first);
            }
          });
        }
        return !widget.isLoading!
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 20),
                  widget.isCategoryVisible!
                      ? SizedBox(
                          height: 40.sp,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(left: 30),
                            itemCount: resp.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () async {
                                setState(() {
                                  selected = index;
                                });
                                news.clear();
                                await getNewsByPage(
                                    catId: "${resp.data![selected].sId}",
                                    isRefresh: true);
                                // getAllNewsViewModel.getNewsViewModel(
                                //     isLoading: false,
                                //     catId: "${resp.data![selected].sId}");
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                // height: 40.sp,
                                // width: 80.sp,
                                decoration: BoxDecoration(
                                  color: selected == index
                                      ? Color(0xffdddef6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xffdddef6), width: 1),
                                ),
                                child: CommonText.textBoldWight500(
                                    text: "${resp.data![index].name}",
                                    fontSize: 9.sp),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  CommonWidget.commonSizedBox(height: 10),
                  widget.isCategoryVisible!
                      ? Expanded(
                          child: SmartRefresher(
                            controller: refreshController,
                            physics: BouncingScrollPhysics(),
                            enablePullUp: true,
                            onRefresh: () async {
                              news.clear();

                              final result = await getNewsByPage(
                                  isRefresh: true,
                                  catId: "${resp.data![selected].sId}");

                              if (result) {
                                return refreshController.refreshCompleted();
                              } else {
                                return refreshController.refreshFailed();
                              }
                            },
                            onLoading: () async {
                              final result = await getNewsByPage(
                                  catId: "${resp.data![selected].sId}");

                              if (result) {
                                return refreshController.loadComplete();
                              } else {
                                return refreshController.loadFailed();
                              }
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 9),
                                itemCount: showDate.length,
                                shrinkWrap: true,
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
                                        itemCount: news.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var time = DateFormat('kk:mm:a')
                                              .format(news[index].createdAt!);
                                          var date = DateFormat.yMMMEd()
                                              .format(news[index].createdAt!)
                                              .toString()
                                              .split(', ')[1];
                                          return controllerCat.newsIndicator ==
                                                  10
                                              ? news[index]
                                                          .createdAt
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Color(0xffD1CDCD),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 10),
                                                            CommonText
                                                                .textBoldWight700(
                                                                    text:
                                                                        '${news[index].title}',
                                                                    color: Colors
                                                                        .black),
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 15),
                                                            CommonText.textBoldWight400(
                                                                text: news[index]
                                                                            .companyId !=
                                                                        null
                                                                    ? '${news[index].companyId!.name}'
                                                                    : "-",
                                                                color: Colors
                                                                    .black),
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 15),
                                                            CommonText.textBoldWight500(
                                                                color: Color(
                                                                    0xff394452),
                                                                fontSize: 13.sp,
                                                                text:
                                                                    "${news[index].description}"),
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 6),
                                                            // CommonText.textBoldWight500(
                                                            //     fontSize: 10.sp,
                                                            //     color: Color(0xff394452),
                                                            //     text:
                                                            //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 10),
                                                            Row(
                                                              children: [
                                                                InkResponse(
                                                                  onTap:
                                                                      () async {
                                                                    // controller.updateLike(
                                                                    //     response.data![index].isLiked!);
                                                                    if (GetStorageServices
                                                                            .getUserLoggedInStatus() ==
                                                                        true) {
                                                                      if (news[index]
                                                                              .isLiked ==
                                                                          false) {
                                                                        await likeUnLikeViewModel.likeUnLikeViewModel(
                                                                            body: {
                                                                              "type": "like",
                                                                              "newsId": "${news[index].id}"
                                                                            });

                                                                        if (likeUnLikeViewModel.likeUnlikeApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          await getNewsByPage(
                                                                              isRefresh: false,
                                                                              catId: "${resp.data![selected].sId}",
                                                                              isLike: true,
                                                                              index: index,
                                                                              like: true);
                                                                        }
                                                                        if (likeUnLikeViewModel.likeUnlikeApiResponse.status ==
                                                                            Status.ERROR) {}
                                                                      } else if (news[index]
                                                                              .isLiked ==
                                                                          true) {
                                                                        await likeUnLikeViewModel.likeUnLikeViewModel(
                                                                            body: {
                                                                              "type": "unlike",
                                                                              "newsId": "${news[index].id}"
                                                                            });
                                                                        if (likeUnLikeViewModel.likeUnlikeApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          await getNewsByPage(
                                                                              isRefresh: false,
                                                                              catId: "${resp.data![selected].sId}",
                                                                              isLike: true,
                                                                              index: index,
                                                                              like: false);
                                                                        }
                                                                        if (likeUnLikeViewModel.likeUnlikeApiResponse.status ==
                                                                            Status.ERROR) {}
                                                                      }
                                                                    } else {
                                                                      CommonWidget.getSnackBar(
                                                                          color: Colors.red.withOpacity(
                                                                              .5),
                                                                          duration:
                                                                              2,
                                                                          colorText: Colors
                                                                              .white,
                                                                          title:
                                                                              "Want to like news ??",
                                                                          message:
                                                                              'Need to login first, Please complete login steps');
                                                                    }
                                                                    /*            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.COMPLETE) {}
                            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.ERROR) {
                              CommonWidget.getSnackBar(
                                  color: Colors.red,
                                  duration: 2,
                                  colorText: Colors.white,
                                  title: "Refresh Page",
                                  message: 'Try Again.');
                            }*/
                                                                  },
                                                                  child: Icon(
                                                                    news[index].isLiked ==
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
                                                                    text: news[index].likes !=
                                                                            null
                                                                        ? '${news[index].likes}'
                                                                        : "0",
                                                                    color: Colors
                                                                        .black),
                                                                Spacer(),
                                                                InkResponse(
                                                                  onTap:
                                                                      () async {
                                                                    if (GetStorageServices
                                                                            .getUserLoggedInStatus() ==
                                                                        true) {
                                                                      if (news[index]
                                                                              .isFavourite ==
                                                                          false) {
                                                                        await favUnFavViewModel.favUnFavViewModel(
                                                                            body: {
                                                                              "type": "favourite",
                                                                              "newsId": "${news[index].id}"
                                                                            });
                                                                        if (favUnFavViewModel.favUnFavApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          // CommonWidget.getSnackBar(
                                                                          //     color: Colors.green,
                                                                          //     duration: 2,
                                                                          //     colorText:
                                                                          //         Colors.white,
                                                                          //     title:
                                                                          //         "isFavourite",
                                                                          //     message:
                                                                          //         'You liked a post');
                                                                          await getNewsByPage(
                                                                              isRefresh: false,
                                                                              catId: "${resp.data![selected].sId}",
                                                                              isFavourite: true,
                                                                              fav: true,
                                                                              index: index);
                                                                        }
                                                                        if (favUnFavViewModel.favUnFavApiResponse.status ==
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
                                                                      } else if (news[index]
                                                                              .isFavourite ==
                                                                          true) {
                                                                        await favUnFavViewModel.favUnFavViewModel(
                                                                            body: {
                                                                              "type": "unfavourite",
                                                                              "newsId": "${news[index].id}"
                                                                            });
                                                                        if (favUnFavViewModel.favUnFavApiResponse.status ==
                                                                            Status.COMPLETE) {
                                                                          await getNewsByPage(
                                                                              isRefresh: false,
                                                                              catId: "${resp.data![selected].sId}",
                                                                              isFavourite: true,
                                                                              fav: false,
                                                                              index: index);
                                                                        }
                                                                        if (favUnFavViewModel.favUnFavApiResponse.status ==
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
                                                                    } else {
                                                                      CommonWidget.getSnackBar(
                                                                          color: Colors.red.withOpacity(
                                                                              .5),
                                                                          duration:
                                                                              2,
                                                                          colorText: Colors
                                                                              .white,
                                                                          title:
                                                                              "Want to save news ??",
                                                                          message:
                                                                              'Need to login first, Please complete login steps');
                                                                    }

                                                                    /*  if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.COMPLETE) {}
                            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.ERROR) {
                              CommonWidget.getSnackBar(
                                  color: Colors.red,
                                  duration: 2,
                                  colorText: Colors.white,
                                  title: "Refresh Page",
                                  message: 'Try Again.');
                            }*/
                                                                  },
                                                                  child: Icon(
                                                                    news[index].isFavourite ==
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
                                                            CommonText
                                                                .textBoldWight400(
                                                                    text:
                                                                        '${date},  ${time} ·|  ${news[index].source != null ? "Source : ${news[index].source}" : ""}',
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10.sp),
                                                            CommonWidget
                                                                .commonSizedBox(
                                                                    height: 10),
                                                          ]),
                                                    )
                                                  : news[index].type ==
                                                          controllerCat
                                                              .newsIndicator
                                                      ? news[index]
                                                                  .createdAt
                                                                  .toString()
                                                                  .split(' ')
                                                                  .first ==
                                                              showDate[index1]
                                                          ? Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      bottom:
                                                                          20),
                                                              width: double
                                                                  .infinity,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Color(
                                                                      0xffD1CDCD),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            14),
                                                              ),
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                10),
                                                                    CommonText.textBoldWight700(
                                                                        text:
                                                                            '${news[index].title}',
                                                                        color: Colors
                                                                            .black),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                15),
                                                                    // CommonText.textBoldWight400(
                                                                    //     text: 'TANLA', color: Colors.black),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                15),
                                                                    CommonText.textBoldWight500(
                                                                        color: Color(
                                                                            0xff394452),
                                                                        fontSize: 13
                                                                            .sp,
                                                                        text:
                                                                            "${news[index].description}"),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                6),
                                                                    // CommonText.textBoldWight500(
                                                                    //     fontSize: 10.sp,
                                                                    //     color: Color(0xff394452),
                                                                    //     text:
                                                                    //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                10),
                                                                    Row(
                                                                      children: [
                                                                        InkResponse(
                                                                          onTap:
                                                                              () async {
                                                                            // controller.updateLike(
                                                                            //     response.data![index].isLiked!);

                                                                            if (GetStorageServices.getUserLoggedInStatus() ==
                                                                                true) {
                                                                              if (news[index].isLiked == false) {
                                                                                await likeUnLikeViewModel.likeUnLikeViewModel(body: {
                                                                                  "type": "like",
                                                                                  "newsId": "${news[index].id}"
                                                                                });

                                                                                if (likeUnLikeViewModel.likeUnlikeApiResponse.status == Status.COMPLETE) {
                                                                                  await getNewsByPage(isRefresh: false, catId: "${resp.data![selected].sId}", isLike: true, index: index, like: true);
                                                                                }
                                                                                if (likeUnLikeViewModel.likeUnlikeApiResponse.status == Status.ERROR) {}
                                                                              } else if (news[index].isLiked == true) {
                                                                                await likeUnLikeViewModel.likeUnLikeViewModel(body: {
                                                                                  "type": "unlike",
                                                                                  "newsId": "${news[index].id}"
                                                                                });
                                                                                if (likeUnLikeViewModel.likeUnlikeApiResponse.status == Status.COMPLETE) {
                                                                                  await getNewsByPage(isRefresh: false, catId: "${resp.data![selected].sId}", isLike: true, index: index, like: false);
                                                                                }
                                                                                if (likeUnLikeViewModel.likeUnlikeApiResponse.status == Status.ERROR) {}
                                                                              }
                                                                            } else {
                                                                              CommonWidget.getSnackBar(color: Colors.red.withOpacity(.5), duration: 2, colorText: Colors.white, title: "Want to like news ??", message: 'Need to login first, Please complete login steps');
                                                                            }

                                                                            /*            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.COMPLETE) {}
                            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.ERROR) {
                              CommonWidget.getSnackBar(
                                  color: Colors.red,
                                  duration: 2,
                                  colorText: Colors.white,
                                  title: "Refresh Page",
                                  message: 'Try Again.');
                            }*/
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            news[index].isLiked == true
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
                                                                            color:
                                                                                CommonColor.yellowColorFFB800,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        CommonText.textBoldWight400(
                                                                            text: news[index].likes != null
                                                                                ? '${news[index].likes}'
                                                                                : "0",
                                                                            color:
                                                                                Colors.black),
                                                                        Spacer(),
                                                                        InkResponse(
                                                                          onTap:
                                                                              () async {
                                                                            if (GetStorageServices.getUserLoggedInStatus() ==
                                                                                true) {
                                                                              if (news[index].isFavourite == false) {
                                                                                await favUnFavViewModel.favUnFavViewModel(body: {
                                                                                  "type": "favourite",
                                                                                  "newsId": "${news[index].id}"
                                                                                });
                                                                                if (favUnFavViewModel.favUnFavApiResponse.status == Status.COMPLETE) {
                                                                                  // CommonWidget.getSnackBar(
                                                                                  //     color: Colors.green,
                                                                                  //     duration: 2,
                                                                                  //     colorText:
                                                                                  //         Colors.white,
                                                                                  //     title:
                                                                                  //         "isFavourite",
                                                                                  //     message:
                                                                                  //         'You liked a post');
                                                                                  await getNewsByPage(isRefresh: false, catId: "${resp.data![selected].sId}", isFavourite: true, fav: true, index: index);
                                                                                }
                                                                                if (favUnFavViewModel.favUnFavApiResponse.status == Status.ERROR) {
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
                                                                              } else if (news[index].isFavourite == true) {
                                                                                await favUnFavViewModel.favUnFavViewModel(body: {
                                                                                  "type": "unfavourite",
                                                                                  "newsId": "${news[index].id}"
                                                                                });
                                                                                if (favUnFavViewModel.favUnFavApiResponse.status == Status.COMPLETE) {
                                                                                  await getNewsByPage(isRefresh: false, catId: "${resp.data![selected].sId}", isFavourite: true, fav: false, index: index);
                                                                                }
                                                                                if (favUnFavViewModel.favUnFavApiResponse.status == Status.ERROR) {
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
                                                                            } else {
                                                                              CommonWidget.getSnackBar(color: Colors.red.withOpacity(.5), duration: 2, colorText: Colors.white, title: "Want to save news ??", message: 'Need to login first, Please complete login steps');
                                                                            }

                                                                            /*  if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.COMPLETE) {}
                            if (getAllNewsViewModel.getNewsApiResponse.status ==
                                Status.ERROR) {
                              CommonWidget.getSnackBar(
                                  color: Colors.red,
                                  duration: 2,
                                  colorText: Colors.white,
                                  title: "Refresh Page",
                                  message: 'Try Again.');
                            }*/
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            news[index].isFavourite == true
                                                                                ? Icons.bookmark
                                                                                : Icons.bookmark_outline_sharp,
                                                                            color:
                                                                                CommonColor.yellowColorFFB800,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        InkResponse(
                                                                          onTap:
                                                                              () {
                                                                            Share.share("Test");
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.share,
                                                                            color:
                                                                                CommonColor.yellowColorFFB800,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                10),
                                                                    CommonText.textBoldWight400(
                                                                        text:
                                                                            '${date},  ${time} ·|  ${news[index].source != null ? "Source : ${news[index].source}" : ""}',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            10.sp),
                                                                    CommonWidget
                                                                        .commonSizedBox(
                                                                            height:
                                                                                10),
                                                                  ]),
                                                            )
                                                          : SizedBox()
                                                      : SizedBox()
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
                                }),
                          ),
                        )
                      : SizedBox(),
                  !widget.isCategoryVisible!
                      ? Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 9),
                              itemCount: showSearchDate.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index1) {
                                var dateData = showSearchDate[index1];
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
                                      itemCount: widget.response!.data!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        var time = DateFormat('kk:mm:a').format(
                                            widget.response!.data![index]
                                                .createdAt!);
                                        var date = DateFormat.yMMMEd()
                                            .format(widget.response!
                                                .data![index].createdAt!)
                                            .toString()
                                            .split(', ')[1];
                                        return Container(
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
                                                        '${widget.response!.data![index].title}',
                                                    color: Colors.black),
                                                CommonWidget.commonSizedBox(
                                                    height: 15),
                                                CommonWidget.commonSizedBox(
                                                    height: 15),
                                                CommonText.textBoldWight500(
                                                    color: Color(0xff394452),
                                                    fontSize: 10.sp,
                                                    text:
                                                        "${widget.response!.data![index].description}"),
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
                                                          if (widget
                                                                  .response!
                                                                  .data![index]
                                                                  .isLiked ==
                                                              false) {
                                                            await likeUnLikeViewModel
                                                                .likeUnLikeViewModel(
                                                                    body: {
                                                                  "type":
                                                                      "like",
                                                                  "newsId":
                                                                      "${widget.response!.data![index].id}"
                                                                });

                                                            if (likeUnLikeViewModel
                                                                    .likeUnlikeApiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              /*await getNewsByPage(
                                                                  isRefresh:
                                                                      false,
                                                                  catId:
                                                                      "${resp.data![selected].sId}",
                                                                  isLike: true,
                                                                  index: index,
                                                                  like: true);*/
                                                            }
                                                            if (likeUnLikeViewModel
                                                                    .likeUnlikeApiResponse
                                                                    .status ==
                                                                Status.ERROR) {}
                                                          } else if (widget
                                                                  .response!
                                                                  .data![index]
                                                                  .isLiked ==
                                                              true) {
                                                            await likeUnLikeViewModel
                                                                .likeUnLikeViewModel(
                                                                    body: {
                                                                  "type":
                                                                      "unlike",
                                                                  "newsId":
                                                                      "${widget.response!.data![index].id}"
                                                                });
                                                            if (likeUnLikeViewModel
                                                                    .likeUnlikeApiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              /* await getNewsByPage(
                                                                  isRefresh:
                                                                      false,
                                                                  catId:
                                                                      "${resp.data![selected].sId}",
                                                                  isLike: true,
                                                                  index: index,
                                                                  like: false);*/
                                                            }
                                                            if (likeUnLikeViewModel
                                                                    .likeUnlikeApiResponse
                                                                    .status ==
                                                                Status.ERROR) {}
                                                          }
                                                        } else {
                                                          CommonWidget.getSnackBar(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      .5),
                                                              duration: 2,
                                                              colorText:
                                                                  Colors.white,
                                                              title:
                                                                  "Want to like news ??",
                                                              message:
                                                                  'Need to login first, Please complete login steps');
                                                        }
                                                        await searchNewsViewModel
                                                            .searchNewsViewModel(
                                                                searchText: widget
                                                                    .searchText!,
                                                                isLoading:
                                                                    false);
                                                        if (searchNewsViewModel
                                                                .searchNewsApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          widget.response =
                                                              searchNewsViewModel
                                                                  .searchNewsApiResponse
                                                                  .data;
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Icon(
                                                        widget
                                                                    .response!
                                                                    .data![
                                                                        index]
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
                                                        text: widget
                                                                    .response!
                                                                    .data![
                                                                        index]
                                                                    .likes !=
                                                                null
                                                            ? '${widget.response!.data![index].likes}'
                                                            : "0",
                                                        color: Colors.black),
                                                    Spacer(),
                                                    InkResponse(
                                                      onTap: () async {
                                                        if (GetStorageServices
                                                                .getUserLoggedInStatus() ==
                                                            true) {
                                                          if (widget
                                                                  .response!
                                                                  .data![index]
                                                                  .isFavourite ==
                                                              false) {
                                                            await favUnFavViewModel
                                                                .favUnFavViewModel(
                                                                    body: {
                                                                  "type":
                                                                      "favourite",
                                                                  "newsId":
                                                                      "${widget.response!.data![index].id}"
                                                                });
                                                            if (favUnFavViewModel
                                                                    .favUnFavApiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              await getNewsByPage(
                                                                  isRefresh:
                                                                      false,
                                                                  catId:
                                                                      "${resp.data![selected].sId}",
                                                                  isFavourite:
                                                                      true,
                                                                  fav: true,
                                                                  index: index);
                                                            }
                                                            if (favUnFavViewModel
                                                                    .favUnFavApiResponse
                                                                    .status ==
                                                                Status.ERROR) {}
                                                          } else if (widget
                                                                  .response!
                                                                  .data![index]
                                                                  .isFavourite ==
                                                              true) {
                                                            await favUnFavViewModel
                                                                .favUnFavViewModel(
                                                                    body: {
                                                                  "type":
                                                                      "unfavourite",
                                                                  "newsId":
                                                                      "${widget.response!.data![index].id}"
                                                                });
                                                            if (favUnFavViewModel
                                                                    .favUnFavApiResponse
                                                                    .status ==
                                                                Status
                                                                    .COMPLETE) {
                                                              await getNewsByPage(
                                                                  isRefresh:
                                                                      false,
                                                                  catId:
                                                                      "${resp.data![selected].sId}",
                                                                  isFavourite:
                                                                      true,
                                                                  fav: false,
                                                                  index: index);
                                                            }
                                                            if (favUnFavViewModel
                                                                    .favUnFavApiResponse
                                                                    .status ==
                                                                Status.ERROR) {}
                                                          }
                                                        } else {
                                                          CommonWidget.getSnackBar(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      .5),
                                                              duration: 2,
                                                              colorText:
                                                                  Colors.white,
                                                              title:
                                                                  "Want to save news ??",
                                                              message:
                                                                  'Need to login first, Please complete login steps');
                                                        }
                                                        await searchNewsViewModel
                                                            .searchNewsViewModel(
                                                                searchText: widget
                                                                    .searchText!,
                                                                isLoading:
                                                                    false);
                                                        if (searchNewsViewModel
                                                                .searchNewsApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {
                                                          widget.response =
                                                              searchNewsViewModel
                                                                  .searchNewsApiResponse
                                                                  .data;
                                                          setState(() {});
                                                        }
                                                      },
                                                      child: Icon(
                                                        widget
                                                                    .response!
                                                                    .data![
                                                                        index]
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
                                                        '${date},  ${time} ·|  ${news[index].source != null ? "Source : ${news[index].source}" : ""}',
                                                    color: Colors.black,
                                                    fontSize: 10.sp),
                                                CommonWidget.commonSizedBox(
                                                    height: 10),
                                              ]),
                                        );
                                      },
                                    )
                                  ],
                                );
                              }),
                        )
                      : SizedBox()
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      } else
        return SizedBox();
    });
  }
}
