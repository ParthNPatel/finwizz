// import 'dart:developer';
//
// import 'package:finwizz/Models/apis/api_response.dart';
// import 'package:finwizz/Models/responseModel/get_all_news_data.dart';
// import 'package:finwizz/constant/color_const.dart';
// import 'package:finwizz/constant/text_styel.dart';
// import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
// import 'package:finwizz/viewModel/get_all_news_view_model.dart';
// import 'package:finwizz/viewModel/like_unlike_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../components/common_widget.dart';
// import '../../constant/image_const.dart';
// import '../../controller/handle_screen_controller.dart';
// import '../Home/home_screen.dart';
//
// class BookMarkScreen extends StatefulWidget {
//   const BookMarkScreen({Key? key}) : super(key: key);
//
//   @override
//   State<BookMarkScreen> createState() => _BookMarkScreenState();
// }
//
// class _BookMarkScreenState extends State<BookMarkScreen>
//     with SingleTickerProviderStateMixin {
//   final globalKey = GlobalKey<ScaffoldState>();
//
//   List listOfNews = [
//     {
//       'image': ImageConst.newsIcon,
//       'title': 'News',
//       'text': 'News that moves stocks'
//     },
//     {
//       'image': ImageConst.bagIcon,
//       'title': 'Portfolio protection',
//       'text': 'Invest on information. Sell on information'
//     }
//   ];
//   List listOfNews1 = [
//     {
//       'image': ImageConst.calender,
//       'title': 'Today',
//     },
//     {
//       'image': ImageConst.calender,
//       'title': 'Yesterday',
//     },
//     {
//       'image': ImageConst.calender,
//       'title': 'Wed, 05 Sep 2022',
//     }
//   ];
//
//   bool isFavourite = true;
//   bool isFavourite1 = true;
//   GetAllNewsViewModel getAllNewsViewModel = Get.put(GetAllNewsViewModel());
//   LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
//   FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());
//   List? showDate = [];
//
//   HandleScreenController controller = Get.find();
//   @override
//   void initState() {
//     getAllNewsViewModel.getNewsViewModel();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         controller.changeTapped(false);
//         return false;
//       },
//       child: Scaffold(
//         key: globalKey,
//         drawer: DrawerWidget(),
//         body: SafeArea(
//           child: Column(
//             children: [
//               CommonWidget.commonSizedBox(height: 10),
//               appWidget(),
//               CommonWidget.commonSizedBox(height: 10),
//               Expanded(
//                 child: GetBuilder<GetAllNewsViewModel>(
//                   builder: (controller) {
//                     if (controller.getNewsApiResponse.status ==
//                         Status.LOADING) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (controller.getNewsApiResponse.status ==
//                         Status.COMPLETE) {
//                       GetAllNewsModel response =
//                           controller.getNewsApiResponse.data;
//                       var notData = response.data;
//
//                       notData!.forEach(
//                         (element) {
//                           if (showDate!.contains(
//                               element.createdAt.toString().split(' ').first)) {
//                             log('ADDED');
//                           } else {
//                             showDate!.add(
//                                 element.createdAt.toString().split(' ').first);
//                           }
//                         },
//                       );
//                       return ListView.builder(
//                         padding: EdgeInsets.symmetric(horizontal: 9),
//                         itemCount: showDate!.length,
//                         shrinkWrap: true,
//                         // physics: NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index1) {
//                           var dateData = showDate![index1];
//                           var currentDate =
//                               DateTime.now().toString().split(' ').first;
//                           var yesterday = DateTime.now()
//                               .subtract(Duration(days: 1))
//                               .toString()
//                               .split(' ')
//                               .first;
//
//                           return Column(
//                             children: [
//                               Divider(
//                                 color: Color(0xffD1CDCD),
//                                 height: 0,
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Row(
//                                 children: [
//                                   CommonWidget.commonSvgPitcher(
//                                       image: ImageConst.calender,
//                                       height: 20.sp,
//                                       width: 20.sp),
//                                   SizedBox(width: 10),
//                                   CommonText.textBoldWight500(
//                                     text: dateData == currentDate
//                                         ? 'Today'
//                                         : dateData == yesterday
//                                             ? 'yesterday'
//                                             : '${dateData}',
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Divider(
//                                 color: Color(0xffD1CDCD),
//                                 height: 0,
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               ListView.builder(
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: response.data!.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   var time = DateFormat('kk:mm:a')
//                                       .format(response.data![index].createdAt!);
//                                   var date = DateFormat.yMMMEd()
//                                       .format(response.data![index].createdAt!)
//                                       .toString()
//                                       .split(', ')[1];
//                                   return response.data![index].createdAt
//                                                   .toString()
//                                                   .split(' ')
//                                                   .first ==
//                                               showDate![index1] &&
//                                           response.data![index].isFavourite ==
//                                               true
//                                       ? Container(
//                                           margin: EdgeInsets.only(
//                                               left: 20, right: 20, bottom: 20),
//                                           width: double.infinity,
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 20, vertical: 10),
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Color(0xffD1CDCD),
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(14),
//                                           ),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               CommonWidget.commonSizedBox(
//                                                   height: 10),
//                                               CommonText.textBoldWight700(
//                                                   text:
//                                                       '${response.data![index].title}',
//                                                   color: Colors.black),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 15),
//                                               // CommonText.textBoldWight400(
//                                               //     text: 'TANLA', color: Colors.black),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 15),
//                                               CommonText.textBoldWight500(
//                                                   color: Color(0xff394452),
//                                                   fontSize: 10.sp,
//                                                   text:
//                                                       "${response.data![index].description}"),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 6),
//                                               // CommonText.textBoldWight500(
//                                               //     fontSize: 10.sp,
//                                               //     color: Color(0xff394452),
//                                               //     text:
//                                               //         "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 10),
//                                               Row(
//                                                 children: [
//                                                   InkResponse(
//                                                     onTap: () async {
//                                                       // controller.updateLike(
//                                                       //     response.data![index].isLiked!);
//
//                                                       if (response.data![index]
//                                                               .isLiked ==
//                                                           false) {
//                                                         await likeUnLikeViewModel
//                                                             .likeUnLikeViewModel(
//                                                                 body: {
//                                                               "type": "like",
//                                                               "newsId":
//                                                                   "${response.data![index].id}"
//                                                             });
//
//                                                         if (likeUnLikeViewModel
//                                                                 .likeUnlikeApiResponse
//                                                                 .status ==
//                                                             Status.COMPLETE) {}
//                                                         if (likeUnLikeViewModel
//                                                                 .likeUnlikeApiResponse
//                                                                 .status ==
//                                                             Status.ERROR) {
//                                                           CommonWidget.getSnackBar(
//                                                               color: Colors.red,
//                                                               duration: 2,
//                                                               colorText:
//                                                                   Colors.white,
//                                                               title:
//                                                                   "Something went wrong",
//                                                               message:
//                                                                   'Try Again.');
//                                                         }
//                                                       } else if (response
//                                                               .data![index]
//                                                               .isLiked ==
//                                                           true) {
//                                                         await likeUnLikeViewModel
//                                                             .likeUnLikeViewModel(
//                                                                 body: {
//                                                               "type": "unlike",
//                                                               "newsId":
//                                                                   "${response.data![index].id}"
//                                                             });
//                                                         if (likeUnLikeViewModel
//                                                                 .likeUnlikeApiResponse
//                                                                 .status ==
//                                                             Status.COMPLETE) {}
//                                                         if (likeUnLikeViewModel
//                                                                 .likeUnlikeApiResponse
//                                                                 .status ==
//                                                             Status.ERROR) {
//                                                           CommonWidget.getSnackBar(
//                                                               color: Colors.red,
//                                                               duration: 2,
//                                                               colorText:
//                                                                   Colors.white,
//                                                               title:
//                                                                   "Something went wrong",
//                                                               message:
//                                                                   'Try Again.');
//                                                         }
//                                                       }
//                                                       await getAllNewsViewModel
//                                                           .getNewsViewModel(
//                                                               isLoading: false);
//                                                       if (getAllNewsViewModel
//                                                               .getNewsApiResponse
//                                                               .status ==
//                                                           Status.COMPLETE) {}
//                                                       if (getAllNewsViewModel
//                                                               .getNewsApiResponse
//                                                               .status ==
//                                                           Status.ERROR) {
//                                                         CommonWidget.getSnackBar(
//                                                             color: Colors.red,
//                                                             duration: 2,
//                                                             colorText:
//                                                                 Colors.white,
//                                                             title:
//                                                                 "Refresh Page",
//                                                             message:
//                                                                 'Try Again.');
//                                                       }
//                                                     },
//                                                     child: Icon(
//                                                       response.data![index]
//                                                                   .isLiked ==
//                                                               true
//                                                           ? Icons.favorite
//                                                           : Icons
//                                                               .favorite_border,
//                                                       color: CommonColor
//                                                           .yellowColorFFB800,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   CommonText.textBoldWight400(
//                                                       text: '120.1K',
//                                                       color: Colors.black),
//                                                   Spacer(),
//                                                   InkResponse(
//                                                     onTap: () async {
//                                                       if (response.data![index]
//                                                               .isFavourite ==
//                                                           false) {
//                                                         await favUnFavViewModel
//                                                             .favUnFavViewModel(
//                                                                 body: {
//                                                               "type":
//                                                                   "favourite",
//                                                               "newsId":
//                                                                   "${response.data![index].id}"
//                                                             });
//                                                         if (favUnFavViewModel
//                                                                 .favUnFavApiResponse
//                                                                 .status ==
//                                                             Status.COMPLETE) {}
//                                                         if (favUnFavViewModel
//                                                                 .favUnFavApiResponse
//                                                                 .status ==
//                                                             Status.ERROR) {
//                                                           CommonWidget.getSnackBar(
//                                                               color: Colors.red,
//                                                               duration: 2,
//                                                               colorText:
//                                                                   Colors.white,
//                                                               title:
//                                                                   "Something went wrong",
//                                                               message:
//                                                                   'Try Again.');
//                                                         }
//                                                       } else if (response
//                                                               .data![index]
//                                                               .isFavourite ==
//                                                           true) {
//                                                         await favUnFavViewModel
//                                                             .favUnFavViewModel(
//                                                                 body: {
//                                                               "type":
//                                                                   "unfavourite",
//                                                               "newsId":
//                                                                   "${response.data![index].id}"
//                                                             });
//                                                         if (favUnFavViewModel
//                                                                 .favUnFavApiResponse
//                                                                 .status ==
//                                                             Status.COMPLETE) {}
//                                                         if (favUnFavViewModel
//                                                                 .favUnFavApiResponse
//                                                                 .status ==
//                                                             Status.ERROR) {
//                                                           CommonWidget.getSnackBar(
//                                                               color: Colors.red,
//                                                               duration: 2,
//                                                               colorText:
//                                                                   Colors.white,
//                                                               title:
//                                                                   "Something went wrong",
//                                                               message:
//                                                                   'Try Again.');
//                                                         }
//                                                       }
//                                                       await getAllNewsViewModel
//                                                           .getNewsViewModel(
//                                                               isLoading: false);
//                                                       if (getAllNewsViewModel
//                                                               .getNewsApiResponse
//                                                               .status ==
//                                                           Status.COMPLETE) {}
//                                                       if (getAllNewsViewModel
//                                                               .getNewsApiResponse
//                                                               .status ==
//                                                           Status.ERROR) {
//                                                         CommonWidget.getSnackBar(
//                                                             color: Colors.red,
//                                                             duration: 2,
//                                                             colorText:
//                                                                 Colors.white,
//                                                             title:
//                                                                 "Refresh Page",
//                                                             message:
//                                                                 'Try Again.');
//                                                       }
//                                                     },
//                                                     child: Icon(
//                                                       response.data![index]
//                                                                   .isFavourite ==
//                                                               true
//                                                           ? Icons.bookmark
//                                                           : Icons
//                                                               .bookmark_outline_sharp,
//                                                       color: CommonColor
//                                                           .yellowColorFFB800,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   InkResponse(
//                                                     onTap: () {
//                                                       Share.share("Test");
//                                                     },
//                                                     child: Icon(
//                                                       Icons.share,
//                                                       color: CommonColor
//                                                           .yellowColorFFB800,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 10),
//                                               CommonText.textBoldWight400(
//                                                   text:
//                                                       '${date},  ${time} ·| Source : BSE',
//                                                   color: Colors.black),
//                                               CommonWidget.commonSizedBox(
//                                                   height: 10),
//                                             ],
//                                           ),
//                                         )
//                                       : SizedBox();
//                                 },
//                               )
//                             ],
//                           );
//                         },
//                       );
//                     }
//                     return Center(
//                       child: Text('Something went wrong'),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Row appWidget() {
//     return Row(
//       children: [
//         IconButton(
//             onPressed: () {
//               globalKey.currentState!.openDrawer();
//             },
//             icon: Icon(
//               Icons.menu_outlined,
//               size: 28.sp,
//               color: CommonColor.themColor9295E2,
//             )),
//         CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp),
//         Spacer(),
//         CommonWidget.commonSvgPitcher(
//           image: ImageConst.bookMarkFilled,
//         ),
//         CommonWidget.commonSizedBox(width: 10),
//         Container(
//             padding: EdgeInsets.all(8),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.center,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xff6E5DE7).withOpacity(0.8),
//                       Color(0xff6E5DE7).withOpacity(0.8),
//                     ]),
//                 shape: BoxShape.circle,
//                 color: CommonColor.themColor9295E2),
//             child: Image.asset(
//               'assets/png/notification.png',
//               scale: 2.6,
//             )),
//         CommonWidget.commonSizedBox(width: 10)
//       ],
//     );
//   }
// }
import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_all_news_data.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/viewModel/fav_unFav_view_model.dart';
import 'package:finwizz/viewModel/get_all_news_view_model.dart';
import 'package:finwizz/viewModel/like_unlike_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/image_const.dart';
import '../../controller/handle_screen_controller.dart';
import '../Home/home_screen.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey<ScaffoldState>();

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

  bool isFavourite = true;
  bool isFavourite1 = true;
  GetAllNewsViewModel getAllNewsViewModel = Get.put(GetAllNewsViewModel());
  LikeUnLikeViewModel likeUnLikeViewModel = Get.put(LikeUnLikeViewModel());
  FavUnFavViewModel favUnFavViewModel = Get.put(FavUnFavViewModel());
  List? showDate = [];

  HandleScreenController controller = Get.find();
  @override
  void initState() {
    getAllNewsViewModel.getNewsViewModel(catId: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.changeTapped(false);
        return false;
      },
      child: Scaffold(
        key: globalKey,
        drawer: DrawerWidget(),
        body: SafeArea(
          child: Column(
            children: [
              CommonWidget.commonSizedBox(height: 10),
              appWidget(),
              CommonWidget.commonSizedBox(height: 10),
              Expanded(
                child: GetBuilder<GetAllNewsViewModel>(
                  builder: (controller) {
                    if (controller.getNewsApiResponse.status ==
                        Status.LOADING) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (controller.getNewsApiResponse.status ==
                        Status.COMPLETE) {
                      GetAllNewsModel response =
                          controller.getNewsApiResponse.data;

                      showDate!.clear();

                      response.data!.forEach(
                        (element) {
                          if (element.isFavourite!) {
                            if (showDate!.contains(element.createdAt
                                    .toString()
                                    .split(' ')
                                    .first) ==
                                false) {
                              showDate!.add(element.createdAt
                                  .toString()
                                  .split(' ')
                                  .first);
                            }
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
                                              showDate![index1] &&
                                          response.data![index].isFavourite ==
                                              true
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
                                                      if (response.data![index]
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
                                                            Status.COMPLETE) {}
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
                                                              "type": "unlike",
                                                              "newsId":
                                                                  "${response.data![index].id}"
                                                            });
                                                        if (likeUnLikeViewModel
                                                                .likeUnlikeApiResponse
                                                                .status ==
                                                            Status.COMPLETE) {}
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
                                                              isLoading: false,
                                                              catId: "");
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
                                                      text: '120.1K',
                                                      color: Colors.black),
                                                  Spacer(),
                                                  InkResponse(
                                                    onTap: () async {
                                                      if (response.data![index]
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
                                                            Status.COMPLETE) {}
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
                                                            Status.COMPLETE) {}
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
                                                      showDate!.clear();
                                                      await getAllNewsViewModel
                                                          .getNewsViewModel(
                                                              catId: "",
                                                              isLoading: false);
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
                                            ],
                                          ),
                                        )
                                      : SizedBox();
                                },
                              )
                            ],
                          );
                        },
                      );
                    }
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row appWidget() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              globalKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu_outlined,
              size: 28.sp,
              color: CommonColor.themColor9295E2,
            )),
        CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp),
        Spacer(),
        InkWell(
          onTap: () {
            setState(() {});
            controller.changeTapped(false);
          },
          child: CommonWidget.commonSvgPitcher(
            image: ImageConst.bookMarkFilled,
          ),
        ),
        CommonWidget.commonSizedBox(width: 10),
        Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff6E5DE7).withOpacity(0.8),
                      Color(0xff6E5DE7).withOpacity(0.8),
                    ]),
                shape: BoxShape.circle,
                color: CommonColor.themColor9295E2),
            child: Image.asset(
              'assets/png/notification.png',
              scale: 5,
            )),
        CommonWidget.commonSizedBox(width: 10)
      ],
    );
  }
}
